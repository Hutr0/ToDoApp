//
//  APIClient.swift
//  ToDoApp
//
//  Created by Леонид Лукашевич on 08.01.2022.
//

import Foundation

enum NetworkError: Error {
    case emptyData
}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    var urlSession: URLSessionProtocol = URLSession.shared
    
    func login(withName name: String, password: String, completionHandler: @escaping (String?, Error?) -> ()) {
        
        let allowedCharacters = CharacterSet.urlQueryAllowed
        guard let name = name.addingPercentEncoding(withAllowedCharacters: allowedCharacters),
              let password = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        else {
            fatalError()
        }
        
        let query = "name=\(name)&password=\(password)"
        guard let url = URL(string: "https://todoapp.com/login?\(query)") else { fatalError() }
        
        urlSession.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completionHandler(nil, error)
                return 
            }
            
            do {
                guard let data = data else {
                    completionHandler(nil, NetworkError.emptyData)
                    return
                }
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                
                let token = dictionary["token"]
                completionHandler(token, nil)
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }
}

//extension String {
//    var percentEncoded: String {
//        let allowedCharacters = CharacterSet(charactersIn: "~!@#$%^&*()-+=[]\\|{},./?<>").inverted
//        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
//        return encodedString
//    }
//}
