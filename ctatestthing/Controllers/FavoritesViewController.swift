//
//  FavoritesViewController.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var events = [Event]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()
    }
    
    private func loadData() {
        FirestoreSession.session.getUserExperience { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let str):
                self.experience = APIExperience(rawValue: str)!
                self.listener()
            }
        }
    }
    
    private func loadItems() {
        switch experience {
        case .rijksMuseum:
            break
        case .ticketMaster:
            FirestoreSession.session.fetchItems(type: Event.self, experience: experience) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success(let events):
                    self?.events = events
                }
            }
            
        default:
            break
        }
    }
    
    private func listener() {
        FirestoreSession.session.addListener { result in
            switch result {
            case .success(let str):
                self.experience = APIExperience(rawValue: str)!
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureView() {
        tableView.register(UINib(nibName: "TicketCell", bundle: nil), forCellReuseIdentifier: "ticketCell")
    }
    
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if experience == .ticketMaster {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as? TicketCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(events[indexPath.row], onFavorite: true)
        }
        
        return UITableViewCell()
    }
    
    
}
