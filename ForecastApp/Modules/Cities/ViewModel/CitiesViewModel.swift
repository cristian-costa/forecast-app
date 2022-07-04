//
//  CitiesViewModel.swift
//  ForecastApp
//
//  Created by Cristian Costa on 03/07/2022.
//

import UIKit
import CoreData

protocol CitiesViewModelDelegate: AnyObject {
    func passCity(city: LocationModelPermanent)
}

struct CitiesViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cityArrayDB: [LocationModelPermanent] = []
    
    mutating func loadLocations() -> [LocationModelPermanent] {
        let request: NSFetchRequest<LocationModelPermanent> = LocationModelPermanent.fetchRequest()
        do {
            cityArrayDB = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        return cityArrayDB
    }
    
    func saveLocation() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func cityNames() -> [String] {
        var cityArray: [String] = []
        for i in 0...cityArrayDB.count-1 {
            cityArray.append(cityArrayDB[i].place!)
        }
        return cityArray
    }
    
    func countCities() -> Int {
        return cityArrayDB.count
    }
    
    mutating func appendCity(city: LocationModelPermanent) {
        cityArrayDB.append(city)
    }
}
