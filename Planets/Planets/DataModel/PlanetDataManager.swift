//
//  PlanetDataManager.swift
//  Planets
//
//  Created by Pradeep K. Deshmukh on 05/01/19.
//  Copyright © 2019 Pradeep K. Deshmukh. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Core Data manager
class CoredataManager {
    
    var manageObjectContext: NSManagedObjectContext?
    init() {
        self.manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // Save records to core data
    func saveRecords(planets: [Planet], completion: () -> Void) {
        guard let moc: NSManagedObjectContext = self.manageObjectContext else {
            return
        }
        
        for planetObj in planets {
            
            let entity = NSEntityDescription.insertNewObject(forEntityName: "PlanetMO", into: moc)
            entity.setValue(planetObj.name, forKey: "name")
            entity.setValue(planetObj.rotation_period, forKey: "rotation_period")
            entity.setValue(planetObj.orbital_period, forKey: "orbital_period")
            entity.setValue(planetObj.diameter, forKey: "diameter")
            entity.setValue(planetObj.climate, forKey: "climate")
            entity.setValue(planetObj.gravity, forKey: "gravity")
            entity.setValue(planetObj.terrain, forKey: "terrain")
            entity.setValue(planetObj.surface_water, forKey: "surface_water")
            entity.setValue(planetObj.population, forKey: "population")
            entity.setValue(planetObj.created, forKey: "created")
            entity.setValue(planetObj.edited, forKey: "edited")
            entity.setValue(planetObj.url, forKey: "url")
            
            let filmArr = NSSet()
            for film in planetObj.films {
                let filmEntity = NSEntityDescription.insertNewObject(forEntityName: "FilmMO", into: moc)
                filmEntity.setValue(film, forKey: "url")
                filmArr.adding(filmEntity)
            }
        
            entity.setValue(filmArr, forKey: "filmsRelationship")
            
            let residentArr = NSSet()
            for resident in planetObj.residents {
                let residentEntity = NSEntityDescription.insertNewObject(forEntityName: "ResidentMO", into: moc)
                residentEntity.setValue(resident, forKey: "url")
                residentArr.adding(residentEntity)
            }
            
            entity.setValue(residentArr, forKey: "residentRelationship")
        }
        
        do {
            try moc.save()
        } catch {
            print("Could not save data: \(error.localizedDescription)")
        }
        
    }
    
    // Delete records from core data
    func deleteRecords() {
        guard let moc: NSManagedObjectContext = self.manageObjectContext else {
            return
        }
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanetMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try moc.execute(deleteRequest)
            try moc.save()
        } catch {
            print ("There was an error")
        }
    }
    
    // Fetech records from coredata
    func fetchRecords(completion: (_ planets: [Planet]) -> Void) {
        
        guard let moc: NSManagedObjectContext = self.manageObjectContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanetMO")
        do {
            let result = try moc.fetch(fetchRequest) as! [NSManagedObject]
            let planets: [PlanetMO] = result as! [PlanetMO]
            var planetModels: [Planet] = []
            
            for planetObj in planets {
                
                let name = planetObj.name ?? ""
                let rotation_period = planetObj.rotation_period  ?? ""
                let orbital_period = planetObj.orbital_period ?? ""
                let diameter = planetObj.diameter ?? ""
                let climate = planetObj.climate ?? ""
                let gravity = planetObj.gravity ?? ""
                let terrain = planetObj.terrain ?? ""
                let surface_water = planetObj.surface_water ?? ""
                let population = planetObj.population ?? ""
                
                let residentRelationship: [ResidentMO] = Array(planetObj.residentRelationship ?? []) as! [ResidentMO]
                let filmsRelationship: [FilmMO] = Array(planetObj.filmsRelationship ?? []) as! [FilmMO]
                
                let created = planetObj.created ?? ""
                let edited = planetObj.edited ?? ""
                let url = planetObj.url ?? ""
                
                var residents: [String] = []
                residents = residentRelationship.map { $0.url ?? "" }
                
                var films: [String] = []
                films = filmsRelationship.map { $0.url ?? "" }
                
                let planet = Planet(name: name, rotation_period: rotation_period, orbital_period: orbital_period, diameter: diameter, climate: climate, gravity: gravity, terrain: terrain, surface_water: surface_water, population: population, created: created, edited: edited, url: url, residents: residents, films: films)
                planetModels.append(planet)
            }
            
            completion(planetModels)
            
        } catch {
            print("Reading records error")
        }
    }
}
