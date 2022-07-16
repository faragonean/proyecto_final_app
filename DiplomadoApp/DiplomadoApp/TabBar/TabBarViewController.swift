//
//  TabBarViewController.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 11/07/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        setupTabBarSeparators()
    }

    func setupTabBarSeparators() {
        guard let count = tabBar.items?.count else { return }
        let itemWidth = floor(tabBar.frame.size.width / CGFloat(count))
        let separatorWidth: CGFloat = 0.5
        for i in 0...(count - 1) {
            let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 0, width: CGFloat(separatorWidth), height: tabBar.frame.size.height))
            separator.backgroundColor = UIColor.lightGray

            tabBar.addSubview(separator)
        }
    }
    

    @IBAction func logout(_ sender: Any) {
        showAlertSignOut(title: "Cerrar Sesión", message: "Esta seguro de cerrar sesión?") { [weak self] _ in
            self?.performSegue(withIdentifier: "unwind", sender: self)
        }
    }

    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
}
