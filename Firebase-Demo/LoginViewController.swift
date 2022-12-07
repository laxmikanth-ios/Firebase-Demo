//
//  ViewController.swift
//  Firebase-Demo
//
//  Created by Laxmikanth Reddy on 03/12/22.
//

import UIKit

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var accountStateButton: UIButton!
    @IBOutlet weak var accountStateMessageLabel: UILabel!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    private var accountState: AccountState = .existingUser
    
    private var authSession = AuthenticationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearErrorLabel()
        
    }
    
    private func clearErrorLabel() {
        errorLbl.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTF.text,
              !email.isEmpty,
              let password = passwordTF.text,
              !password.isEmpty else {
            print("missing fields")
            return
        }
        continueLoginFlow(email: email, password: password)
    }
    
    private func continueLoginFlow(email: String, password: String) {
        if accountState == .existingUser {
            authSession.createExistingUser(email: email, password: password) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLbl.text = "\(error.localizedDescription)"
                        self?.errorLbl.textColor = .systemRed
                    }
                case .success(let authDataResult):
                    DispatchQueue.main.async {
                        self?.errorLbl.text = "Welcome back user with email: \(authDataResult.user.email ?? "")"
                    }
                }
            }
        }else {
            authSession.createNewUser(email: email, password: password) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLbl.text = "\(error.localizedDescription)"
                        self?.errorLbl.textColor = .systemRed
                    }
                case .success(let authDataResult):
                    DispatchQueue.main.async {
                        self?.errorLbl.text = "Hope you enjoy our app experience Email user is: \(authDataResult.user.email ?? "")"
                        self?.errorLbl.textColor = .systemGreen
                    }
                }
            }
        }
    }
    
    @IBAction func toggleAccountState(_ sender: UIButton) {
        // change the account login state
        accountState = accountState == .existingUser ? .newUser : .existingUser
        
        //animation duration
        let duration: TimeInterval = 1.0
        
        if accountState == .existingUser {
            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve]) {
                self.loginButton.setTitle("Login", for: .normal)
                self.accountStateMessageLabel.text = "Don't have an account ?"
                self.accountStateButton.setTitle("Sign Up", for: .normal)
            }
        }else {
            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve]) {
                self.loginButton.setTitle("Sign Up", for: .normal)
                self.accountStateMessageLabel.text = "Already have an account ?"
                self.accountStateButton.setTitle("Login", for: .normal)
            }
        }
        
    }

}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
