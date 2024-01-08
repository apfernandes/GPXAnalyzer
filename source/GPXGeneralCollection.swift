//
//  GPXCollection.swift
//  GPXAnalyzer
//
//  Created by Pedro Fernandes on 2024-01-08.
//

import Foundation

class GPXGeneralCollection {
    
    var delegate : GPXCollectionDelegate

    var gpxCollections = Set<String>()

    var arrayOFGPXFiles:[GPX]?
    var totalGPXFiles:Double = 0
    
    init(delegate: GPXCollectionDelegate) {
        self.delegate = delegate
    }
    
    //-////////////////////////////////////////////////////////////////////////
    //
    // _loadFilesFromFolder_
    //
    func loadFilesFromFolder(folderURL: URL) {
        
        arrayOFGPXFiles = [GPX]()
        
         do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)

             for fileURL in fileURLs {
                 if fileURL.pathExtension == "gpx" {
                     totalGPXFiles += 1
                 }
             }

             DispatchQueue.global(qos: .userInitiated).async { [unowned self] in

                 self.processAllFiles(fileURLs: fileURLs)

                 self.arrayOFGPXFiles?.sort(by: { $0.sortField! < $1.sortField! })
                 self.organizeGPXFiles()
                 
                 // print the sorted arrayOFGPXFiles summary field

                print ("Activity Type\tDate\tYear\tDay of The Year\tAccumulated Distance in km\tTotal Distance in km\tTotal time in seconds")
                for gpx in self.arrayOFGPXFiles! {
                    print ("\(gpx.summaryString!)")
                }
                 
             }

         } catch {
             print("Error accessing folder contents: \(error)")
         }

    }

    //-////////////////////////////////////////////////////////////////////////
    //
    // _processAllFiles_
    //
    func processAllFiles(fileURLs:[URL]) {

        print ("Processing...")
        var totalGPXFilesProcessed:Double = 0
        
        for fileURL in fileURLs {
            
            if fileURL.pathExtension == "gpx" {
        
                totalGPXFilesProcessed += 1
                
                let percentageComplete = totalGPXFilesProcessed / totalGPXFiles * 100.0
                
                processGPSFile(fileURL: fileURL, percentageComplete : percentageComplete)
                   
            }
            
        }
        
    }
    
    //-////////////////////////////////////////////////////////////////////////
    //
    // _processGPSFile_
    //
    private func processGPSFile(fileURL: URL, percentageComplete: Double)  {
        
          
        let gpxRoute = GPX(fileName: fileURL, percentageComplete : percentageComplete)
            
        arrayOFGPXFiles?.append(gpxRoute)
            
        delegate.updateProgressBar(progress: (Float) ((percentageComplete/100.0)))
    }

    
    //-////////////////////////////////////////////////////////////////////////
    //
    // _organizeGPXFiles_
    //
    func organizeGPXFiles() {

      // go through all the GPX files and get the activity type to add them to the unique set
        for gpx in arrayOFGPXFiles! {
            gpxCollections.insert(gpx.activityType!)
        }  
        
        // go through all the gopxCollections and create a new array of GPX files for each activity type
        for activityType in gpxCollections {
            
            let gpxSpecificCollecion = GPXSpecificCollection(activityType: activityType)
            
            var gpxArray = [GPX]()
            
            for gpx in arrayOFGPXFiles! {

                if gpx.activityType == activityType {
                    gpxArray.append(gpx)
                }
            }

            gpxSpecificCollecion.gpxFiles = gpxArray
            gpxSpecificCollecion.sortByYear()

            print ("Created collection for \(activityType) with \(gpxArray.count) files")            
        }

    }
}

// protocol update progress bar
protocol GPXCollectionDelegate {
    func updateProgressBar(progress: Float)
}
