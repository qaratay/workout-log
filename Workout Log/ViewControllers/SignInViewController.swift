//
//  SignInViewController.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 19.11.2022.
//

import UIKit
import SwiftUI
import FirebaseAuth

class SignInViewController: UIViewController {
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var authenticationModel: AuthenticationModel!
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 14
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        signInButton.alpha = 0.8
        signInButton.isEnabled = false
        Task {
            let emailAddress = emailAddressTextField.text!
            let password = passwordTextField.text!
            if password != "" && emailAddress != "" {
                if await authenticationModel.signIn(emailAddress: emailAddress, password: password) {
                    if await dataModel.getUserData(uid: authenticationModel.user!.uid) {
                        performSegue(withIdentifier: "segueToMainViewController", sender: self)
                    }
                } else {
                    signInButton.alpha = 1
                    signInButton.isEnabled = true
                    messageLabel.text = authenticationModel.errorMessage
                    messageLabel.isHidden = false
                }
            } else {
                signInButton.alpha = 1
                signInButton.isEnabled = true
                messageLabel.text = "Enter email and password"
                messageLabel.isHidden = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMainViewController" {
            let destinationViewController = segue.destination as? MainViewController
            destinationViewController?.authenticationModel = self.authenticationModel
            destinationViewController?.dataModel = self.dataModel
        }
    }
}
