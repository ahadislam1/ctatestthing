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
    
    var experience: APIExperience! {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        loadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        tableView.backgroundView = EmptyView(title: "Nothing", message: "For Ticketmaster, type in a location into the searchbar.\nFor Rijksmuseum, type in an item into the searchbar.")
        
        tableView.register(UINib(nibName: "TicketCell", bundle: nil), forCellReuseIdentifier: "ticketCell")
    }
    
    private func loadData() {
        FirestoreSession.session.getUserExperience { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let str):
                self.experience = APIExperience(rawValue: str)!
                self.listener()
                print(self.experience.description)
            }
        }
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
    
    private func listener() {
        FirestoreSession.session.addListener { result in
            switch result {
            case .success(let str):
                self.experience = APIExperience(rawValue: str)!
                print("Listener updated.")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch experience {
        case .rijksMuseum:
            return 0
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
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(event: events[indexPath.row]), animated: true)
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
            break
        case .ticketMaster:
            getEvents(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
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
