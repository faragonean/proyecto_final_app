//
//  PageTestViewController.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 11/07/22.
//

import UIKit
import CoreData

class PageTestViewController: UIViewController {

    @IBOutlet private weak var pageControllerContainer: UIView!
    private var viewControllers: [UIViewController] = []
    private var currentPageIndex: Int = 0
    private var result: [(String, Float)] = []

    private lazy var pageViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        controller.delegate = self
        controller.dataSource = self
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        displayPageViewControllers()
    }
    
    func setupPages() {
        navigationController?.navigationBar.prefersLargeTitles = false
        pageControllerContainer.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.bindFrameToSuperviewBounds()
        view.setNeedsUpdateConstraints()
    }

    func displayPageViewControllers() {
        guard viewControllers.isEmpty else {
                  setCurrentViewController()
                  return
        }
        loadViewControllers()
        setCurrentViewController()
        removeSwipeGesture()
    }

    func loadViewControllers() {
        let questions = DataBase.shared.getQuestions().shuffled()

        for (index, item) in questions.enumerated() {
            guard let answer = item.answers else { return }
            let answers: [Answer] = answer.toArray()
            let formTest = FormTest(index: index,
                                    question: item.question ?? "",
                                    answer: answers,
                                    isLast: index+1 == questions.count)
            let viewcontroller = FormTestViewController(formTest: formTest)
            viewcontroller.delegate = self
            viewControllers.append(viewcontroller)
        }
    }

    func removeSwipeGesture() {
        for view in self.pageViewController.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }

    func setCurrentViewController() {
        guard !viewControllers.isEmpty else { return }
        DispatchQueue.main.async { [weak self] in
            if let viewController = self?.viewControllers[safe: self?.currentPageIndex ?? 0] {
                self?.pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - PageViewController Data & Delegate
extension PageTestViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        currentPageIndex = viewControllerIndex
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0, viewControllers.count > previousIndex else { return nil }

        return viewControllers[safe: previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        
        currentPageIndex = viewControllerIndex
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = viewControllers.count
        guard orderedViewControllersCount != nextIndex, orderedViewControllersCount > nextIndex else { return nil }

        return viewControllers[safe: nextIndex]
    }
}

extension PageTestViewController: FormTestViewControllerDelegate {
    func nextPage(answer: Answer) {
        guard !viewControllers.isEmpty else { return }
        addResult(answer: answer)
        if currentPageIndex+1 == viewControllers.count {
            result.sort { $0.1 > $1.1 }
            performSegue(withIdentifier: "goToResult", sender: result)
        } else {
            currentPageIndex = currentPageIndex + 1
            setCurrentViewController()
        }
    }

    func addResult(answer: Answer) {
        guard let area = answer.weighing?.knowledge?.area,
              let weight = answer.weighing?.weight else { return }
        if result.contains(where: { $0.0 == area }) {
            result = result.map { key, w -> (String, Float) in
                if key == area {
                    return (key, weight + w)
                }
                return (key, w)
            }
        } else {
            result.append((area, weight))
        }
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
