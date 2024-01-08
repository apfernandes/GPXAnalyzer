//
//  GPXSpecificCollection.swift
//  GPXAnalyzer
//
//  Created by Pedro Fernandes on 2024-01-08.
//

import Foundation

class GPXSpecificCollection {
    
    var years = Set<Int>()

    var yearGPXFiles : [GPXYearCollection]?

    var activityType : String
    var gpxFiles:[GPX]?
    
    init(activityType: String) {

        self.activityType = activityType
        self.gpxFiles = [GPX]()
        self.yearGPXFiles = [GPXYearCollection]()

    }
    
    func sortByYear() {
        
        // go through all the files and create a set of years
        for gpx in gpxFiles! {
            years.insert(gpx.year!)
        }

        // go through all the years and create a set of files for each year
        for year in years {

            
            var gpxFilesForYear = [GPX]()

            for gpx in gpxFiles! {
                if gpx.year == year {
                    gpxFilesForYear.append(gpx)
                }
            }

            let yearGPXFile = GPXYearCollection(year: year, activityType: activityType)
            yearGPXFile.gpxFiles = gpxFilesForYear
            
            yearGPXFiles?.append(yearGPXFile)
            
            yearGPXFile.calculateAccumulated()

            print ("Created collection for \(yearGPXFile.activityType) with \(yearGPXFile.gpxFiles!.count) files for year \(yearGPXFile.year)")
        }
    }
}
