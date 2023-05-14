//
//  WorkoutViewController.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//

import UIKit
import SwiftUI

class WorkoutViewController: UITableViewController {
    
    //MARK: - Properties
    let viewModel = WorkoutViewModel()
    private let reuseIdentifier = "WorkoutCell"
    private let headerReuseIdentifier = "WorkoutHeaderView"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var workout = [Workout]()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .workOutBackground
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(WorkoutHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        viewModel.attachView(self)
        setupViewElements()
        getAllItens()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Private
    
    func setupViewElements() {
        
    }
    
    func editItem(workout: Workout) {
        let alertController = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            if let workoutTitle = workout.workoutTitle {
                textField.text = String(describing: workoutTitle)
            }
        }
        alertController.addTextField { textField in
            textField.placeholder = String(describing: workout.descriptionLabel)
            if let descriptionLabel = workout.descriptionLabel {
                textField.text = String(describing: descriptionLabel)
            }
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let title = alertController.textFields?[0].text, !title.isEmpty,
                  let description = alertController.textFields?[1].text, !description.isEmpty else {
                return
            }
            self.updateltem(item: workout, label: title, description: description)
        })

        present(alertController, animated: true, completion: nil)
    }

    func deleteItem(workout: Workout) {

        let alertController = UIAlertController(title: "Delete Item?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.deleteItem(item: workout)
        })

        present(alertController, animated: true, completion: nil)
    }

    //MARK: - CoreData
    
    func getAllItens() {
        do {
            workout = try context.fetch(Workout.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error")
        }
    }

    func createItem(label: String, description: String) {
        let newItem = Workout(context: context)
        newItem.workoutTitle = label
        newItem.descriptionLabel = description
        newItem.createdLabel = Date()
        do {
            try context.save()
            getAllItens()
        } catch {
            print("Error")
        }
    }

    func deleteItem(item: Workout) {
        context.delete(item)
        do {
            try context.save()
            getAllItens()
        } catch {
            print("Error")
        }
    }

    func updateltem(item: Workout, label: String, description: String) {
        item.workoutTitle = label
        item.descriptionLabel = description
        item.createdLabel = Date()
        do {
            try context.save()
            getAllItens()
        } catch {
            print("Error")
        }
    }



    //MARK: - UITableViewDelegate, UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: clicou index \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? WorkoutCell else {
            return UITableViewCell()
        }
        cell.workout = workout[indexPath.row]
        cell.setup()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as? WorkoutHeaderView else {
            return UITableViewHeaderFooterView()
        }
        headerView.delegate = self
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            print("DEBUG: clicked EDIT \(indexPath.row)")
            self.editItem(workout: self.workout[indexPath.row])
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            print("DEBUG: clicked DELETE \(indexPath.row)")
            self.deleteItem(workout: self.workout[indexPath.row])
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit, delete])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}
//MARK: - WorkoutProtocol

extension WorkoutViewController: WorkoutProtocol {
    func showAlert(title: String, message: String) { }
    func returnToLoginView() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - WorkoutHeaderViewDelegate

extension WorkoutViewController: WorkoutHeaderViewDelegate {

    func addPressed() {
        let alertController = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)

        // Add text fields for title and description
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Description"
        }

        // Add "Cancel" action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Add "OK" action
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Retrieve text from text fields
            guard let title = alertController.textFields?[0].text, !title.isEmpty,
                  let description = alertController.textFields?[1].text, !description.isEmpty else {
                return
            }
            print("DEBUG: \(title), Description: \(description)")
            self.createItem(label: title, description: description)
            
        })

        // Present alert controller
        present(alertController, animated: true, completion: nil)

    }
    
    func logoutUser() {
        viewModel.logoutUser()
    }
}

//MARK: - Preview

struct WorkoutViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            WorkoutViewController()
        }
    }
}
