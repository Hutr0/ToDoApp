//
//  Task.swift
//  ToDoApp
//
//  Created by Леонид Лукашевич on 05.01.2022.
//

import Foundation

struct Task {
    let title: String
    let description: String?
    let location: Location?
    let date: Date
    var isDone = false
    
    init(title: String,
         description: String? = nil,
         date: Date? = nil,
         location: Location? = nil) {
        self.title = title
        self.description = description
        self.date = date ?? Date()
        self.location = location
    }
}

extension Task {
    var dict: PlistDictionary {
        var dictionary: PlistDictionary = [:]
        
        dictionary["title"] = self.title
        dictionary["description"] = self.description
        dictionary["date"] = self.date
        if let location = location {
            dictionary["location"] = location.dict
        }
        
        return dictionary
    }
    
    typealias PlistDictionary = [String : Any]
    init?(dict: PlistDictionary) {
        self.title = dict["title"] as! String
        self.description = dict["description"] as? String
        self.date = dict["date"] as? Date ?? Date()
        if let locationDictionary = dict["location"] as? [String : Any] {
            self.location = Location(dict: locationDictionary)
        } else {
            self.location = nil
        }
    }
}

extension Task: Equatable {
    // lhs - left hand side
    // rhs - right hand side
    static func == (lhs: Task, rhs: Task) -> Bool {
        guard lhs.title == rhs.title
                && lhs.description == rhs.description
                && lhs.location == rhs.location else { return false }
        return true
    }
}
