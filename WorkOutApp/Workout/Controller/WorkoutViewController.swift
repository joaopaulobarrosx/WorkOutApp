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
    private var workout = [Workout]()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .workOutBackground
        viewModel.attachView(self)
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(WorkoutHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        setupViewElements()
        viewModel.getAllItens()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Private
    
    func setupViewElements() {
        
    }
    
    func editItemModal(workout: Workout) {
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
            self.viewModel.updateltem(item: workout, label: title, description: description)
        })
        present(alertController, animated: true, completion: nil)
    }

    func deleteItemModal(workout: Workout) {

        let alertController = UIAlertController(title: "Delete Item?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.viewModel.deleteItem(item: workout)
        })
        present(alertController, animated: true, completion: nil)
    }

    //MARK: - UITableViewDelegate, UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exerciseViewController = ExerciseViewController()
        exerciseViewController.selectedWorkout = workout[indexPath.row]
        navigationController?.pushViewController(exerciseViewController, animated: true)
        
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
            self.editItemModal(workout: self.workout[indexPath.row])
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.deleteItemModal(workout: self.workout[indexPath.row])
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit, delete])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}
//MARK: - WorkoutProtocol

extension WorkoutViewController: WorkoutProtocol {
    func returnWorkoutArray(workout: [Workout]) {
        self.workout = workout
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                present(alertController, animated: true, completion: nil)
    }
    func returnToLoginView() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - WorkoutHeaderViewDelegate

extension WorkoutViewController: WorkoutHeaderViewDelegate {

    func addPressed() {
        let alertController = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Description"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let title = alertController.textFields?[0].text, !title.isEmpty,
                  let description = alertController.textFields?[1].text, !description.isEmpty else {
                return
            }
            self.viewModel.createItem(label: title, description: description)
        })

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
