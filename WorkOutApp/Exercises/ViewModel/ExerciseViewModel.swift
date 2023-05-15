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

    func createItem(label: String, description: String, image: Data?, selectedWorkout: Workout?) {
        guard let context = context, let selectedWorkout = selectedWorkout else { return }
        let newItem = Exercise(context: context)
        newItem.nameLabel = label
        newItem.notesLabel = description
        newItem.uid = UUID()
        if let image {
            newItem.exerciseImage = image
        }
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

    func updateltem(item: Exercise, label: String, description: String, image: Data?, selectedWorkout: Workout?) {
        guard let context else { return }
        item.nameLabel = label
        item.notesLabel = description
        if let image {
            item.exerciseImage = image
        }
        do {
            try context.save()
            getAllItens(selectedWorkout: selectedWorkout)
        } catch {
            self.exerciseView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }

    func editItemModal(exercise: Exercise, delegate: AddItemViewControllerDelegate?) -> AddItemViewController {
        let addItemViewController = AddItemViewController()
        addItemViewController.delegate = delegate
        addItemViewController.exercise = exercise
        if let nameLabel = exercise.nameLabel,
              let notesLabel = exercise.notesLabel  {
            addItemViewController.setupEditedView(title: nameLabel, description: notesLabel, image: exercise.exerciseImage)
        }
        return addItemViewController
    }

    func deleteItemModal(exercise: Exercise, selectedWorkout: Workout?) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Delete Item?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.deleteItem(item: exercise, selectedWorkout: selectedWorkout)
        })
        return alertController
    }
}
