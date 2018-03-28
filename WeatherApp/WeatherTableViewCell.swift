//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Robert on 2018-03-18.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelIcon: UILabel!
    
    var weatherData : WeatherHolder?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
