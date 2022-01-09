//
//  TaskTests.swift
//  ToDoAppTests
//
//  Created by Леонид Лукашевич on 05.01.2022.
//

import XCTest
@testable import ToDoApp

class TaskTests: XCTestCase {
    
    func testInitTaskWithTitle() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task)
    }
    
    func testInitTaskWithTitleAndDescription() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertNotNil(task)
    }
    
    func testWhenGivenTitleSetsTitle() {
        let title = "Foo"
        
        let task = Task(title: title)
        
        XCTAssertEqual(task.title, title)
    }
    
    func testWhenGivenDescriptionSetsDescription() {
        let description = "Bar"
        
        let task = Task(title: "Foo", description: description)
        
        XCTAssertEqual(task.description, description)
    }
    
    func testTaskInitsWithDate() {
        let task = Task (title: "Foo")
        
        XCTAssertNotNil(task.date)
    }
    
    func testWhenGivenLocationSetsLocation() {
        let location = Location(name: "Foo")
        
        let task = Task(title: "Bar",
                        description: "Baz",
                        location: location)
        
        XCTAssertEqual(location, task.location)
    }
    
    func testCanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Baz")
        let date = Date(timeIntervalSince1970: 1604210400)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let locationDictionary: [String: Any] = ["name": "Baz"]
        let dictionary: [String: Any] = ["title": "Foo",
                                         "description": "Bar",
                                         "date": date,
                                         "location": locationDictionary]
        let createdTask = Task(dict: dictionary)
        
        XCTAssertEqual(task, createdTask)
    }
    
    func testCanBeSerializedIntoDictionary() {
        let location = Location(name: "Baz")
        let date = Date(timeIntervalSince1970: 1604210400)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let generatedTask = Task(dict: task.dict)
        
        XCTAssertEqual(task, generatedTask)
    }
}
 
