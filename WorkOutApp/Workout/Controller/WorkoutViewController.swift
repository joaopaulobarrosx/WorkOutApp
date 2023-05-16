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
    private var workoutFiltered = [Workout]()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.attachView(self)
        setupViewElements()
        viewModel.getAllItens()
        addTapReconizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Private
    
    func setupViewElements() {
        tableView.backgroundColor = .workOutBackground
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(WorkoutHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
    }
    
    func editItemModal(workout: Workout) {

        let modal = viewModel.editItemModal(workout: workout, delegate: self)
        present(modal, animated: true)
    }

    func deleteItemModal(workout: Workout) {

        let modal = viewModel.deleteItemModal(workout: workout)
        present(modal, animated: true, completion: nil)
    }

    func addTapReconizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutFiltered.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exerciseViewController = ExerciseViewController()
        exerciseViewController.selectedWorkout = workoutFiltered[indexPath.row]
        navigationController?.pushViewController(exerciseViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? WorkoutCell else {
            return UITableViewCell()
        }
        cell.workout = workoutFiltered[indexPath.row]
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
        headerView.layer.cornerRadius = 20
        headerView.layer.masksToBounds = true
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
            self.editItemModal(workout: self.workoutFiltered[indexPath.row])
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.deleteItemModal(workout: self.workoutFiltered[indexPath.row])
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
        self.workoutFiltered = workout
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

    func searchBarTextChanged(text: String) {
        if text.isEmpty {
            workoutFiltered = workout
        } else {
            workoutFiltered = viewModel.getfilteredList(searchText: text, workout: workout)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.reloadData()
        }
    }
    func addPressed() {
        let modal = viewModel.addPressed(delegate: self)
        present(modal, animated: true)
    }
    
    func logoutUser() {
        viewModel.logoutUser()
    }
}

//MARK: - AddItemViewControllerDelegate

extension WorkoutViewController: AddItemViewControllerDelegate {

    func didSaveWorkoutItem(title: String, description: String, image: Data?, workout: Workout?) {
        if let workout {
            viewModel.updateltem(item: workout, label: title, description: description)
        } else {
            viewModel.createItem(label: title, description: description)
        }
    }

    func didSaveExerciseItem(title: String, description: String, image: Data?, exercise: Exercise?) { }
    
}

//MARK: - Preview

struct WorkoutViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            WorkoutViewController()
        }
    }
}
