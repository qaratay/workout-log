//
//  MainViewController.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 19.11.2022.
//

import UIKit
import SwiftUI

protocol MainViewControllerDelegate {
    func updateData() async -> Bool
}

class MainViewController: UIViewController, MainViewControllerDelegate {
    
    @IBOutlet weak var accountButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var chooseProgramButton: UIButton!
    var authenticationModel: AuthenticationModel!
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        startButton.layer.cornerRadius = 14
        chooseProgramButton.layer.cornerRadius = 14
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Squats | Pushups | Pullups", message: "Please Select the Exercise Type", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Squats", style: .default, handler: { (_) in
            let programTitle = (((self.dataModel.userData["squats_program"] as? String)!).split(separator: ",")[0])
            if programTitle != "none" {
                let destinvationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as? SessionViewController
                destinvationViewController?.dataModel = self.dataModel
                destinvationViewController?.uid = self.authenticationModel.user!.uid
                destinvationViewController?.exerciseType = "squats"
                destinvationViewController?.delegate = self
                self.navigationController?.pushViewController(destinvationViewController!, animated: true)
            } else {
                self.showAlertMessage()
            }
        }))
        alert.addAction(UIAlertAction(title: "Pushups", style: .default, handler: { (_) in
            let programTitle = (((self.dataModel.userData["pushups_program"] as? String)!).split(separator: ",")[0])
            if programTitle != "none" {
                let destinvationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as? SessionViewController
                destinvationViewController?.dataModel = self.dataModel
                destinvationViewController?.uid = self.authenticationModel.user!.uid
                destinvationViewController?.exerciseType = "pushups"
                destinvationViewController?.delegate = self
                self.navigationController?.pushViewController(destinvationViewController!, animated: true)
            } else {
                self.showAlertMessage()
            }
        }))
        alert.addAction(UIAlertAction(title: "Pullups", style: .default, handler: { (_) in
            let programTitle = (((self.dataModel.userData["pullups_program"] as? String)!).split(separator: ",")[0])
            if programTitle != "none" {
                let destinvationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SessionViewController") as? SessionViewController
                destinvationViewController?.dataModel = self.dataModel
                destinvationViewController?.uid = self.authenticationModel.user!.uid
                destinvationViewController?.exerciseType = "pullups"
                destinvationViewController?.delegate = self
                self.navigationController?.pushViewController(destinvationViewController!, animated: true)
            } else {
                self.showAlertMessage()
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            self.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }

    @IBAction func chooseProgramButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToWorkoutProgramsViewController", sender: self)
    }
    
    @IBAction func accountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueToAccountViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAccountViewController" {
            let destinationViewController = segue.destination as? AccountViewController
            destinationViewController?.authenticationModel = self.authenticationModel
            destinationViewController?.dataModel = self.dataModel
        } else if segue.identifier == "segueToWorkoutProgramsViewController" {
            let destinationViewController = segue.destination as? WorkoutProgramsViewController
            destinationViewController?.uid = authenticationModel.user!.uid
            destinationViewController?.dataModel = self.dataModel
        }
    }
    
    func showAlertMessage() {
        let message = UIAlertController(title: "Starting Training Session", message: "To start a session, you firstly need to select the program.", preferredStyle: .alert)
        message.addAction(UIAlertAction(title: "Cancel", style: .cancel) {
            (UIAlertAction) in
            self.dismiss(animated: true)
        })
        present(message, animated: true)
    }
    
    func updateData() async -> Bool {
        if await dataModel.getUserData(uid: authenticationModel.user!.uid) {
            return true
        } else {
            return false
        }
    }
}
