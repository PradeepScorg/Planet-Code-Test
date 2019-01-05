//
//  ViewController.swift
//  Planets
//
//  Created by Pradeep K. Deshmukh on 05/01/19.
//  Copyright © 2019 Pradeep K. Deshmukh. All rights reserved.
//

import UIKit

class PlanetsViewController: UIViewController {
    
    // MARK: - Properties
    var recordsFound = false
    
    // MARK: - Store planets info
    var planets: [Planet] = []
    var previousPage: String?
    var nextPage: String?
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        //self.fetchDBRecords()
        self.fetchPlanetRecords()
    }
    
    // MARK: - Api Methods
    // Fetch Records from Online through API, if no data returned from API,
    // check and display data from local database if records exists
    //
    private func fetchPlanetRecords(url: String = Constant.initialUrl) {
        
        self.showProgress()
        NetworkManager.fetchPlanets(with: url) { [weak self] (dataResponse, error) in
            
            // Validate the response from API
            guard let data = dataResponse as? Data else {
                if let error = error {
                    DispatchQueue.main.async {
                        self?.promptMessage(message: error.localizedDescription)
                        
                        // Show records from local DB
                        // if the Internet connection appears to be offline.
                        self?.fetchDBRecords()
                        self?.hideProgress()
                        
                    }
                }
                return
            }
            
            // Parse and store data
            if let parsedData: Page = Planet.parse(data: data) {
                self?.planets.append(contentsOf: parsedData.planets)
                self?.previousPage = parsedData.previousPage
                self?.nextPage = parsedData.nextPage
                
                DispatchQueue.main.async {
                    
                    //Delete records to fetech or update local database
                    if (!self!.recordsFound) {
                        CoredataManager().deleteRecords()
                        self!.recordsFound = true
                    }
                    self?.saveDBRecords(planets: parsedData.planets)
                }
                
            } else {
                DispatchQueue.main.async {
                    self?.promptMessage(message: "Sorry could not fetch records.")
                }
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.hideProgress()
            }
        }
        
    }
    
    // Prompt message
    //
    private func promptMessage(message: String) {
        let alert = UIAlertController(title: "Planets", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - CoreData
    // Save data to coredata
    //
    private func saveDBRecords(planets: [Planet]) {
        CoredataManager().saveRecords(planets: planets) {
            print("Records saved success")
        }
    }
    
    //Fetch data and display from coredata if exists
    //
    private func fetchDBRecords() {
        CoredataManager().fetchRecords { (planets: [Planet]) in
            self.planets = planets
            self.tableView.reloadData()
        }
    }
    
    
}

// MARK: - View Controller Extensions
// TableViewDataSource delegate method
//
extension PlanetsViewController: UITableViewDataSource {
    
    // Numbers of row in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planets.count
    }
    
    // Display data to user and when there is no records to display prompt user message
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: PlanetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "planetCell", for: indexPath) as? PlanetTableViewCell else {
            return UITableViewCell()
        }
        
        // Show data to user
        let planetModel = PlanetDataModel(planet: self.planets[indexPath.row])
        cell.labelTitle.text = planetModel.planetName
        
        // Fetch data from url and display to user
        // if last page prompt user
        if indexPath.row == self.planets.count - 1 {
            if let url = self.nextPage {
                self.fetchPlanetRecords(url: url)
            } else {
                self.promptMessage(message: "No more records to show")
            }
        }
        return cell
    }
    
}

// TableViewDelegate method for click and adjust row height
//
extension PlanetsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell tapped")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}

