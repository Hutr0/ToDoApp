//
//  DetailViewController.swift
//  ToDoApp
//
//  Created by Леонид Лукашевич on 08.01.2022.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var task: Task!
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        dateLabel.text = dateFormatter.string(from: task.date)
        locationLabel.text = task.location?.name
        if let coordinate = task.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: 100,
                                            longitudinalMeters: 100)
            mapView.region = region
        }
    }
}
