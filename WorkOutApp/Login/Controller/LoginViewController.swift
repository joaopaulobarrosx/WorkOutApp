//
//  LoginViewController.swift
//  WorkOutApp
//
//  Created by Joao Barros on 12/05/23.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    
    //MARK: - Properties

    let viewModel = LoginRegisterViewModel()

    private let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "WorkOutIcon")
        image.setDimensions(width: 200, height: 200)
        return image
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Welcome to your"
        return label
    }()

    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.text = "WorkOut App"
        return label
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(pressLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New here? Register now!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(pressRegistration), for: .touchUpInside)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserIsLogged()
    }

    //MARK: - Private

    func setupViewElements() {
        view.addSubview(iconImage)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: iconImage.bottomAnchor, paddingTop: 30)
        view.addSubview(appNameLabel)
        appNameLabel.anchor(top: welcomeLabel.bottomAnchor, paddingTop: 10)
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: appNameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 20, paddingRight: 20)
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func checkIfUserIsLogged() {
        viewModel.checkIfUserIsLogged()
    }

    func addTapReconizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func pressLogin() {
        viewModel.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }

    @objc private func pressRegistration() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - LoginRegisterProtocol

extension LoginViewController: LoginRegisterProtocol {
    
    func openWorkOutView() {
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

struct LoginViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            LoginViewController()
        }
    }
}
