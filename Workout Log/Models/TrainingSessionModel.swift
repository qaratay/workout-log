//
//  TrainingSessionModel.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 16.12.2022.
//

import Foundation

class TrainingSessionModel {
    var dataModel = DataModel()
    var restTime = "00:01"
    var total = 0
    
    func addToTotal(x: Int) {
        total += x
    }
    
    func getTotalNumberOfSeconds() -> Int {
        let minutes = String(String(restTime.prefix(2)).suffix(1))
        let seconds = String(restTime.suffix(2))
        var totalSeconds = 0
        if String(seconds.prefix(1)) != "0" {
            totalSeconds += Int(seconds)! + (Int(String(minutes.suffix(1)))!*60)
        } else {
            totalSeconds += Int(String(seconds.suffix(1)))! + (Int(String(minutes.suffix(1)))!*60)
        }
        return totalSeconds
    }
}
