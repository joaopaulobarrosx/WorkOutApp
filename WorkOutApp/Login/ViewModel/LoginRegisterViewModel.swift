//
//  LoginRegisterViewModel.swift
//  WorkOutApp
//
//  Created by Joao Barros on 12/05/23.
//

import UIKit

protocol LoginRegisterProtocol: AnyObject {
    func showAlert(title: String, message: String)
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
        
    }
}
