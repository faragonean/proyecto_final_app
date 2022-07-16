//
//  UniversityViewController.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 15/07/22.
//

import UIKit

final class UniversityViewController: UIViewController {

    var result: [String: [(String, String)]] = [:]
    var titleText: String?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBAction func end(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
    }
}

extension UniversityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return result.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let firstKey = Array(result.keys)[section]
        return result[firstKey]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") else { return UITableViewCell() }
        let firstKey = Array(result.keys)[indexPath.section]
        let data = result[firstKey]
        cell.textLabel?.text = data?[indexPath.row].0
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        return cell
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstKey = Array(result.keys)[section]
        return firstKey
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .white
        header?.textLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
