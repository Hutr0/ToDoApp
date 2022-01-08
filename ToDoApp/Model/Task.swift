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
    
    init(title: String) {
        self.title = title
        self.date = Date()
        self.description = nil
        self.location = nil
    }
    
    init(title: String,
         description: String? = nil,
         date: Date = Date(),
         location: Location? = nil) {
        self.title = title
        self.description = description
        self.date = date
        self.location = location
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
