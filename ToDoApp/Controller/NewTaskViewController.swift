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
    
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var descriptionTF: UITextField!
    @IBOutlet var locationNameTF: UITextField!
    @IBOutlet var addressTF: UITextField!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
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
            
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: locationString!, coordinate: coordinate)
            let task = Task(title: titleString!, description: descriptionString, date: date, location: location)
            
            self.taskManager.add(task: task)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
