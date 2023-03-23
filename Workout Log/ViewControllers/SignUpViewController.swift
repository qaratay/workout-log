//
//  SignUpViewController.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 19.11.2022.
//

import UIKit
import SwiftUI
import FirebaseAuth
import MessageUI

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var authenticationModel: AuthenticationModel!
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 14
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        signUpButton.alpha = 0.8
        signUpButton.isEnabled = false
        Task {
            let firstname = firstNameTextField.text!
            let lastname = lastNameTextField.text!
            let emailAddress = emailAddressTextField.text!
            let password = passwordTextField.text!
            if firstname != "" && lastname != "" && emailAddress != "" && password != "" {
                if await authenticationModel.signUp(emailAddress: emailAddress, password: password) {
                    dataModel.setUserDataOnSignUp(uid: authenticationModel.user!.uid, firstname: firstname, lastname: lastname)
                    performSegue(withIdentifier: "segueToMainViewController", sender: self)
                } else {
                    signUpButton.alpha = 1
                    signUpButton.isEnabled = true
                    messageLabel.text = authenticationModel.errorMessage
                    messageLabel.isHidden = false
                }
            } else {
                signUpButton.alpha = 1
                signUpButton.isEnabled = true
                messageLabel.text = "Fill in all the fields"
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
