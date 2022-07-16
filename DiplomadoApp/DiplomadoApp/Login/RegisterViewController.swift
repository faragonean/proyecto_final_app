//
//  ViewController.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 10/07/22.
//

import UIKit
import FirebaseAuth

final class RegisterViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!

    @IBAction func registerUser(_ sender: Any) {
        guard let email = emailTextField.text,
              let pass = passwordTextField.text,
              let confpass = confirmTextField.text,
              !email.isEmpty, !pass.isEmpty, !confpass.isEmpty else {
            showAlert(title: "Error Registro", message: "Ningún campo puede estar vacío")
            return
        }


        guard pass == confpass else {
            showAlert(title: "Error Registro", message: "Los campos de password y confirmar password debe ser iguales")
            return
        }

        Auth.auth().createUser(withEmail: email, password: pass) { [weak self] authResult, error in
            if (error != nil) {
                self?.showAlert(title: "Error Registro", message: error?.localizedDescription ?? "Error al crear el usuario")
            }
            self?.showAlert(title: "Registro Exitoso", message: "Se guardo de forma correcta el usuario.", handler: { [weak self]action in
                self?.navigationController?.popViewController(animated: true)
            })

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

