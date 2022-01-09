//
//  TaskListViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Леонид Лукашевич on 07.01.2022.
//

import XCTest
@testable import ToDoApp

class TaskListViewControllerTests: XCTestCase {
    
    var sut: TaskListViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        sut = vc as? TaskListViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testWhenViewIsLoadedTableViewNotNil() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testWhenViewISLoadedDataProviderIsNotNil() {
        XCTAssertNotNil(sut.dataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDataSourceIsSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateAndTableViewDataSourceIsSet() {
        XCTAssertEqual(
            sut.tableView.delegate as? DataProvider,
            sut.tableView.dataSource as? DataProvider
        )
    }
    
    func testTaskListVCHasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    func testAddNewTaskPresentsNewTaskviewController() {
        XCTAssertNil(sut.presentedViewController)
        
        guard let newTaskButtton = sut.navigationItem.rightBarButtonItem,
              let action = newTaskButtton.action
        else {
            XCTFail()
            return
        }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: newTaskButtton, waitUntilDone: true)
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is NewTaskViewController)
        
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        XCTAssertNotNil(newTaskViewController.titleTF)
    }
    
    func testSharesSameTaskManagerWithNewTaskVC() {
        XCTAssertNil(sut.presentedViewController)
        
        guard let newTaskButtton = sut.navigationItem.rightBarButtonItem,
              let action = newTaskButtton.action
        else {
            XCTFail()
            return
        }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: newTaskButtton, waitUntilDone: true)
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is NewTaskViewController)
        
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        XCTAssertNotNil(sut.dataProvider.taskManager)
        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager)
    }
    
    func testWhenViewAppearedTableViewReloaded() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    func testTappingCellSendsNotification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager!.add(task: task)
        
        expectation(forNotification: NSNotification.Name("DidSelectRow notification"), object: nil) { notification -> Bool in
            
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else { return false }
            
            return task == taskFromNotification
        }
        
        let tableView = sut.tableView
        tableView?.delegate?.tableView!(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSelectedCellNotificationPushesDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        sut.loadViewIfNeeded()
        
        let task1 = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        sut.dataProvider.taskManager?.add(task: task1)
        sut.dataProvider.taskManager?.add(task: task2)
        
        NotificationCenter.default.post(name: NSNotification.Name("DidSelectRow notification"), object: self, userInfo: ["task" : task2])
        
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else {
            XCTFail()
            return
        }
        
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailViewController.task == task2)
    }
}

extension TaskListViewControllerTests {
    class MockTableView: UITableView {
        var isReloaded = false
        
        override func reloadData() {
            isReloaded = true
        }
    }
}

extension TaskListViewControllerTests {
    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
