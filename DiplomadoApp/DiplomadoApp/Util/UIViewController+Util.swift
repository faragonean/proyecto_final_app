//
//  UIViewCOntroller+Util.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 11/07/22.
//

import Foundation
import UIKit

extension UIViewController {

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        present(alert, animated: true, completion: nil)
    }

    func showAlertSignOut(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in }))
        alert.addAction(UIAlertAction(title: "Sign out",
                                              style: UIAlertAction.Style.default,
                                              handler: handler))
        present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func addConstraintsToFit(view: UIView) {
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[view]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["view": view])
        addConstraints(verticalConstraints)
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[view]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["view": view])
        addConstraints(horizontalConstraints)
    }

    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraintsToFit(view: self)
    }
}
