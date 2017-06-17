//
//  ViewController.swift
//  LocationThing
//
//  Created by Jiangxuan Chen on 17/06/2017.
//  Copyright © 2017 Jiangxuan Chen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //URL n stufF
    
  
    //linking up with the objects in the storyboard
    
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var horizontalAccuracy: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var verticalAccuracy: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var resetDistance: UIButton!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
    }
    
    //idek
    @IBAction func resetDistance(_ sender: AnyObject) {
        startLocation = nil
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        latitude.text = String(format: "%.4f",
                               latestLocation.coordinate.latitude)
        longitude.text = String(format: "%.4f",
                                latestLocation.coordinate.longitude)
        horizontalAccuracy.text = String(format: "%.4f",
                                         latestLocation.horizontalAccuracy)
        altitude.text = String(format: "%.4f",
                               latestLocation.altitude)
        verticalAccuracy.text = String(format: "%.4f",
                                       latestLocation.verticalAccuracy)
        
        if startLocation == nil {
            startLocation = latestLocation
        }
        
     
        let distanceBetween: CLLocationDistance =
            latestLocation.distance(from: startLocation)
        
        distance.text = String(format: "%.2f", distanceBetween)
        
        let lat = latestLocation.coordinate.latitude
        let long = latestLocation.coordinate.longitude
        let accu = latestLocation.horizontalAccuracy
        
        print(lat)
        print(long)
        
        let myUrl = URL(string: "http://british-pelican.herokuapp.com/coord")
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let json = ["lat":lat, "lon":long, "accuracy": accu]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    // Now we can access value of First Name by its key
                    let firstNameValue = parseJSON["firstName"] as? String
                    print("firstNameValue: \(firstNameValue)")
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
        
    }
    //idek
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
    }
    
    
}


