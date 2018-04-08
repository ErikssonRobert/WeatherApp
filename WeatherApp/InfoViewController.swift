//
//  InfoViewController.swift
//  WeatherApp
//
//  Created by Robert on 2018-03-23.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var textViewInfo: UITextView!
    @IBOutlet weak var imageOutfitOne: UIImageView!
    @IBOutlet weak var imageOutfitTwo: UIImageView!
    @IBOutlet weak var labelRecommended: UILabel!
    @IBOutlet weak var labelSaved: UILabel!
    
    var dynamicAnimator : UIDynamicAnimator!
    var push : UIPushBehavior!
    var snap : UISnapBehavior!
    
    var weatherInfo : WeatherHolder = WeatherHolder()
    let save = SavedArrays()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = self.weatherInfo.city.capitalized
        
        self.textViewInfo.text =    """
                                    Temperature: \(self.weatherInfo.temp)°
                                    Humidity: \(self.weatherInfo.humidity)%
                                    Windspeed: \(self.weatherInfo.windSpeed) m/s
                                    """
        
        self.labelSaved.isHidden = true
        saveButtonEnabled()
        
        decideCatImages()
        
        // Setup animations
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        snap = UISnapBehavior(item: labelSaved, snapTo: labelSaved.center)
        snap.damping = 0.2
        dynamicAnimator.addBehavior(snap)
        animateTextViews()
    }
    
    func animateTextViews() {
        UIView.beginAnimations("textView animation", context: nil)
        UIView.setAnimationDuration(2.0)
        self.textViewInfo.alpha = 1.0
        self.imageOutfitOne.alpha = 1.0
        self.imageOutfitTwo.alpha = 1.0
        self.labelRecommended.alpha = 1.0
        
        UIView.commitAnimations()
    }
    
    func decideCatImages() {
        switch self.weatherInfo.temp {
        case -10...8:
            imageOutfitOne.image = UIImage(named: "wintercoat")
        case 9...15:
            imageOutfitOne.image = UIImage(named: "coat")
        case 16...25:
            imageOutfitOne.image = UIImage(named: "shirt")
        case 26...50:
            imageOutfitOne.image = UIImage(named: "summerwear")
        default:
            return
        }
        
        switch self.weatherInfo.icon {
        case "09d", "09n", "10d", "10n":
            if self.weatherInfo.windSpeed > 5 {
                imageOutfitTwo.image = UIImage(named: "raincoat")
            } else {
                imageOutfitTwo.image = UIImage(named: "umbrella")
            }
        case "13d", "13n":
            imageOutfitTwo.image = UIImage(named: "hatnscarf")
        case "01d":
            imageOutfitTwo.image = UIImage(named: "sunny")
        default:
            return
        }
        
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        var array : [WeatherHolder] = save.loadArray()
        array.append(self.weatherInfo)
        print(array)
        save.saveArray(array: array)
        
        self.labelSaved.isHidden = false

        push = UIPushBehavior(items: [labelSaved], mode: .instantaneous)
        push.pushDirection = CGVector(dx: 0.4, dy: 1)
        push.magnitude = 8.0
        dynamicAnimator.addBehavior(push)
        
        self.saveButtonEnabled()
    }
    
    func saveButtonEnabled() {
        if checkIfSaved() {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func checkIfSaved() -> Bool {
        let array : [WeatherHolder] = save.loadArray()
        for a in array {
            if a.city == self.weatherInfo.city {
                return true
            }
        }
        return false
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
