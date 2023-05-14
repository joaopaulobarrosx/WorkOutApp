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
    func returnExerciseArray(exercise: [Exercise])
}

class ExerciseViewModel {
    
    weak private var exerciseView: ExerciseProtocol?
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    
    func attachView(_ view: ExerciseProtocol) {
        self.exerciseView = view
    }

    //MARK: - CoreData

    func getAllItens(selectedWorkout: Workout?) {
        guard let context = context,
              let selectedWorkout = selectedWorkout,
              let workoutTitle = selectedWorkout.workoutTitle  else { return }

        let predicate = NSPredicate(format: "parentCategory.workoutTitle MATCHES %@", workoutTitle)
        let request = Exercise.fetchRequest()
        request.predicate = predicate
        
        do {
            let exerciseArray = try context.fetch(request)
            self.exerciseView?.returnExerciseArray(exercise: exerciseArray)
        } catch let error {
            self.exerciseView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }

    func createItem(label: String, description: String, selectedWorkout: Workout?) {
        guard let context = context, let selectedWorkout = selectedWorkout else { return }
        let newItem = Exercise(context: context)
        newItem.nameLabel = label
        newItem.notesLabel = description
        newItem.parentCategory = selectedWorkout
        do {
            try context.save()
            getAllItens(selectedWorkout: selectedWorkout)
        } catch {
            self.exerciseView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }

    func deleteItem(item: Exercise, selectedWorkout: Workout?) {
        guard let context else { return }
        context.delete(item)
        do {
            try context.save()
            getAllItens(selectedWorkout: selectedWorkout)
        } catch {
            self.exerciseView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }

    func updateltem(item: Exercise, label: String, description: String, selectedWorkout: Workout?) {
        guard let context else { return }
        item.nameLabel = label
        item.notesLabel = description
        do {
            try context.save()
            getAllItens(selectedWorkout: selectedWorkout)
        } catch {
            self.exerciseView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }
}
