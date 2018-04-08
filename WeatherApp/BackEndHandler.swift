//
//  BackEndHandler.swift
//  WeatherApp
//
//  Created by Robert on 2018-04-05.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class BackEndHandler: NSObject {
    
    // Structs
    struct Temp : Codable {
        let temp: Double?
        let humidity: Int
    }
    
    struct TempResponse : Codable {
        let main: Temp
    }
    
    struct Speed : Codable {
        let speed: Double?
    }
    
    struct WindResponse : Codable {
        let wind: Speed
    }
    
    struct Icon : Codable {
        let icon: String
    }
    
    struct WeatherResponse : Codable {
        let weather: [Icon]
    }
    
    // Cell color
    func decideBackgroundColor(icon: String) -> UIColor{
        switch icon {
        case "09d", "09n", "10d", "10n":
            return UIColor.init(red: 0.0, green: 0.0, blue: 0.8, alpha: 0.3)
        case "01d":
            return UIColor.init(red: 0.8, green: 0.8, blue: 0.0, alpha: 0.3)
        case "02d":
            return UIColor.init(red: 0.4, green: 0.4, blue: 0.0, alpha: 0.3)
        case "02n":
            return UIColor.init(red: 0.2, green: 0.0, blue: 0.2, alpha: 0.3)
        case "03d", "03n", "04d", "04n":
            return UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3)
        case "50d", "50n":
            return UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.3)
        case "01n":
            return UIColor.init(red: 0.4, green: 0.0, blue: 0.4, alpha: 0.3)
        default:
            return UIColor.clear
        }
    }
}
