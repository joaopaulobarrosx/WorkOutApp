//
//  WorkoutViewController.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//

import UIKit
import SwiftUI

class WorkoutViewController: UIViewController {

    //MARK: - Properties
    let viewModel = WorkoutViewModel()
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .workOutBackground
        viewModel.attachView(self)
        setupViewElements()
    }

    //MARK: - Private
    
    func setupViewElements() {
        
    }
}

//MARK: - WorkoutProtocol

extension WorkoutViewController: WorkoutProtocol {
    func showAlert(title: String, message: String) { }
}


//MARK: - Helpers

struct WorkoutViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            WorkoutViewController()
        }
    }
}
