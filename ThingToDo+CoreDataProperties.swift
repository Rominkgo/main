//
//  ThingToDo+CoreDataProperties.swift
//  ToDoList
//
//  Created by Default on 12/9/22.
//
//

import Foundation
import CoreData


extension ThingToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ThingToDo> {
        return NSFetchRequest<ThingToDo>(entityName: "ThingToDo")
    }

    @NSManaged public var title: String?
    @NSManaged public var done: Bool
    

}

extension ThingToDo : Identifiable {

}
