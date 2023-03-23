//
//  AccountViewController.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 06.12.2022.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet var userDataLabels: [UILabel]!
    @IBOutlet weak var deleteAccountButton: UIButton!
    var authenticationModel: AuthenticationModel!
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteAccountButton.layer.cornerRadius = 14
        deleteAccountButton.isEnabled = false
        let userData = dataModel.userData
        userDataLabels[0].text = ((userData["firstname"] as? String)!)+" "+((userData["lastname"] as? String)!)
        userDataLabels[1].text = "Squats: "+String((userData["squats_count"] as? Int)!)
        userDataLabels[2].text = "Pushups: "+String((userData["pushups_count"] as? Int)!)
        userDataLabels[3].text = "Pullups: "+String((userData["pullups_count"] as? Int)!)
        userDataLabels[4].text = "Program selected for Squats - "+String(((userData["squats_program"] as? String)!).split(separator: ",")[0])
        userDataLabels[5].text = "Program selected for Pushups - "+String(((userData["pushups_program"] as? String)!).split(separator: ",")[0])
        userDataLabels[6].text = "Program selected for Pullups - "+String(((userData["pullups_program"] as? String)!).split(separator: ",")[0])
        deleteAccountButton.isEnabled = true
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        if authenticationModel.signOut() {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
        Task {
            let uid = authenticationModel.user!.uid
            if await authenticationModel.deleteAccount() {
                navigationController?.popToRootViewController(animated: true)
                dataModel.deleteUserDate(uid: uid)
            } else {
                let alert = UIAlertController(title: "Alert", message: authenticationModel.errorMessage, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
                    self.dismiss(animated: true)
                }
                alert.addAction(cancelAction)
                present(alert, animated: true)
            }
        }
    }
}
