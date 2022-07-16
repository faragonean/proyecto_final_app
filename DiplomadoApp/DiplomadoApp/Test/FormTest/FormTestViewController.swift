//
//  FormTestViewController.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 11/07/22.
//

import UIKit

struct FormTest {
    let index: Int
    let question: String
    let answer: [Answer]
    let isLast: Bool
}

protocol FormTestViewControllerDelegate: AnyObject {
    func nextPage(answer: Answer)
}

class FormTestViewController: UIViewController {

    private let formTest: FormTest?
    private var answer: Answer?
    private var indexSelected: Int?
    weak var delegate: FormTestViewControllerDelegate?
    
    @IBOutlet weak var questionTest: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 200.0
            tableView.rowHeight = .infinity
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBAction func next(_ sender: Any) {
        guard let answer = answer else {
            showAlert(title: "Error Test", message: "Por favor elige una opción")
            return

        }
        delegate?.nextPage(answer: answer)
    }

    init(formTest: FormTest) {
        self.formTest = formTest
        super.init(nibName: "FormTestViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        loadQuestion()
    }

    func setupTable() {
        let textCell = UINib(nibName: "FormTestTableViewCell",
                                      bundle: nil)
        tableView.register(textCell, forCellReuseIdentifier: "myCell")
    }

    func loadQuestion() {
        guard let formTest = formTest else { return }
        questionTest.text = formTest.question
        if formTest.isLast {
            buttonNext.setTitle("Finalizar", for: .normal)
        }
        tableView.reloadData()
    }
}

extension FormTestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formTest?.answer.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? FormTestTableViewCell else { return UITableViewCell() }
        cell.answerLabel?.text = formTest?.answer[safe: indexPath.row]?.answer ?? ""
        cell.answerLabel?.numberOfLines = 0
        cell.answerLabel?.lineBreakMode = .byWordWrapping
        cell.answerLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 41, green: 53, blue: 81, alpha: 0)
        
        if let indexSelected = indexSelected {
            if indexSelected == indexPath.row {
                cell.radioImage.image = UIImage(named: "fullsq")
            } else {
                cell.radioImage.image = UIImage(named: "emptysq")
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected = indexPath.row
        answer = formTest?.answer[safe: indexPath.row]
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
