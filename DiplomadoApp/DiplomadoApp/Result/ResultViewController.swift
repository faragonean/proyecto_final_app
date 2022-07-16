//
//  ViewController.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 10/07/22.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

final class ResultViewController: UIViewController {

    private let db = Firestore.firestore()

    var result: [(String, Float)] = []

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = UILabel()
        title.text = "Resultado"
        title.textColor = .white
        title.sizeToFit()
        navigationItem.titleView = title
        saveResult()
    }

    func saveResult() {
        let dictionary = result.reduce(into: [:]) { $0[$1.0] = $1.1 }
        db.collection("result")
            .document(Auth.auth().currentUser?.uid ?? "")
            .setData([
                "\(Date().timeIntervalSince1970)": dictionary
            ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") else {
            return UITableViewCell()
        }
        let knowledge = DataBase.shared.getKnowledge(area: result[indexPath.row].0)
        cell.textLabel?.text = "\(indexPath.row + 1) -  \(knowledge?.area ?? "")"
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        cell.addCustomDisclosureIndicator(with: .white)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let knowledge = DataBase.shared.getKnowledge(area: result[indexPath.row].0)
        performSegue(withIdentifier: "goToUniversity", sender: knowledge)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToUniversity") {
            guard let know = sender as? Knowledge_Area,
                  let career = know.university_career else { return }
            let careers: [University_Career] = career.toArray()
            var data: [(String, String)] = []
            for item in careers {
                data.append((item.career ?? "", item.university?.university ?? ""))
            }
            let dicdata = Dictionary(grouping: data, by: { $0.1 })
            let vc = segue.destination as? UniversityViewController
            vc?.result = dicdata
            vc?.titleText = know.area
        }
    }
    
}

extension UITableViewCell {
    func addCustomDisclosureIndicator(with color: UIColor) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .large)
        let symbolImage = UIImage(systemName: "chevron.right",
                                  withConfiguration: symbolConfig)
        button.setImage(symbolImage?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = color
        self.accessoryView = button
    }
}

