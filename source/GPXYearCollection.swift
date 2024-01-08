//
//  GPXYearCollection.swift
//  GPXAnalyzer
//
//  Created by Pedro Fernandes on 2024-01-08.
//

import Foundation

class GPXYearCollection {
    
    var year : Int

    var activityType : String

    var gpxFiles:[GPX]?

    init(year: Int, activityType: String) {
        self.year = year
        self.activityType = activityType
        gpxFiles = [GPX]()
    }
    
    func calculateAccumulated() {

        var accumulatedDistance = 0.0

        // go through all the gpx files and keep adding the total distance
        for gpx in gpxFiles! {
            accumulatedDistance += gpx.totalDistance!
            gpx.accumulatedDistance = accumulatedDistance
            gpx.updateSummary()
        }
    }
}
