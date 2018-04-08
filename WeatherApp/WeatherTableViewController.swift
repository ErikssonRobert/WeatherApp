//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by Robert on 2018-03-18.
//  Copyright © 2018 Robert Eriksson. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var favourites : [WeatherHolder] = []
    var searchResult : [WeatherHolder] = []
    var compareArray : [WeatherHolder] = []
    
    var searchController : UISearchController! //Trust me! Det funkar.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather Search"
        
        let load = SavedArrays()
        favourites = load.loadArray()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        setupLongPress()
        
        tableView.tableFooterView = UIView()
    }
    
    func setupLongPress() {
        let longpressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
        longpressRecognizer.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(longpressRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let load = SavedArrays()
        favourites = load.loadArray()
        updateFavouritesWeather()
        tableView.reloadData()
        compareArray = [] //reset array for next compare
    }
    
    func updateFavouritesWeather() {
        for f in favourites {
            DispatchQueue.global(qos: .background).async {
                self.getApiResult(cityName: f.city, isSearched: false)
            }
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased() {
            if text.count >= 2 {
                getApiResult(cityName: text, isSearched: true)
            }
        } else {
            searchResult = []
        }
        tableView.reloadData()
    }
    
    func getApiResult(cityName: String, isSearched: Bool) {
        if let safeString = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(safeString)&units=metric&APPID=da1637286b3a96c8294926686337d097") {
            print("Searching...")
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler:
            { (data : Data?, response : URLResponse?, error : Error?) in
                if let actualError = error {
                    print(actualError)
                } else {
                    print("Got response from server!")
                    if let actualData = data {
                        
                        let decoder = JSONDecoder()
                        //print(String(data: actualData, encoding: String.Encoding.utf8))
                        do {
                            //Structs get their values
                            let tempResponse = try decoder.decode(BackEndHandler.TempResponse.self, from: actualData)
                            print("Result = \(tempResponse)")
                            
                            let windResponse = try decoder.decode(BackEndHandler.WindResponse.self, from: actualData)
                            print("Result = \(windResponse)")
                            
                            let weatherResponse = try decoder.decode(BackEndHandler.WeatherResponse.self, from: actualData)
                            print("Result = \(weatherResponse)")
                            
                            let weather = WeatherHolder()
                            weather.city = cityName
                            weather.temp = floor(tempResponse.main.temp!)
                            weather.humidity = tempResponse.main.humidity
                            weather.windSpeed = windResponse.wind.speed!
                            weather.icon = weatherResponse.weather[0].icon
                            //Values in structs are put into resultArray
                            if isSearched {
                                var exists = false
                                for s in self.searchResult {
                                    if s.city == cityName {
                                        exists = true
                                        self.searchResult[self.searchResult.index(of: s)!] = weather
                                    }
                                }
                                if !exists {
                                    self.searchResult.append(weather)
                                }
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            } else {
                                for f in self.favourites {
                                    if f.city == cityName {
                                        self.favourites[self.favourites.index(of: f)!] = weather
                                    }
                                }
                            }
                        } catch let e {
                            print("Error passing json: \(e)")
                        }
                    } else {
                        print("Data was nil")
                    }
                }
            })
            
            task.resume()
            print("Sending request!")
        } else {
            print("Bad url string")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if shouldUseSearchResult {
            return 2
        } else {
            return 1
        }
        
    }
    
    var shouldUseSearchResult : Bool {
        if let text = searchController.searchBar.text {
            if text.isEmpty {
                return false
            } else {
                return searchController.isActive
            }
        } else {
            return false
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldUseSearchResult {
            if section == 1 {
                return favourites.count
            } else {
                return searchResult.count
            }
        } else {
            return favourites.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        
        let array : [WeatherHolder]
        
        if shouldUseSearchResult {
            if indexPath.section == 1 {
                array = favourites
            } else {
                array = searchResult.reversed()
            }
        } else {
            array = favourites
        }
        
        cell.weatherData = array[indexPath.row]
        cell.labelCity.text = array[indexPath.row].city.capitalized
        cell.labelTemp.text = "\(array[indexPath.row].temp)°"
        cell.labelIcon.text = array[indexPath.row].icons[array[indexPath.row].icon]
        cell.setBackgroundColor(icon: cell.weatherData!.icon)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting: \(favourites[indexPath.row].city)")
            // Delete the row from the data source
            self.favourites.remove(at: indexPath.row)
            SavedArrays().saveArray(array: favourites)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Deleted!")
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == .began {
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.cyan
                compareArray.append((tableView.cellForRow(at: indexPath) as! WeatherTableViewCell).weatherData!)
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoreInfoSegue" {
            if let infoViewController = segue.destination as? InfoViewController {
                infoViewController.weatherInfo = (sender as! WeatherTableViewCell).weatherData!
            }
        } else if segue.identifier == "CompareSegue" {
            if let graphBarViewController = segue.destination as? GraphBarViewController {
                graphBarViewController.weatherArray = compareArray
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if shouldUseSearchResult {
            if section == 1 {
                return "Saved cities"
            } else {
                return "Search results"
            }
        } else {
            return "Saved cities"
        }
        
    }

}
