//
//  WorkoutProgramViewController.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 16.12.2022.
//

import UIKit

class WorkoutProgramViewController: UIViewController {
    @IBOutlet weak var startProgramButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var programTitleLabel: UILabel!
    var dataModel: DataModel!
    var delegate: WorkoutProgramsViewControllerDelegate!
    var uid: String!
    var exerciseType: String!
    var programTitle: String!
    var days: [String] = []
    var sets: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        programTitleLabel.text = programTitle!
        startProgramButton.layer.cornerRadius = 14
        tableView.layer.cornerRadius = 14
        tableView.allowsSelection = false
        days = ((((dataModel.programs[exerciseType!] as? NSDictionary)![programTitle!] as? NSDictionary)?.allKeys as? [String])!).sorted()
        for day in days {
            sets.append((((dataModel.programs[exerciseType!] as? NSDictionary)![programTitle!] as? NSDictionary)![day] as? String)!)
        }
        
    }
    
    @IBAction func startProgramButtonPressed(_ sender: Any) {
        dataModel.updateUserChosenProgram(uid: uid, exerciseType: exerciseType, programTitle: programTitle)
        delegate.popToMain()
        navigationController?.popViewController(animated: true)
    }
}

extension WorkoutProgramViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath)
        cell.textLabel!.text = days[indexPath.row]
        cell.detailTextLabel!.text = sets[indexPath.row]
        return cell
    }
        
}
