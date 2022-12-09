//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Default on 12/9/22.
//

import Foundation


struct ToDoItem {
    var title: String
    var done: Bool

    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
    
    init?(_ pList: [String: Any]?) {
        guard let propertyList = pList,
              let title = propertyList["title"] as? String,
              let done = propertyList["done"] as? Bool else {
                  return nil
              }
        
        self.title = title
        self.done = done
    }
    
    func getPropertyList() -> [String: Any] {
        return ["title": self.title, "done": self.done]
    }
}
