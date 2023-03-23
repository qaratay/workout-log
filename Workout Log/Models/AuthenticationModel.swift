//
//  AuthenticationModel.swift
//  Workout Log
//
//  Created by Galymzhan Karatay on 27.11.2022.
//

import Foundation
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

class AuthenticationModel {
    var user: User?
    var authenticationState: AuthenticationState = .unauthenticated
    var authStateHandle: AuthStateDidChangeListenerHandle?
    var errorMessage = ""
    
    init() {
        registerAuthStateHandler()
        self.authenticationState = user == nil ? .unauthenticated: .authenticated
    }
    
    func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener({ auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
            })
        }
    }
    
    func signIn(emailAddress: String, password: String) async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: emailAddress, password: password)
            return true
        } catch  {
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUp(emailAddress: String, password: String) async -> Bool {
        authenticationState = .authenticating
        do  {
            try await Auth.auth().createUser(withEmail: emailAddress, password: password)
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
