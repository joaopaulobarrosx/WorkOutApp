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
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .workOutBackground
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(WorkoutHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        viewModel.attachView(self)
        setupViewElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Private
    
    func setupViewElements() {
        
    }

    //MARK: - UITableViewDelegate, UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: clicou index \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? WorkoutCell else {
            return UITableViewCell()
        }
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
            
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            print("DEBUG: clicked DELETE \(indexPath.row)")
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
