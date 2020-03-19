//
//  FavoritesViewController.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var experienceListener: ListenerRegistration?
    weak var eventListener: ListenerRegistration?
    weak var objectListener: ListenerRegistration?
    
    var events = [Event]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        [experienceListener, objectListener, eventListener].forEach {
            $0?.remove()
        }
    }
    
    private func listener() {
        experienceListener = FirestoreSession.session.addListener { [weak self] result in
            switch result {
            case .success(let str):
                self?.experience = APIExperience(rawValue: str)!
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
        
       eventListener =  FirestoreSession.session.addListener(objectType: Event.self, experience: .ticketMaster) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            case .success(let events):
                self?.events = events
            }
        }
        
        objectListener = FirestoreSession.session.addListener(objectType: ArtObject.self, experience: .rijksMuseum) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            case .success(let objects):
                self?.objects = objects
            }
        }
    }
    
    private func configureView() {
        tableView.register(UINib(nibName: "TicketCell", bundle: nil), forCellReuseIdentifier: "ticketCell")
        
        tableView.register(UINib(nibName: "RijksCell", bundle: nil), forCellReuseIdentifier: "rijksCell")
    }
    
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        experience == .ticketMaster ? 200 : 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        experience == .ticketMaster ? events.count : objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if experience == .ticketMaster {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell", for: indexPath) as? TicketCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(events[indexPath.row], onFavorite: true)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "rijksCell", for: indexPath) as? RijksCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(object: objects[indexPath.row], onFavorite: true)
            
            return cell
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
