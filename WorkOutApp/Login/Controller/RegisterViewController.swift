//
//  RegisterViewController.swift
//  WorkOutApp
//
//  Created by Joao Barros on 12/05/23.
//

import UIKit
import SwiftUI

class RegisterViewController: UIViewController {
    
    //MARK: - Properties

    let viewModel = LoginRegisterViewModel()

    private let registerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Make your account now!"
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Retype password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(pressRegister), for: .touchUpInside)
        return button
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back to Login View", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(pressBackLogin), for: .touchUpInside)
        return button
    }()

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .workOutBackground
        viewModel.attachView(self)
        setupViewElements()
        addTapReconizer()
    }

    //MARK: - Private

    func setupViewElements() {
        view.addSubview(registerLabel)
        registerLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20)
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField, repeatPasswordTextField, registerButton, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: registerLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 20, paddingRight: 20)
    }
    
    func addTapReconizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func pressRegister() {
        viewModel.validateFields(name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text, rePassword: repeatPasswordTextField.text)
    }

    @objc private func pressBackLogin() {
        navigationController?.popViewController(animated: true)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - LoginRegisterProtocol

extension RegisterViewController: LoginRegisterProtocol {

    func openWorkOutView() {
        navigationController?.popViewController(animated: true)
        let workoutVC = WorkoutViewController()
        navigationController?.pushViewController(workoutVC, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Preview

struct RegisterViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            RegisterViewController()
        }
    }
}
