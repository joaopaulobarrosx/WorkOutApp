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
        let uuid = UUID()
        newItem.uid = uuid
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

        createItemFirebase(label: label, description: description, uuid: uuid.uuidString, selectedWorkout: selectedWorkout, image: image)
    }

    func createItemFirebase(label: String, description: String, uuid: String, selectedWorkout: Workout, image: Data?) {
        guard let uidUser = UserDefaults.standard.object(forKey: "uid") as? String,
              let uuidWorkout = selectedWorkout.uid?.uuidString else { return }
        let database = Firestore.firestore()
        let refWorkout = database.document("uidUser/\(uidUser)/workout/\(uuidWorkout)/exercise/\(uuid)")
        var params = ["nameLabel": label, "notesLabel": description, "uid": uuid]
        if let image {
            params["exerciseImage"] = "imageURLUploadedaqui"
        }
        refWorkout.setData(params)
    }

    func deleteItem(item: Exercise, selectedWorkout: Workout?) {
        
        deleteItemFirebase(item: item, selectedWorkout: selectedWorkout)
        
        guard let context else { return }
        context.delete(item)
        do {
            try context.save()
            getAllItens(selectedWorkout: selectedWorkout)
        } catch {
            self.exerciseView?.showAlert(title: "Error", message: "\(error.localizedDescription)")
        }
    }

    func deleteItemFirebase(item: Exercise, selectedWorkout: Workout?) {
        guard let uidUser = UserDefaults.standard.object(forKey: "uid") as? String,
              let selectedWorkout = selectedWorkout,
              let uuidWorkout = selectedWorkout.uid?.uuidString,
              let uuid = item.uid?.uuidString else { return }
        let database = Firestore.firestore()
        let refWorkout = database.document("uidUser/\(uidUser)/workout/\(uuidWorkout)/exercise/\(uuid)")
        refWorkout.delete()
    }
    
    
    func updateltem(item: Exercise, label: String, description: String, image: Data?, selectedWorkout: Workout?) {
        
        updateltemFirebase(item: item, label: label, description: description, image: image, selectedWorkout: selectedWorkout)
        
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

    func updateltemFirebase(item: Exercise, label: String, description: String, image: Data?, selectedWorkout: Workout?) {
        
        guard let uidUser = UserDefaults.standard.object(forKey: "uid") as? String,
              let uuidWorkout = selectedWorkout?.uid?.uuidString,
              let uuid = item.uid?.uuidString else { return }
        let database = Firestore.firestore()
        let refWorkout = database.document("uidUser/\(uidUser)/workout/\(uuidWorkout)/exercise/\(uuid)")
        var params = ["nameLabel": label, "notesLabel": description, "uid": uuid]
        if let image {
            params["exerciseImage"] = "imageURLUploadedaqui"
        }
        refWorkout.updateData(params)
        
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
