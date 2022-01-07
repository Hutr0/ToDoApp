//
//  Task.swift
//  ToDoApp
//
//  Created by Леонид Лукашевич on 05.01.2022.
//

import Foundation

struct Task {
    private(set) var date: Date?
    let title: String
    let description: String?
    let location: Location?
    
    init(title: String) {
        self.title = title
        self.date = Date()
        self.description = nil
        self.location = nil
    }
    
    init(title: String,
         description: String? = nil,
         location: Location? = nil) {
        self.title = title
        self.description = description
        self.date = Date()
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
