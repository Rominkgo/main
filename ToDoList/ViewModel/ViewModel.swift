//
//  ViewModel.swift
//  ToDoList
//
//  Created by Default on 12/9/22.
//

import Foundation
import UIKit
import CoreData


class ViewModel: NSObject {
    
    private var toDoList: [ToDoItem] = [ToDoItem(title: "one", done: false), ToDoItem(title: "one", done: false)]
    
    var items: [NSManagedObject] = []
    
    var container: NSPersistentContainer!
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var toDoListCount: Int {
        return toDoList.count
    }
    
    var lastElementInList: Int {
        return toDoList.endIndex - 1
    }
    
    func createToDoItem(withTitle title: String) {
        let newToDoItem = ToDoItem(title: title, done: false)
        toDoList.append(newToDoItem)
    }
    
    func getToDoItem(_ atIndex: Int) -> ToDoItem {
        return toDoList[atIndex]
    }
    
    
    func save(title: String) {
        
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ThingToDo", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        item.setValue(title, forKeyPath: "title")

        do {
            try managedContext.save()
            items.append(item)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}

