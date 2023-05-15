//
//  WorkoutViewModel.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//

import UIKit
import Firebase
import CoreData

protocol WorkoutProtocol: AnyObject {
    func showAlert(title: String, message: String)
    func returnToLoginView()
    func returnWorkoutArray(workout: [Workout])
}

class WorkoutViewModel {
    
    weak private var workoutView: WorkoutProtocol?
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
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
    
    
    //MARK: - CoreData

    func getAllItens() {
        guard let context = context,
              let uid = UserDefaults.standard.object(forKey: "uid") as? String else { return }
        do {
            let workoutArray = try context.fetch(Workout.fetchRequest(forUserUid: uid))
            self.workoutView?.returnWorkoutArray(workout: workoutArray)
        } catch let error {
            self.workoutView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }

    func createItem(label: String, description: String) {
        guard let context else { return }
        let newItem = Workout(context: context)
        newItem.workoutTitle = label
        newItem.descriptionLabel = description
        newItem.createdLabel = Date()
        newItem.uid = UUID()
        if let uid = UserDefaults.standard.object(forKey: "uid") as? String {
            newItem.userUid = uid
        }
        do {
            try context.save()
            getAllItens()
        } catch {
            self.workoutView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }

    func deleteItem(item: Workout) {
        guard let context else { return }
        context.delete(item)
        do {
            try context.save()
            getAllItens()
        } catch {
            self.workoutView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }

    func updateltem(item: Workout, label: String, description: String) {
        guard let context else { return }
        item.workoutTitle = label
        item.descriptionLabel = description
        do {
            try context.save()
            getAllItens()
        } catch {
            self.workoutView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }

    func editItemModal(workout: Workout, delegate: AddItemViewControllerDelegate?) -> AddItemViewController {
        let addItemViewController = AddItemViewController()
        addItemViewController.delegate = delegate
        addItemViewController.workout = workout
        addItemViewController.isWorkoutView = true
        if let workoutTitle = workout.workoutTitle,
           let descriptionLabel = workout.descriptionLabel  {
            addItemViewController.setupWorkoutEditView(title: workoutTitle, description: descriptionLabel)
        }
        return addItemViewController
    }

    func deleteItemModal(workout: Workout) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Delete Item?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.deleteItem(item: workout)
        })
        return alertController
    }

    func addPressed(delegate: AddItemViewControllerDelegate?) -> AddItemViewController {
        let addItemViewController = AddItemViewController()
        addItemViewController.delegate = delegate
        addItemViewController.setupWorkoutView()
        addItemViewController.isWorkoutView = true
        return addItemViewController
    }
}
