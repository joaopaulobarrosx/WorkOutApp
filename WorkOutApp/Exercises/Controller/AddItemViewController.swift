//
//  AddItemViewController.swift
//  WorkOutApp
//
//  Created by Joao Barros on 14/05/23.
//

import UIKit
import SwiftUI

protocol AddItemViewControllerDelegate: AnyObject {
    func didSaveItem(title: String, description: String, image: Data?, isEditing: Bool, exercise: Exercise?)
}

class AddItemViewController: UIViewController {

    //MARK: - Properties

    weak var delegate: AddItemViewControllerDelegate?
    private var selectedImage: UIImage?
    private var selectedImageData: Data?
    var isEditingItem = false
    var exercise: Exercise?

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

    private lazy var photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Picture", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
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
        view.addSubview(photoButton)
        view.addSubview(imageView)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        saveButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20)
        titleLabel.anchor(top: cancelButton.bottomAnchor, left: view.leftAnchor, paddingTop: 32, paddingLeft: 20)
        itemTitleTextField.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        itemDescriptionTextField.anchor(top: itemTitleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        photoButton.anchor(top: itemDescriptionTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        imageView.anchor(top: photoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, width: 250, height: 250)

    }

    func setupEditedView(title: String, description: String, image: Data?) {
        itemTitleTextField.text = title
        itemDescriptionTextField.text = description
        if let image {
            imageView.image = UIImage(data: image)
        }
        isEditingItem = true
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        
        if let title = itemTitleTextField.text, !title.isEmpty,
           let description = itemDescriptionTextField.text, !description.isEmpty {
            self.delegate?.didSaveItem(title: title, description: description, image: selectedImageData, isEditing: isEditingItem, exercise: exercise)
            dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "", message: "Fill the text fields to save information", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertController, animated: true, completion: nil)
        }
    }

    @objc private func photoButtonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}
//MARK: - Picker

extension AddItemViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        imageView.image = selectedImage
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.7) {
            selectedImageData = imageData
        }
        picker.dismiss(animated: true)
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
