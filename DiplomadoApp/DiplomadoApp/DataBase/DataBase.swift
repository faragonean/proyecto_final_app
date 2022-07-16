//
//  Database.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 10/07/22.
//

import Foundation
import CoreData

final class DataBase {

    static let shared = DataBase()

    private let modelName = "DiplomadoApp"

    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: modelName)

        let urlStr = Bundle.main.path(forResource: modelName, ofType: "sqlite")
        let url = URL(fileURLWithPath: urlStr!)
        let persistentStoreDescription = NSPersistentStoreDescription(url: url)
        persistentStoreDescription.setOption(NSString("true"), forKey: NSReadOnlyPersistentStoreOption)
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func loadContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveQuestion() {
        let context = persistentContainer.viewContext
        let question = Question(context: context)
        question.question = "Pregunta 1"

        let answer = Answer(context: context)
        answer.answer = "Answer 1"
        answer.question = question

        let knowledge = Knowledge_Area(context: context)
        knowledge.area = "Matematicas"

        let weight = Weighing(context: context)
        weight.answer = answer
        weight.weight = 0.2
        weight.knowledge = knowledge

        let university = University(context: context)
        university.university = "Universidad 1"

        let universityC = University_Career(context: context)
        universityC.career = "Carrera 1"
        universityC.university = university
        universityC.knowledge = knowledge

        do {
            try context.save()
        }
        catch {
            // Handle Error
        }
    }

    func deleteAll() {
        let storeContainer = persistentContainer
            .persistentStoreCoordinator

        do {
            for store in storeContainer.persistentStores {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            }

            persistentContainer = NSPersistentContainer(
                name: modelName
            )

            persistentContainer.loadPersistentStores {
                (store, error) in
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func getQuestions() -> [Question] {
        let fetchRequest: NSFetchRequest<Question>
        fetchRequest = Question.fetchRequest()
        fetchRequest.fetchLimit = 5
        fetchRequest.fetchOffset = randomBool() ? 0: 5
        let context = persistentContainer.viewContext
        do {
            let questions = try context.fetch(fetchRequest)
            return questions
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }

    func getKnowledge(area: String) -> Knowledge_Area? {
        let fetchRequest: NSFetchRequest<Knowledge_Area>
        fetchRequest = Knowledge_Area.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "area LIKE %@", area
        )
        let context = persistentContainer.viewContext
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
