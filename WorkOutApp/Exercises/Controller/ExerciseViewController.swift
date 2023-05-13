//
//  ExerciseViewController.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//

import UIKit
import SwiftUI

class ExerciseViewController: UIViewController {

    //MARK: - Properties
    let viewModel = ExerciseViewModel()
    
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

extension ExerciseViewController: ExerciseProtocol {
    func showAlert(title: String, message: String) { }
}


//MARK: - Helpers

struct ExerciseViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            ExerciseViewController()
        }
    }
}

