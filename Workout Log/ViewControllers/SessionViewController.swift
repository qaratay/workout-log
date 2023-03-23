//
//  SessionViewController.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 16.12.2022.
//

import UIKit

class SessionViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var numbers: [UILabel]!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    var delegate: MainViewControllerDelegate!
    var trainingSessionModel = TrainingSessionModel()
    var dataModel: DataModel!
    var timer: Timer!
    var uid: String!
    var exerciseType: String!
    var programTitle: String!
    var progress: Int!
    var currentRep = 0
    var currentRepNumber = 0
    var totalSeconds = 0
    var daysCount = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = trainingSessionModel.restTime
        timerLabel.font = UIFont.systemFont(ofSize: timerLabel.frame.width/4)
        programTitle = String(((dataModel.userData["\(exerciseType!)_program"] as? String)!).split(separator: ",")[0])
        progress = Int(((dataModel.userData["\(exerciseType!)_program"] as? String)!).split(separator: ",")[1])!+1
        let reps = ((((dataModel.programs[exerciseType!] as? NSDictionary)![programTitle!] as? NSDictionary)!["Day \(String(progress))"] as? String)!).split(separator: " ")
        total = 0
        for i in 0...numbers.count-1 {
            numbers[i].text = String(reps[i])
            total += Int(reps[i])!
        }
        currentNumberLabel.text = "Do \(reps[0]) \(exerciseType!)"
        currentRep = Int(numbers[currentRepNumber].text!)!
        totalLabel.text = "Total "+String(total)
        daysCount =  (((dataModel.programs[exerciseType!] as? NSDictionary)![programTitle!] as? NSDictionary)!.allKeys as? [String])!.count
        activityIndicator.isHidden = true
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrementOneSecond), userInfo: nil, repeats: true)
        totalSeconds = trainingSessionModel.getTotalNumberOfSeconds()
        doneButton.isEnabled = false
        stepper.isEnabled = false
        currentRep = Int(numbers[currentRepNumber].text!)!+Int(stepper.value)
        stepper.value = 0
    }
    
    @IBAction func stepperPressed(_ sender: Any) {
        totalLabel.text = "Total \(total+Int(stepper.value))"
        currentNumberLabel.text = "Do \(currentRep+Int(stepper.value)) \(exerciseType!)"
    }
    
    @objc func decrementOneSecond() {
        if currentRepNumber != 4 {
            totalSeconds -= 1
            if totalSeconds%60 < 10 {
                timerLabel.text = "0"+String(totalSeconds/60)+":0"+String(totalSeconds%60)
            } else {
                timerLabel.text = "0"+String(totalSeconds/60)+":"+String(totalSeconds%60)
            }
            if totalSeconds == -1 {
                trainingSessionModel.addToTotal(x: currentRep)
                currentRep = Int(numbers[currentRepNumber+1].text!)!
                numbers[currentRepNumber].textColor = UIColor.gray
                currentRepNumber += 1
                numbers[currentRepNumber].textColor = UIColor.black
                currentNumberLabel.text = "Do \(numbers[currentRepNumber].text!) \(exerciseType!)"
                timerLabel.text = trainingSessionModel.restTime
                doneButton.isEnabled = true
                stepper.isEnabled = true
                timer.invalidate()
            }
        } else {
            doneButton.isEnabled = false
            stepper.isEnabled = false
            trainingSessionModel.addToTotal(x: currentRep)
            let currentCount = (dataModel.userData["\(exerciseType!)_count"] as? Int)!
            var message = "You've completed Day \(progress!) of the \(programTitle!) program for \(exerciseType!). Rest 24 to 48 hours before next training session."
            var title = "End Session"
            if progress != daysCount {
                dataModel.updateUserProgress(uid: uid, exerciseType: exerciseType, programTitle: programTitle, currentProgress: progress, total: trainingSessionModel.total, currentCount: currentCount)
            } else {
                dataModel.endProgram(uid: uid, exerciseType: exerciseType, total: trainingSessionModel.total, currentCount: currentCount)
                message = "You've completed the \(programTitle!) program for \(exerciseType!). Test yourself and select other program."
                title = "Complete Program"
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .cancel) {
                UIAlertAction in
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                Task {
                    if await self.delegate.updateData() {
                        self.activityIndicator.stopAnimating()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
            present(alert, animated: true)
            timer.invalidate()
        }
    }
}
