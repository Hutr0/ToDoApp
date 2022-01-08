//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by Леонид Лукашевич on 08.01.2022.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {
    
    var taskManager: TaskManager!
    var geocoder = CLGeocoder()
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var locationNameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    @IBAction func save() {
        let titleString = titleTF.text
        let descriptionString = descriptionTF.text
        let locationString = locationNameTF.text
        let addressString = addressTF.text
        let date = dateFormatter.date(from: dateTF.text!)
        geocoder.geocodeAddressString(addressString!) { placemarks, error in
            if let error = error {
                print("Placemark has an error: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("Placemark not found.")
                return
            }
            
            guard let coordinate = placemark.location?.coordinate else {
                print("Can't get coordinate.")
                return
            }
            
            let location = Location(name: locationString!, coordinate: coordinate)
            
            let task = Task(title: titleString!,
                            description: descriptionString,
                            date: date,
                            location: location)
            
            self.taskManager.add(task: task)
        }
    }
}
