//
//  DataProviderTests.swift
//  ToDoAppTests
//
//  Created by Леонид Лукашевич on 07.01.2022.
//

import XCTest
@testable import ToDoApp

class DataProviderTests: XCTestCase {
    
    var sut: DataProvider!
    var tableView: UITableView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DataProvider()
        sut.taskManager = TaskManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as? TaskListViewController
        
        controller?.loadViewIfNeeded()
        
        tableView = controller?.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        sut.taskManager?.removeAll()
        sut = nil
        tableView = nil
        try super.tearDownWithError()
    }
    
    func testNumberOfSectionIsTwo() {
        let numberOfSections = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSections, 2)
    }
    
    func testNumberOfRowsInSectionZeroIsTasksCount() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testNumberOfRowsInSectionOneIsDoneTasksCount() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        sut.taskManager?.checkTask(at: 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, tableView.numberOfRows(inSection: 1))
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        XCTAssertEqual(sut.taskManager?.doneTasksCount, tableView.numberOfRows(inSection: 1))
    }
    
    func testCellForRowAtIndexPathReturnTaskCell() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is TaskCell)
    }
    
    func testCellForRowAtIndexPathDequeuesCellFromTableView() {
        let mockTableView = MockTableView.makeMock(withDataSource: sut)
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        mockTableView.reloadData()
        
        mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellIsDequeued)
    }
    
    func testCellForRowInSectionZeroCallsConfigure() {
        let mockTableView = MockTableView.makeMock(withDataSource: sut)
        
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    func testCellForRowInSectionOneCallsConfigure() {
        let mockTableView = MockTableView.makeMock(withDataSource: sut)
        
        let task = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        sut.taskManager?.add(task: task)
        sut.taskManager?.add(task: task2)
        sut.taskManager?.checkTask(at: 0)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockTaskCell

        XCTAssertEqual(cell.task, task)
    }
    
    func testDeleteButtonTitleInSectionZeroShowsDone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(buttonTitle, "Done")
    }
    
    func testDeleteButtonTitleInSectionOneShowsUndone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(buttonTitle, "Undone")
    }
    
    func testCheckingTaskChecksInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)
    }
    
    func testUncheckingTaskUnchecksInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)
    }
    
    func testWhenSectionsHasntTasksSectionsNameNotSet() {
        let firstSectionTitle = sut.tableView(tableView, titleForHeaderInSection: 0)
        let secondSectionTitle = sut.tableView(tableView, titleForHeaderInSection: 1)
        
        XCTAssertNil(firstSectionTitle)
        XCTAssertNil(secondSectionTitle)
    }
    
    func testWhenFirstSectionHasTaskFirstSectionNameIsSet() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        tableView.reloadData()
        
        let title = sut.tableView(tableView, titleForHeaderInSection: 0)
        
        XCTAssertNotNil(title)
    }
    
    func testWhenSecondSectionHasTaskSecondSectionNameIsSet() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        
        let title = sut.tableView(tableView, titleForHeaderInSection: 1)
        
        XCTAssertNotNil(title)
    }
    
    func testWhenSectionsHasTasksSectionsNameIsSet() {
        let task1 = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        sut.taskManager?.add(task: task1)
        sut.taskManager?.add(task: task2)
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        
        let firstSectionTitle = sut.tableView(tableView, titleForHeaderInSection: 0)
        let secondSectionTitle = sut.tableView(tableView, titleForHeaderInSection: 1)
        
        XCTAssertNotNil(firstSectionTitle)
        XCTAssertNotNil(secondSectionTitle)
    }
}

extension DataProviderTests {
    class MockTableView: UITableView {
        var cellIsDequeued = false
        
        static func makeMock(withDataSource dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 414, height: 896), style: .plain)
            mockTableView.dataSource = dataSource
            mockTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
            return mockTableView
        }
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellIsDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    }
    
    class MockTaskCell: TaskCell {
        var task: Task?
        
        override func configure(withTask task: Task, done: Bool = false) {
            self.task = task
        }
    }
}
