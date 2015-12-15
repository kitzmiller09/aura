//
//  WeatherViewController.swift
//  Aura
//
//  Created by Andrew Kitzmiller on 12/15/15.
//  Copyright © 2015 Andrew Kitzmiller. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, MenuTransitionManagerDelegate {
    
    var weatherData = NSDictionary()
    var menuTransitionManager = MenuTransitionManager()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionImage: UIImageView!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var windDirLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.sourceViewController as! MenuTableViewController
        self.title = sourceController.currentItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure Nav Bar
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        print(weatherData)
        
        self.navigationItem.title = "AURA"
        
        //Weather Description
        let weatherDescriptionData : NSArray = weatherData["weather"]! as! NSArray
        
        if let description = weatherDescriptionData[0]["main"] as? String{
            descriptionLabel.text? = description
            
            setWeatherImage(description)
        }
        
        //Temperature and humidity info
        if let mainInfo: NSDictionary = weatherData["main"] as? NSDictionary{
            
            //Perform weather temperature conversions
            let temperature = convertToFahrenheit(mainInfo["temp"] as! Double)
            let lowTemperature = convertToFahrenheit(mainInfo["temp_min"] as! Double)
            let highTemperature = convertToFahrenheit(mainInfo["temp_max"] as! Double)
            let humidity = mainInfo["humidity"] as! Int
            
            
            //Update Labels
            currentTemp.text? = temperature + "°"
            lowTemp.text? = lowTemperature + "°"
            highTemp.text? = highTemperature + "°"
            humidityLabel.text? = "\(humidity)%"
        }
        //Wind data
        if let windData: NSDictionary  = weatherData["wind"] as? NSDictionary{
            let windSpeed = windData["speed"] as! Double
            
            let speed = convertToMPH(windSpeed)
            
            windLabel.text? = String(stringInterpolationSegment: speed) + " mph"
            
            if let windDirection = windData["deg"] as? Double{
                let direction = convertToCompass(windDirection)
                
                windDirLabel.text? = direction
            }
        }
    }
    
    func setWeatherImage(desc: String){
        
        switch desc{
        case "Mist", "Fog", "Haze":
            descriptionImage.image = UIImage(named: "Mist.png")
        case "Clear":
            descriptionImage.image = UIImage(named: "Clear.png")
        case "Clouds":
            descriptionImage.image = UIImage(named: "Clouds.png")
        case "Rain", "Thunderstorm":
            descriptionImage.image = UIImage(named: "Rain.png")             //NEED IMAGE FOR THUNDERSTORM
        default:
            descriptionImage.image = UIImage(named: "logo.png")
        }
        
    }
    
    func convertToMPH(kph: Double) -> String {
        
        let mph = kph / 1.609344
        
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        return formatter.stringFromNumber(mph)!
    }
    
    @IBOutlet weak var dayOftheWeek: UILabel!
    
    func convertToFahrenheit(kelvin:Double) -> String{
        let fahr = (kelvin - 273.15) * 1.8 + 32
        
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        
        return formatter.stringFromNumber(fahr)!
    }
    //Convert Degrees to Compass Direction
    func convertToCompass(windDirection: Double) -> String{
        
        var dir = ""
        
        if windDirection >= 338 || windDirection < 22.5{
            dir = "N"
        } else if windDirection >= 22.5 && windDirection < 67.5 {
            dir = "NE"
        } else if windDirection >= 67.5 && windDirection < 112.5 {
            dir = "E"
        } else if windDirection >= 112.5 && windDirection < 157.5 {
            dir = "SE"
        } else if windDirection >= 157.5 && windDirection < 202.5 {
            dir = "S"
        } else if windDirection >= 202.5 && windDirection < 247.5 {
            dir = "SW"
        } else if windDirection >= 247.5 && windDirection < 292.5 {
            dir = "W"
        } else if windDirection >= 292.5 && windDirection < 338{
            dir = "NW"
        }
        
        return dir
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let menuTableViewController = segue.destinationViewController as! MenuTableViewController
        
        menuTableViewController.transitioningDelegate = self.menuTransitionManager  //Transition Animation
        
        self.menuTransitionManager.delegate = self
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
