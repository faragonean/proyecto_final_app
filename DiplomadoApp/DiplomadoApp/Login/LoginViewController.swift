//
//  ViewController.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 10/07/22.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func loginUser(_ sender: Any) {
        guard let email = emailTextField.text,
              let pass = passwordTextField.text,
              !email.isEmpty, !pass.isEmpty else {
            showAlert(title: "Error Login", message: "Ningún campo puede estar vacío")
            return
        }

        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in

            if (error != nil) {
                self?.showAlert(title: "Error Login", message: error?.localizedDescription ?? "")
            }
            self?.emailTextField.text = ""
            self?.passwordTextField.text = ""
            self?.performSegue(withIdentifier: "tabBars", sender: nil)
        }
    }

    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

