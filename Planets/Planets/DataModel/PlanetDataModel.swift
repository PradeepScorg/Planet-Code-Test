//
//  PlanetDataModel.swift
//  Planets
//
//  Created by Pradeep K. Deshmukh on 05/01/19.
//  Copyright © 2019 Pradeep K. Deshmukh. All rights reserved.
//

import Foundation

// MARK: - Data models
class PlanetDataModel {
    var planet: Planet
    
    init(planet: Planet) {
        self.planet = planet
    }
    
    // Planet name
    var planetName: String {
        return self.planet.name
    }
    
}
