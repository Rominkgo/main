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
    private var thingsToDo: [ThingToDo] = []
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
      //  return thingsToDo.count
    }
    
    var lastElementInList: Int {
        return toDoList.endIndex - 1
     //   return thingsToDo.endIndex - 1
    }
    
    func createToDoItem(withTitle title: String) {
        let newToDoItem = ToDoItem(title: title, done: false)
        toDoList.append(newToDoItem)
        //thingsToDo.append(newToDoItem)
    }
    
    func getToDoItem(_ atIndex: Int) -> ToDoItem {
        return toDoList[atIndex]
    //    return thingsToDo[atIndex]
        
    }
    
    func removeToDoItem(_ atIndex: Int) {
        self.toDoList.remove(at: atIndex)
        return 
    //    return thingsToDo[atIndex]
    }
    
    func markAsDone(_ atIndex: Int) {
        var item = self.toDoList[atIndex]
        item.done = true
        return
    //    return thingsToDo[atIndex]
    }
    
    func isItDone(_ atIndex: Int) -> Bool {
        var item = self.toDoList[atIndex]
        if item.done == true{
            return true
        } else {
            return false
        }
    }
    
//    func markToDoItem(_ atIndex: Int) {
//        let text = self.toDoList.title
//        var newText = "\(text) + Yay!"
//        return
//    //    return thingsToDo[atIndex]
        
//    }
    
    
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
    
    func itemFetch(title: String) -> [ThingToDo] {
        let request: NSFetchRequest<ThingToDo> = ThingToDo.fetchRequest()
        print(request)
        var fetchedItems: [ThingToDo] = []
        return fetchedItems
    }
    
    func getItem() -> [ThingToDo]? {
        let request: NSFetchRequest<ThingToDo> = ThingToDo.fetchRequest()
        let result = try? persistentContainer.viewContext.fetch(request)
        return result
    }
    
    func transferToList() {
        let fetchedList = getItem() ?? []
        thingsToDo.append(contentsOf: fetchedList)
    }
}

