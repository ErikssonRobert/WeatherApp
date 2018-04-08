//
//  GraphBarViewController.swift
//  WeatherApp
//
//  Created by Robert on 2018-04-08.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit
import GraphKit

class GraphBarViewController: UIViewController, GKBarGraphDataSource {
    @IBOutlet weak var diagram: GKBarGraph!
    @IBOutlet weak var citiesTextView: UITextView!
    
    var weatherArray : [WeatherHolder] = []
    
    func numberOfBars() -> Int {
        print("Columns: \(weatherArray.count)")
        return weatherArray.count
    }
    
    func valueForBar(at index: Int) -> NSNumber! {
        print("Temp for column: \(weatherArray[index].temp)")
        return weatherArray[index].temp as NSNumber
    }
    
    func titleForBar(at index: Int) -> String! {
        return "Bar:\(index)"
    }
    
    func colorForBar(at index: Int) -> UIColor! {
        switch weatherArray[index].temp {
        case -30...8:
            return UIColor.blue
        case 9...15:
            return UIColor.cyan
        case 16...30:
            return UIColor.green
        case 31...40:
            return UIColor.orange
        case 41...60:
            return UIColor.red
        default:
            return UIColor.cyan
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        diagram.dataSource = self
        diagram.draw()
        presentCityNames()
    }
    
    func presentCityNames() {
        var index = 0
        for c in weatherArray {
            print("\(index): \(c.city)")
            citiesTextView.text.append("Bar:\(index): \(c.city.capitalized)\n")
            index += 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
