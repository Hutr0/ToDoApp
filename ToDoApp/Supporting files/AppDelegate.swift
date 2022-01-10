//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Леонид Лукашевич on 05.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if targetEnvironment(simulator)
        if CommandLine.arguments.contains("--UITesting") {
            resetState()
        }
        #endif
        
        return true
    }
    
    private func resetState() {
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let url = URL(string: "\(documentPath)tasks.plist") else { return }
        print("Tasks file directory: \(documentPath)")
        try? FileManager.default.removeItem(at: url)
    }

}

