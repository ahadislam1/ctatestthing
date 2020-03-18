//
//  SearchViewController.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var events = [Event]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.backgroundView = nil
            }
        }
    }
    
    var objects = [ArtObject]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.backgroundColor = nil
            }
        }
    }
    
    var experience: APIExperience! {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        listener()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        listener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        tableView.backgroundView = EmptyView(title: "Nothing", message: "For Ticketmaster, type in a location into the searchbar.\nFor Rijksmuseum, type in an item into the searchbar.")
        
        tableView.register(UINib(nibName: "TicketCell", bundle: nil), forCellReuseIdentifier: "ticketCell")
        tableView.register(UINib(nibName: "RijksCell", bundle: nil), forCellReuseIdentifier: "rijksCell")
    }
    
    private func getEvents(_ query: String) {
        let url = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(Secret.ticketKey)&city=\(query)"
        
        GenericCoderAPI.manager.getJSON(objectType: Ticket.self, with: url) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            case .success(let wrapper):
                self?.events = wrapper.embedded.events
            }
        }
    }
    
    private func getObjects(_ query: String) {
        let url = "https://www.rijksmuseum.nl/api/nl/collection?key=\(Secret.rijksKey)&culture=en&imgonly=True&q=\(query)"
        
        GenericCoderAPI.manager.getJSON(objectType: Art.self, with: url) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            case .success(let wrapper):
                self?.objects = wrapper.artObjects
            }
        }
    }
    
    private func listener() {
        FirestoreSession.session.addListener { result in
            switch result {
            case .success(let str):
                self.experience = APIExperience(rawValue: str)!
                print("Listener updated on SearchVC.")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        experience == .ticketMaster ? 200 : 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch experience {
        case .rijksMuseum:
            return objects.count
        case .ticketMaster:
            return events.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch experience {
        case .ticketMaster:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as? TicketCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configureCell(events[indexPath.row], onFavorite: false)
            return cell
        case .rijksMuseum:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "rijksCell", for: indexPath) as? RijksCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configureCell(object: objects[indexPath.row], onFavorite: false)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if experience == .ticketMaster {
        navigationController?.pushViewController(DetailViewController(event: events[indexPath.row]), animated: true)
        } else {
            navigationController?.pushViewController(DetailViewController(object: objects[indexPath.row]), animated: true)
        }
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty, let experience = experience else {
            return
        }
        
        switch experience {
        case .rijksMuseum:
            getObjects(text.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        case .ticketMaster:
            getEvents(text.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
    }
}

extension SearchViewController: TicketCellDelegate {
    func didSelectTicket(_ ticketCell: TicketCell, ticket: Event) {
        
        if ticketCell.favoriteButton.imageView?.image == UIImage(systemName: "heart") {
            
            FirestoreSession.session.addItem(ticket, experience: .ticketMaster) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        ticketCell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                }
            }
            
        } else {
            
            FirestoreSession.session.deleteItem(ticket, experience: .ticketMaster) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        ticketCell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                }
            }
        }
    }
}

extension SearchViewController: RijksCellDelegate {
    func didPressButton(cell: RijksCell, object: ArtObject) {
        if cell.button.imageView?.image == UIImage(systemName: "heart") {
            
            FirestoreSession.session.addItem(object, experience: .rijksMuseum) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        cell.button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                }
            }
            
        } else {
            
            FirestoreSession.session.deleteItem(object, experience: .rijksMuseum) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        cell.button.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                }
            }
        }
    }
    
    
}
