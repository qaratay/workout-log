//
//  InitialViewController.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 19.11.2022.
//

import UIKit
import SwiftUI

class InitialViewController: UIViewController {
    @IBOutlet weak var vectorImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var authenticationModel = AuthenticationModel()
    var dataModel = DataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isEnabled = false
        signUpButton.isEnabled = false
        activityIndicator.alpha = 0
        Task {
            if await dataModel.getPrograms() {
                signInButton.isEnabled = true
                signUpButton.isEnabled = true
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(workoutLogDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @IBAction func initialSignUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToSignUpViewController", sender: self)
    }
    
    @IBAction func initialSignInButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToSignInViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSignUpViewController" {
            let destinationViewController = segue.destination as? SignUpViewController
            destinationViewController?.authenticationModel = self.authenticationModel
            destinationViewController?.dataModel = self.dataModel
        } else if segue.identifier == "segueToSignInViewController" {
            let destinationViewController = segue.destination as? SignInViewController
            destinationViewController?.authenticationModel = self.authenticationModel
            destinationViewController?.dataModel = self.dataModel
        } else if segue.identifier == "segueToMainViewController" {
            let destinationViewController = segue.destination as? MainViewController
            destinationViewController?.authenticationModel = self.authenticationModel
            destinationViewController?.dataModel = self.dataModel
        }
    }
    
    @objc func workoutLogDidBecomeActive() {
        if authenticationModel.authenticationState == .authenticated {
            activityIndicator.alpha = 1
            signInButton.alpha = 0
            signUpButton.alpha = 0
            messageLabel.alpha = 0
            activityIndicator.startAnimating()
            Task {
                if await dataModel.getUserData(uid: authenticationModel.user!.uid) {
                    activityIndicator.alpha = 0
                    signInButton.alpha = 1
                    signUpButton.alpha = 1
                    vectorImage.alpha = 1
                    activityIndicator.stopAnimating()
                    performSegue(withIdentifier: "segueToMainViewController", sender: self)
                } else {
                    messageLabel.alpha = 1
                    messageLabel.text = dataModel.errorMessage+" | Make sure your phone is connected to the internet and reopen the app"
                    activityIndicator.alpha = 0
                    activityIndicator.stopAnimating()
                }
            }
        }
    }
}
