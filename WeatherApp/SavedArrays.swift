//
//  SavedArrays.swift
//  WeatherApp
//
//  Created by Robert on 2018-03-26.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class SavedArrays: NSObject {

    func saveArray(array: [WeatherHolder]) {
        print("Trying to save...")
        let save = UserDefaults()
        let arrayData = try! JSONEncoder().encode(array)
        save.set(arrayData, forKey: "fav")
        //save.synchronize()
        print("Save success!")
    }
    
    func loadArray() -> [WeatherHolder] {
        print("Trying to load...")
        let load = UserDefaults()
        if let arrayData = load.data(forKey: "fav") {
            print("Load success!")
            let array = try! JSONDecoder().decode([WeatherHolder].self, from: arrayData)
            return array
        } else {
            return [] as! [WeatherHolder]
        }
    }
    
}
