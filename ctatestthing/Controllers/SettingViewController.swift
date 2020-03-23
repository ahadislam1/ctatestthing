//
//  SettingViewController.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    weak var experienceListener: ListenerRegistration?
    
    var experience: APIExperience!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        experienceListener?.remove()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let newExperience = APIExperience.toValue(pickerView.selectedRow(inComponent: 0))
        if experience.rawValue != newExperience {
            sender.isEnabled = false
            FirestoreSession.session.updateDatabaseUser(newExperience) {[weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                        sender.isEnabled = true
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.experience = APIExperience(rawValue: newExperience)!
                        self?.showAlert(title: "Success", message: "Changed api to \(newExperience)")
                        sender.isEnabled = true
                    }
                }
            }
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        try? Auth.auth().signOut()
        UIViewController.showViewController(from: "Login", id: "loginVC")
    }
    private func configureView() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        label.text = user.email
    }
    
    private func loadData() {
        FirestoreSession.session.getUserExperience { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            case .success(let str):
                self?.experience = APIExperience(rawValue: str)!
            }
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
    }
    
}

extension SettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        APIExperience.toValue(row)
    }
    
    
}
