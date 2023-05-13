//
//  ExerciseViewModel.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//

import UIKit
import Firebase

protocol ExerciseProtocol: AnyObject {
    func showAlert(title: String, message: String)
}

class ExerciseViewModel {
    
    weak private var exerciseView: ExerciseProtocol?
    
    func attachView(_ view: ExerciseProtocol) {
        self.exerciseView = view
    }

}
