//
//  APIClient.swift
//  ToDoApp
//
//  Created by Леонид Лукашевич on 08.01.2022.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    var urlSession: URLSessionProtocol = URLSession.shared
    
    func login(withName: String, password: String, completionHandler: @escaping (String?, Error?) -> ()) {
        guard let url = URL(string: "https://todoapp.com/login") else {
            fatalError()
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            
        }.resume()
    }
}
