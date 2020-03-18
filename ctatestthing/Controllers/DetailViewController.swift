//
//  DetailViewController.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    private lazy var detailView = DetailView()
    
    private lazy var barButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "heart"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(buttonPressed(_:)))
        return button
    }()
    
    var event: Event?
    var object: ArtObject?
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
        addToNav()
        configureWithEvent()
        
    }
    
    init(object: ArtObject) {
        self.object = object
        super.init(nibName: nil, bundle: nil)
        addToNav()
        configureWithObject()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addToNav()
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc private func buttonPressed(_ sender: UIBarButtonItem) {
        if let event = event {
            sender.isEnabled = false
            if barButton.image == UIImage(systemName: "heart") {
                FirestoreSession.session.addItem(event, experience: .ticketMaster) { [weak self] result in
                    sender.isEnabled = true
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    case .success:
                        DispatchQueue.main.async {
                            self?.barButton.image = UIImage(systemName: "heart.fill")
                        }
                    }
                }
            } else {
                FirestoreSession.session.deleteItem(event, experience: .ticketMaster) { [weak self] result in
                    sender.isEnabled = true
                    switch result {
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    case .success:
                        DispatchQueue.main.async {
                            self?.barButton.image = (UIImage(systemName: "heart"))
                        }
                    }
                }
            }
        } else if let object = object {
            sender.isEnabled = false
            if barButton.image == UIImage(systemName: "heart") {
                FirestoreSession.session.addItem(object, experience: .rijksMuseum) { [weak self] result in
                    sender.isEnabled = true
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    case .success:
                        DispatchQueue.main.async {
                            self?.barButton.image = UIImage(systemName: "heart.fill")
                        }
                    }
                }
            } else {
                FirestoreSession.session.deleteItem(object, experience: .rijksMuseum) { [weak self] result in
                    sender.isEnabled = true
                    switch result {
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    case .success:
                        DispatchQueue.main.async {
                            self?.barButton.image = (UIImage(systemName: "heart"))
                        }
                    }
                }
            }
        }
    }
    
    private func addToNav() {
        navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    private func configureWithEvent() {
        let event = self.event!
        detailView.configureView(event: event)
        checkIfEventIsFavorited(event: event)
    }
    
    private func configureWithObject() {
        let object = self.object!
        detailView.configureView(object: object)
        checkIfObjectIsFavorited(object: object)
    }
    
    private func checkIfEventIsFavorited(event: Event) {
        FirestoreSession.session.isItemFavorited(event, experience: .ticketMaster) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            case .success(let bool):
                DispatchQueue.main.async {
                    self?.barButton.image = bool ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
                }
            }
        }
    }
    
    private func checkIfObjectIsFavorited(object: ArtObject) {
        FirestoreSession.session.isItemFavorited(object, experience: .rijksMuseum) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            case .success(let bool):
                DispatchQueue.main.async {
                    self?.barButton.image = bool ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
                }
            }
        }
    }
    
}
