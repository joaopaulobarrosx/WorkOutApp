//
//  AddItemViewController.swift
//  WorkOutApp
//
//  Created by Joao Barros on 14/05/23.
//

import UIKit
import SwiftUI

protocol AddItemViewControllerDelegate: AnyObject {
    func didAddItem(title: String, description: String)
}

class AddItemViewController: UIViewController {

    //MARK: - Properties

    weak var delegate: AddItemViewControllerDelegate?

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Add Item"
        return label
    }()
    
    private let itemTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private let itemDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Description"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .workOutBackgroundLight
        setupView()
        modalPresentationStyle = .pageSheet
    }
    //MARK: - Private
    
    private func setupView() {
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        view.addSubview(titleLabel)
        view.addSubview(itemTitleTextField)
        view.addSubview(itemDescriptionTextField)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        saveButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20)
        titleLabel.anchor(top: cancelButton.bottomAnchor, left: view.leftAnchor, paddingTop: 32, paddingLeft: 20)
        itemTitleTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        itemDescriptionTextField.anchor(top: itemTitleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        
        if let title = itemTitleTextField.text, !title.isEmpty,
           let description = itemDescriptionTextField.text, !description.isEmpty {
            self.delegate?.didAddItem(title: title, description: description)
            dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "", message: "Fill the textFields to save information", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertController, animated: true, completion: nil)
        }
        
    }
}

//MARK: - Preview

struct AddItemViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            AddItemViewController()
        }
    }
}
