//
//  SettingViewController.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
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
    
    private func configureView() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        label.text = user.email
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
