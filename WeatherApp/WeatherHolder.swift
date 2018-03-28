//
//  WeatherHolder.swift
//  WeatherApp
//
//  Created by Robert on 2018-03-21.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class WeatherHolder: NSObject, Codable{
    
    var city: String = ""
    var temp: Double = 0.0
    var humidity: Int = 0
    var windSpeed: Double = 0.0
    var icon: String = ""
    
    var icons = [
        "01d": "☀️",
        "02d": "🌤",
        "03d": "🌥",
        "04d": "☁️",
        "09d": "🌧",
        "10d": "🌦",
        "11d": "🌩",
        "13d": "🌨",
        "01n": "🌙",
        "02n": "☁️",
        "03n": "☁️",
        "04n": "☁️",
        "09n": "🌧",
        "10n": "🌧",
        "11n": "🌩",
        "13n": "🌨",
        "50d": "🌫",
        "50n": "🌫"
    ]
    
    

}
