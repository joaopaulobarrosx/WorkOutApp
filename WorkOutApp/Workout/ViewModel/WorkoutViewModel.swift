//
//  WorkoutViewModel.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//

import UIKit
import Firebase

protocol WorkoutProtocol: AnyObject {
    func showAlert(title: String, message: String)
    func returnToLoginView()
}

class WorkoutViewModel {
    
    weak private var workoutView: WorkoutProtocol?
    
    func attachView(_ view: WorkoutProtocol) {
        self.workoutView = view
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            self.workoutView?.returnToLoginView()
        } catch let error {
            self.workoutView?.showAlert(title: "Error", message: "Failed to sign out with error \(error.localizedDescription)")
        }
    }
}
