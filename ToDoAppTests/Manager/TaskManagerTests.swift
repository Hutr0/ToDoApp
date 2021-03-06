//
//  TaskManagerTests.swift
//  ToDoAppTests
//
//  Created by Леонид Лукашевич on 05.01.2022.
//

import XCTest
@testable import ToDoApp

class TaskManagerTests: XCTestCase {
    
    var sut: TaskManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TaskManager()
    }

    override func tearDownWithError() throws {
        sut.removeAll()
        sut = nil
        try super.tearDownWithError()
    }
    
    func testInitTaskManagerWithZeroTasks() {
        XCTAssertEqual(sut.tasksCount, 0)
    }
    
    func testInitTaskManagerWithZeroDoneTasks() {
        XCTAssertEqual(sut.doneTasksCount, 0)
    }
    
    func testAddTaskIncrementTasksCount() {
        // given
        let task = Task(title: "Foo")
        
        // when
        sut.add(task: task)
        
        // then
        XCTAssertEqual(sut.tasksCount, 1)
    }
    
    func testTaskAtIndexAtAddedTask() {
        // given
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        // when
        let returnedTask = sut.task(at: 0)
        
        // then
        XCTAssertEqual(task, returnedTask)
    }
    
    func testCheckTaskAtIndexChangesCounts() {
        // given
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        // when
        sut.checkTask(at: 0)
        
        // then
        XCTAssertEqual(sut.tasksCount, 0)
        XCTAssertEqual(sut.doneTasksCount, 1)
    }
    
    func testCheckedTaskRemovedFromTasks() {
        let firstTask = Task(title: "Foo")
        let secondTask = Task(title: "Bar")
        sut.add(task: firstTask)
        sut.add(task: secondTask)
        
        sut.checkTask(at: 0)
        
        XCTAssertEqual(sut.task(at: 0), secondTask)
    }
    
    func testDoneTaskAtIndexOfReturnesCheckedTask() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        sut.checkTask(at: 0)
        let returnedTask = sut.doneTask(at: 0)
        
        XCTAssertEqual(task, returnedTask)
    }
    
    func testRemoveAllResultsCountsBeZero() {
        sut.add(task: Task(title: "Foo"))
        sut.add(task: Task(title: "Bar"))
        sut.checkTask(at: 0)
        
        sut.removeAll()
        
        XCTAssertEqual(sut.tasksCount, 0)
        XCTAssertEqual(sut.doneTasksCount, 0)
    }
    
    func testAddingSameObjectDoesNotIncrementCount() {
        sut.add(task: Task(title: "Foo"))
        sut.add(task: Task(title: "Foo"))
        
        XCTAssertTrue (sut.tasksCount == 1)
    }
    
    func testWhenTaskManagerRecreatedSavedTasksShouldBeEqual() {
        var taskManager: TaskManager! = TaskManager()
        let task1 = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        
        taskManager.add(task: task1)
        taskManager.add(task: task2)
        
        NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
        
        taskManager = nil
        
        taskManager = TaskManager()
        
        XCTAssertEqual(taskManager.tasksCount, 2)
        XCTAssertEqual(taskManager.task(at: 0), task1)
        XCTAssertEqual(taskManager.task(at: 1), task2)
    }
    
    func testWhenTaskCheckedHasIsDoneEqualsTrue() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        sut.checkTask(at: 0)
        
        XCTAssertTrue(sut.doneTask(at: 0).isDone)
    }
    
    func testWhenTaskUncheckedHasIsDoneEqualsFalse() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        sut.checkTask(at: 0)
        sut.uncheckTask(at: 0)
        
        XCTAssertFalse(sut.task(at: 0).isDone)
    }
}
