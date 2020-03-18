//
//  LoginViewController.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var weakLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    
    var accountState: AccountState = .newUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                errorLabel.text = "Fields are empty."
                errorLabel.isHidden = false
                return
        }
        
        userFlow(email, password: password)
        
    }
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        
        accountState = accountState == .newUser ? .existingUser : .newUser
        switch accountState {
        case .existingUser:
            signButton.setTitle("Login", for: .normal)
            weakLabel.text = "No account?"
            changeButton.setTitle("SIGNUP", for: .normal)
        case .newUser:
            signButton.setTitle("Signup", for: .normal)
            weakLabel.text = "Already account?"
            changeButton.setTitle("LOGIN", for: .normal)
        }
        
    }
    
    private func userFlow(_ email: String, password: String) {
        
        if accountState == .newUser {
            AuthSession.shared.createNewUser(email, password: password) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLabel.text = error.localizedDescription
                        self?.errorLabel.isHidden = false
                    }
                case .success(let result):
                    print(result.description)
                    self?.createDatabaseUser(result)
                }
            }
        } else {
            AuthSession.shared.signExistingUser(email, password: password) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLabel.text = error.localizedDescription
                        self?.errorLabel.isHidden = false
                    }
                case .success(let result):
                    print(result.description)
                    UIViewController.showViewController(from: "Main", id: "tabBC")
                }
            }
        }
    }
    
    private func createDatabaseUser(_ authDataResult: AuthDataResult) {
        
        let apiExperience = APIExperience.toValue(pickerView.selectedRow(inComponent: 0))
        FirestoreSession.session.createDatabaseUser(authDataResult: authDataResult, apiExperience: apiExperience) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            case .success(let bool):
                print(bool)
                UIViewController.showViewController(from: "Main", id: "tabBC")
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        APIExperience.toValue(row)
    }
}
