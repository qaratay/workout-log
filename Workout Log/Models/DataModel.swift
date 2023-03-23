//
//  DataModel.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 21.12.2022.
//

import Foundation
import FirebaseDatabase

class DataModel {
    var programs: NSDictionary = [:]
    var userData: NSDictionary = [:]
    var errorMessage = ""
    var squats: [String] = []
    var pullups: [String] = []
    var pushups: [String] = []

    let ref = Database.database().reference(fromURL: "https://workout-log-ed649-default-rtdb.firebaseio.com/")
    
    func setUserDataOnSignUp(uid: String, firstname:String, lastname: String) {
        self.ref.child("users/\(uid)/firstname").setValue(firstname)
        self.ref.child("users/\(uid)/lastname").setValue(lastname)
        self.ref.child("users/\(uid)/pullups_program").setValue("none,0,00/00/0000")
        self.ref.child("users/\(uid)/pushups_program").setValue("none,0,00/00/0000")
        self.ref.child("users/\(uid)/squats_program").setValue("none,0,00/00/0000")
        self.ref.child("users/\(uid)/pullups_count").setValue(0)
        self.ref.child("users/\(uid)/pushups_count").setValue(0)
        self.ref.child("users/\(uid)/squats_count").setValue(0)
        userData = ["firstname":firstname, "lastname":lastname, "pullups_count":0, "pullups_program":"none,0,00/00/0000", "pushups_count":0,"pushups_program":"none,0,00/00/0000", "squats_count":0, "squats_program":"none,0,00/00/0000"]
    }
    
    func updateUserChosenProgram(uid: String, exerciseType: String, programTitle: String) {
        self.ref.child("users/\(uid)/\(exerciseType)_program").setValue(programTitle+",0,00/00/0000")
        Task {
            await getUserData(uid: uid)
        }
    }
    
    func updateUserProgress(uid: String, exerciseType: String, programTitle: String, currentProgress: Int, total: Int, currentCount: Int) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = dateFormatter.string(from: date)
        self.ref.child("users/\(uid)/\(exerciseType)_program").setValue(programTitle+",\(String(currentProgress)),\(currentDate)")
        self.ref.child("users/\(uid)/\(exerciseType)_count").setValue(currentCount+total)
    }
    
    func endProgram(uid: String, exerciseType: String, total: Int, currentCount: Int) {
        self.ref.child("users/\(uid)/\(exerciseType)_program").setValue("none,0,00/00/0000")
        self.ref.child("users/\(uid)/\(exerciseType)_count").setValue(currentCount+total)
    }
    
    func getPrograms() async -> Bool {
        do {
            programs = try await (ref.child("programs/").getData().value as? NSDictionary)!
            squats = (((programs["squats"] as? NSDictionary)?.allKeys as? [String])!).sorted()
            pushups = (((programs["pushups"] as? NSDictionary)?.allKeys as? [String])!).sorted()
            pullups = (((programs["pullups"] as? NSDictionary)?.allKeys as? [String])!).sorted()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func getUserData(uid: String) async -> Bool {
        do {
            userData = try await (ref.child("users/\(uid)").getData().value as? NSDictionary)!
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func deleteUserDate(uid: String) {
        self.ref.child("users/\(uid)").setValue(nil)
    }
}
