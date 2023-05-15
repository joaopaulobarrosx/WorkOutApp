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
        let date = Date()
        newItem.createdLabel = date
        let uuid = UUID()
        newItem.uid = uuid
        guard let uidUser = UserDefaults.standard.object(forKey: "uid") as? String else {
            return
        }
        newItem.userUid = uidUser
        print("DEBUG: Item UUID \(newItem)")
        do {
            try context.save()
            getAllItens()
        } catch {
            self.workoutView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }

        createItemFirebase(label: label, description: description, uuid: uuid.uuidString, date: date)
    }

    func createItemFirebase(label: String, description: String, uuid: String, date: Date) {
        guard let uidUser = UserDefaults.standard.object(forKey: "uid") as? String else { return }
        let database = Firestore.firestore()
        let refWorkout = database.document("uidUser/\(uidUser)/workout/\(uuid)")
        refWorkout.setData(["workoutTitle": label, "descriptionLabel": description, "createdLabel": date, "uid": uuid, "userUid": uidUser])
    }
    

    func deleteItem(item: Workout) {
        
        deleteItemFirebase(item: item)

        guard let context else { return }
        context.delete(item)
        do {
            try context.save()
            getAllItens()
        } catch {
            self.workoutView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
        
    }

    func deleteItemFirebase(item: Workout) {
        guard let uidUser = UserDefaults.standard.object(forKey: "uid") as? String,
              let uidElement = item.uid?.uuidString else { return }
        let database = Firestore.firestore()
        let refWorkout = database.document("uidUser/\(uidUser)/workout/\(uidElement)")
        refWorkout.delete()
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
