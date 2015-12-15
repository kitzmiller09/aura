//
//  ViewController.swift
//  Aura
//
//  Created by Andrew Kitzmiller on 12/15/15.
//  Copyright © 2015 Andrew Kitzmiller. All rights reserved.
//

import UIKit
import CoreLocation

class LoadingViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var results = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                //DISPLAY ERROR ALERT
                print(error)
            } else {
                if let p = placemarks?.first {
                    self.findWeather(p)
                }
            }
        })
        
    }
    
    func findWeather(p: CLPlacemark){
        
        let latitude = String(stringInterpolationSegment: p.location!.coordinate.latitude)   //Current Location's Latitude
        
        let longitude = String(stringInterpolationSegment: p.location!.coordinate.longitude) //Current Location's Longitude
        
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=" + latitude + "&lon=" + longitude + "&APPID=bd3fc7e40f32895107fd4c6fd76f039d") //The Weather API using long/lat coordinates
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if error != nil {
                print(error)
            } else {
                let weatherResults = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                self.results = weatherResults
                
                //Signup Success
                self.performSegueWithIdentifier("showWeather", sender: self)
            }
        })
        
        task.resume()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWeather" {
            let navVC = segue.destinationViewController as! UINavigationController
            
            let weatherViewController = navVC.viewControllers.first as! WeatherViewController
            
            weatherViewController.weatherData = self.results
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



