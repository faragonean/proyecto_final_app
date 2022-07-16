//
//  ViewController.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 10/07/22.
//

import UIKit

final class TestViewController: UIViewController {

    @IBAction func goToTest(_ sender: Any) {
        performSegue(withIdentifier: "goToTest", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
    }
}
