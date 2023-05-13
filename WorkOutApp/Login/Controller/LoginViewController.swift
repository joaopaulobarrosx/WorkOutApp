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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(pressLogin), for: .touchUpInside)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(pressRegistration), for: .touchUpInside)
        return button
    }()

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewElements()
    }
    //MARK: - Private
    
    func setupView() {
        let backgroundLayer = CALayer()
        backgroundLayer.frame = view.bounds
        backgroundLayer.backgroundColor = UIColor.workOutBackground.cgColor
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }

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

    @objc private func pressLogin() {

    }

    @objc private func pressRegistration() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
//MARK: - Helpers

struct LoginViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            LoginViewController()
        }
    }
}
