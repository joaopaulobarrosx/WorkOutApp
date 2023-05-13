//
//  LoginRegisterViewModel.swift
//  WorkOutApp
//
//  Created by Joao Barros on 12/05/23.
//

import UIKit
import Firebase

protocol LoginRegisterProtocol: AnyObject {
    func showAlert(title: String, message: String)
    func openWorkOutView()
}

class LoginRegisterViewModel {
    
    weak private var LoginRegisterView: LoginRegisterProtocol?

    func attachView(_ view: LoginRegisterProtocol) {
        self.LoginRegisterView = view
    }

    func validateFields(name: String?, email: String?, password: String?, rePassword: String?) {
        if let name = name, !name.isEmpty,
           let email = email, !email.isEmpty,
           let password = password, !password.isEmpty,
           let rePassword = rePassword, !rePassword.isEmpty,
           password == rePassword {
            register(email: email, password: password)
        } else {
            LoginRegisterView?.showAlert(title: "Register error", message: "Please complete correctly all the text fields")
        }
    }

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let uid = result?.user.uid {
                UserDefaults.standard.set(uid, forKey: "uid")
                self.LoginRegisterView?.openWorkOutView()
            } else if let error = error {
                self.LoginRegisterView?.showAlert(title: "Register error", message: error.localizedDescription)
            }
        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let uid = result?.user.uid {
                UserDefaults.standard.set(uid, forKey: "uid")
                self.LoginRegisterView?.openWorkOutView()
            } else if let error = error {
                self.LoginRegisterView?.showAlert(title: "Login error", message: error.localizedDescription)
            }
        }
    }
}
