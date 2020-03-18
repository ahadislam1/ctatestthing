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
                self?.showAlert(title: "Error", message: error.localizedDescription)
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as? TicketmasterCell else {
                return UITableViewCell()
            }
            cell.configureCell(events[indexPath.row])
            return cell
        default:
            return UITableViewCell()
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
            break
        case .ticketMaster:
            getEvents(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
    }
}
