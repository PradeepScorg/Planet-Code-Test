//
//  PlanetModel.swift
//  Planets
//
//  Created by Pradeep K. Deshmukh on 05/01/19.
//  Copyright © 2019 Pradeep K. Deshmukh. All rights reserved.
//

import Foundation

// MARK: - Struct Types

// Types to store page information data
struct Page: Decodable {
    var nextPage: String?
    var previousPage: String?
    var planets: [Planet]
    
    enum CodingKeys : String, CodingKey {
        case nextPage = "next"
        case previousPage = "previous"
        case planets = "results"
    }
}

// Types to store Planet information data
struct Planet: Decodable {
    
    var name: String
    var rotation_period: String
    var orbital_period: String
    var diameter: String
    var climate: String
    var gravity: String
    var terrain: String
    var surface_water: String
    var population: String
    var created: String
    var edited: String
    var url: String
    var residents: [String]
    var films: [String]
    
    enum CodingKeys : String, CodingKey {
        case name
        case rotation_period
        case orbital_period
        case diameter
        case climate
        case gravity
        case terrain
        case surface_water
        case population
        case residents
        case films
        case created
        case edited
        case url
    }
    
    //Parse planet data
    static func parse(data: Data) -> Page? {
        guard let page = try? JSONDecoder().decode(Page.self, from: data) else {
            print("Could not parse json response")
            return nil
        }
        return page
    }
    
}
