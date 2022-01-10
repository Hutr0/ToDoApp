//
//  ToDoAppUITests.swift
//  ToDoAppUITests
//
//  Created by Леонид Лукашевич on 05.01.2022.
//

import XCTest

class ToDoAppUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--UITesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertTrue(app.isOnMainView)
        
        app.navigationBars["ToDoApp.TaskListView"].buttons["Add"].tap()
        
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Foo")
        
        app.textFields["Date"].tap()
        app.textFields["Date"].typeText("01.11.20")
        
        app.textFields["Location name"].tap()
        app.textFields["Location name"].typeText("Bar")
        
        app.textFields["Address"].tap()
        app.textFields["Address"].typeText("Moscow")
        
        app.textFields["Description"].tap()
        app.textFields["Description"].typeText("Baz")
        
        
        XCTAssertFalse(app.isOnMainView)
        app.buttons["Save"].tap()
        
        XCTAssertTrue(app.tables.cells.staticTexts["Foo"].exists)
        XCTAssertTrue(app.tables.cells.staticTexts["Bar"].exists)
        XCTAssertTrue(app.tables.cells.staticTexts["01.11.20"].exists)
    }
    
    func testWhenCellIsSwipedLeftDoneButtonAppeared() {
        XCTAssertTrue(app.isOnMainView)
        
        app.navigationBars["ToDoApp.TaskListView"].buttons["Add"].tap()
        
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Foo")
        
        app.textFields["Date"].tap()
        app.textFields["Date"].typeText("01.11.20")
        
        app.textFields["Location name"].tap()
        app.textFields["Location name"].typeText("Bar")
        
        app.textFields["Address"].tap()
        app.textFields["Address"].typeText("Moscow")
        
        app.textFields["Description"].tap()
        app.textFields["Description"].typeText("Baz")
        
        
        XCTAssertFalse(app.isOnMainView)
        app.buttons["Save"].tap()
        
        XCTAssertTrue(app.isOnMainView)
        
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).swipeLeft()
        tablesQuery.element(boundBy: 0).buttons["Done"].tap()
        
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "date").label, "")
        
    }
}

extension XCUIApplication {
    var isOnMainView: Bool {
        return otherElements["mainView"].exists
    }
}
