//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Леонид Лукашевич on 07.01.2022.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    func configure(withTask task: Task) {
        titleLabel.text = task.title
        locationLabel.text = task.location?.name
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        if let date = task.date {
            let dateString = df.string(from: date)
            dateLabel.text = dateString
        }
    }
}
