//
//  ListResultViewController.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 16/07/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ListResultViewController: UIViewController {

    private let db = Firestore.firestore()
    private var result: [String: Any] = [:]
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadResult()
        // Do any additional setup after loading the view.
    }

    func loadResult() {
        let docRef = db.collection("result").document(Auth.auth().currentUser?.uid ?? "")

        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                self?.result = document.data() ?? [:]
                self?.tableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
}

extension ListResultViewController: UITableViewDelegate, UITableViewDataSource {

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

        let firstKey = Array(result.keys)[indexPath.row]
        let date = Date(timeIntervalSince1970: Double(firstKey) ?? 0)
        cell.textLabel?.text = "\(date)"
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        cell.addCustomDisclosureIndicator(with: .white)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firstKey = Array(result.keys)[indexPath.row]
        let dic = result[firstKey] as? [String: Float]
        var array: [(String, Float)] = []
        for (key, value) in dic ?? [:] {
            array.append((key, value))
        }
        performSegue(withIdentifier: "goToResult", sender: array)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToResult") {
            let vc = segue.destination as? ResultViewController
            let result = sender as? [(String, Float)] ?? []
            if result.count >= 3 {
                vc?.result = Array(result[0 ..< 3])
            } else {
                vc?.result = result
            }
        }
    }

}
