//
//  ExerciseViewController.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//

import UIKit
import SwiftUI

class ExerciseViewController: UITableViewController {

    //MARK: - Properties
    let viewModel = ExerciseViewModel()
    private let reuseIdentifier = "ExerciseCell"
    private let headerReuseIdentifier = "ExerciseHeaderView"
    private var exercise = [Exercise]()
    private var exerciseFiltered = [Exercise]()

    var selectedWorkout: Workout? {
        didSet {
            tableView.reloadData()
            viewModel.getAllItens(selectedWorkout: selectedWorkout)
        }
    }
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .workOutBackground
        viewModel.attachView(self)
        setupViewElements()
        addTapReconizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    //MARK: - Private
    
    func setupViewElements() {
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(ExerciseHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
    }

    func editItemModal(exercise: Exercise) {

        let modal = viewModel.editItemModal(exercise: exercise, delegate: self)
        present(modal, animated: true)
    }

    func deleteItemModal(exercise: Exercise) {

        let modal = viewModel.deleteItemModal(exercise: exercise, selectedWorkout: selectedWorkout)
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
        return exerciseFiltered.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editItemModal(exercise: exerciseFiltered[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ExerciseCell else {
            return UITableViewCell()
        }
        cell.exercise = exerciseFiltered[indexPath.row]
        cell.setup()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as? ExerciseHeaderView else {
            return UITableViewHeaderFooterView()
        }
        headerView.delegate = self
        headerView.layer.cornerRadius = 20
        headerView.layer.masksToBounds = true
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.editItemModal(exercise: self.exerciseFiltered[indexPath.row])
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.deleteItemModal(exercise: self.exerciseFiltered[indexPath.row])
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit, delete])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}

//MARK: - WorkoutProtocol

extension ExerciseViewController: ExerciseProtocol {

    func returnExerciseArray(exercise: [Exercise]) {
        self.exercise = exercise
        self.exerciseFiltered = exercise
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                present(alertController, animated: true, completion: nil)
    }
}

//MARK: - ExerciseHeaderViewDelegate

extension ExerciseViewController: ExerciseHeaderViewDelegate {
    
    func searchBarTextChanged(text: String) {
        if text.isEmpty {
            exerciseFiltered = exercise
        } else {
            exerciseFiltered = viewModel.getfilteredList(searchText: text, exercise: exercise)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.reloadData()
        }
    }

    func addPressed() {
        let addItemViewController = AddItemViewController()
        addItemViewController.delegate = self
        present(addItemViewController, animated: true)
    }
}

extension ExerciseViewController: AddItemViewControllerDelegate {

    func didSaveWorkoutItem(title: String, description: String, image: Data?, workout: Workout?) { }

    func didSaveExerciseItem(title: String, description: String, image: Data?, exercise: Exercise?) {
        if let exercise {
            viewModel.updateltem(item: exercise, label: title, description: description, image: image, selectedWorkout: self.selectedWorkout)

        } else {
            viewModel.createItem(label: title, description: description, image: image, selectedWorkout: self.selectedWorkout)
        }
    }
}
//MARK: - Preview

struct ExerciseViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            ExerciseViewController()
        }
    }
}
