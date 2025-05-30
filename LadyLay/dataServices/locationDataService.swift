//
//  locationDataService.swift
//  LadyLay
//
//  Created by Ebrar Gül on 18.03.2025.
//

import Foundation
import MapKit

class LocationDataService  {
    
    static let locatons: [Location] = [
        Location(
            name: "Anıtkabir",
            cityName: "Ankara",
            coordinates:     CLLocationCoordinate2D(latitude: 39.9233, longitude: 32.8762),
            description: "Atam sen kalk ben yatam",
            imageNames: ["anıtkabir1", "anıtkabir2", "anıtkabir3"],
            link:   "https://tr.wikipedia.org/wiki/Anıtkabir"
        )
        ]
}
