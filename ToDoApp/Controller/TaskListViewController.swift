//
//  ViewController.swift
//  ToDoApp
//
//  Created by Леонид Лукашевич on 05.01.2022.
//

import UIKit

class TaskListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: DataProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DataProvider().taskManager?.add(task: Task(title: "Foo"))
//        DataProvider().taskManager?.checkTask(at: 0)
//        DataProvider().taskManager?.add(task: Task(title: "Bar"))
    }
}
