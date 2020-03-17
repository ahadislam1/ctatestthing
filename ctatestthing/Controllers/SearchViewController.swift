//
//  SearchViewController.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var experience: APIExperience!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        loadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadData()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
