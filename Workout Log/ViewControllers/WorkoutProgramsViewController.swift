//
//  WorkoutProgramsViewController.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 06.12.2022.
//

import UIKit
import FirebaseDatabase

protocol WorkoutProgramsViewControllerDelegate {
    func popToMain()
}

class WorkoutProgramsViewController: UIViewController, WorkoutProgramsViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exercisesSegmentedControl: UISegmentedControl!
    var dataModel: DataModel!
    var uid: String!
    var programs: [String] = []
    var exerciseType = "squats"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        programs = dataModel.squats
    }
    
    @IBAction func exercisesSegmentedControlChanged(_ sender: UISegmentedControl) {
        if exercisesSegmentedControl.selectedSegmentIndex == 0 {
            programs = dataModel.squats
            exerciseType = "squats"
        } else if exercisesSegmentedControl.selectedSegmentIndex == 1 {
            programs = dataModel.pushups
            exerciseType = "pushups"
        } else {
            programs = dataModel.pullups
            exerciseType = "pullups"
        }
        tableView.reloadData()
    }
    func popToMain() {
        navigationController?.popViewController(animated: true)
    }
}

extension WorkoutProgramsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "program", for: indexPath)
        cell.textLabel?.text = "Program "+String(indexPath.row+1)
        cell.detailTextLabel?.text = programs[indexPath.row]
        cell.imageView?.image = UIImage(named: exerciseType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinvationViewController = storyboard?.instantiateViewController(withIdentifier: "WorkoutProgramViewController") as? WorkoutProgramViewController
        destinvationViewController?.programTitle = programs[indexPath.row]
        destinvationViewController?.exerciseType = exerciseType
        destinvationViewController?.dataModel = dataModel
        destinvationViewController?.uid = self.uid
        destinvationViewController?.delegate = self
        navigationController?.pushViewController(destinvationViewController!, animated: true)
    }
    
}
