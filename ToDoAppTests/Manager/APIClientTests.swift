//
//  APIClientTests.swift
//  ToDoAppTests
//
//  Created by Леонид Лукашевич on 08.01.2022.
//

import XCTest
@testable import ToDoApp

class APIClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoginUsesCorrectHost() {
        let mockURLSession = MockURLSession()
        let sut = APIClient()
        sut.urlSession = mockURLSession
        
        let completionHandler = {(token: String?, Error: Error?) in }
        sut.login(withName: "name", password: "qwerty", completionHandler: completionHandler)
        
        guard let url = mockURLSession.url else {
            XCTFail()
            return
        }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "todoapp.com")
    }
}

extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
        
        var url: URL?
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            return URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        }
    }
}
