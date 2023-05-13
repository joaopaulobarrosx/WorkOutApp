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
}

class WorkoutViewModel {
    
    weak private var workoutView: WorkoutProtocol?
    
    func attachView(_ view: WorkoutProtocol) {
        self.workoutView = view
    }

}
