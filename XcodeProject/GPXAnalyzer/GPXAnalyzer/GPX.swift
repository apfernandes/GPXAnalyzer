import Foundation
import CoreLocation

class GPX: NSObject, XMLParserDelegate {
    
    var sortField : String?
    var summaryString : String?
    
    var fileName: URL
    var year: Int?
    var month: Int?
    var day: Int?
    var dayNumberOfYear: Int?
    var trackName: String? // Used for the name field in trk
    var percentageComlete: Double = 0
    
    var activityType: String? // You need to define how to extract this from your GPX
    var totalTime: TimeInterval?
    var totalDistance: Double?
    var accumulatedDistance: Double?

    private var trackPoints: [CLLocation] = []
    private var trackPointTimestamps: [Date] = []
    private var currentElement = ""
    private var currentPoint: CLLocation?
    private var currentPointTime: Date?
    
    let dateFormater = ISO8601DateFormatter()
    let calendar = Calendar.current
    
    //-////////////////////////////////////////////////////////////////////////
    //
    // _init_
    //
    init(fileName: URL, percentageComplete : Double) {
        self.fileName = fileName
        super.init()
        self.percentageComlete = percentageComplete
        parseGPXFile()
    }


    //-////////////////////////////////////////////////////////////////////////
    //
    // _parseGPXFile_
    //
    private func parseGPXFile() {
        
        let parser = XMLParser(contentsOf: fileName)
        
        parser?.delegate = self
        parser?.parse()
        
        accumulatedDistance = 0
        calculateTotalDistanceAndTime()
        updateSummary()
    }
    
    //-////////////////////////////////////////////////////////////////////////
    //
    // _parser_
    //
    // XML Parser Delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
        
        if elementName == "trkpt", let lat = attributeDict["lat"], let lon = attributeDict["lon"], let latitude = Double(lat), let longitude = Double(lon) {
            currentPoint = CLLocation(latitude: latitude, longitude: longitude)
        }
        
    }
    
    
    //-////////////////////////////////////////////////////////////////////////
    //
    // _parser_
    //
    // XML Parser Delegate methods
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedString.isEmpty {
            switch currentElement {
            
            case "time":
                handleTimeElement(trimmedString)
            
            case "type":
                if activityType == nil {
                    activityType = trimmedString
                }
            case "name":
                if trackName == nil {
                    trackName = trimmedString
               }
             
            default:
                break
            }
        }
    }
     
    //-////////////////////////////////////////////////////////////////////////
    //
    // _handleTimeElement_
    //
    private func handleTimeElement(_ string: String) {
        
        if (currentPoint == nil) {
            return
        }
        
        let date = dateFormater.date(from: string)!

            trackPoints.append(currentPoint!)
            trackPointTimestamps.append(date)
            currentPointTime = nil
            

            if year == nil {
                year = calendar.component(.year, from: date)
                month = calendar.component(.month, from: date)
                day = calendar.component(.day, from: date)
                dayNumberOfYear = calendar.ordinality(of: .day, in: .year, for: date)
            }
             
        
    }
    
    //-////////////////////////////////////////////////////////////////////////
    //
    // _printSummary_
    //
    func updateSummary() {
        
        let yearStr = year.map(String.init) ?? "N/A"
        let monthStr = month! < 10 ? String(format: "0%d", month!) : String(month!)
        
        let dayStr = day! < 10 ? String(format: "0%d", day!) : String(day!)
        
        let dayOfYearStr = dayNumberOfYear.map(String.init) ?? "N/A"
        let activityTypeStr = activityType ?? "N/A"
        let totalTimeStr = totalTime.map { "\($0)" } ?? "N/A"
        let totalDistanceStr = totalDistance.map { "\($0)" } ?? "N/A"
        let accumulatedDistanceStr = accumulatedDistance.map { "\($0)" } ?? "N/A"
        
        sortField = "\(activityTypeStr)\t\(yearStr)-\(monthStr)-\(dayStr)"

        summaryString = "\(activityTypeStr)\t\(yearStr)-\(monthStr)-\(dayStr)\t\(year!)\t\(dayOfYearStr)\t\(accumulatedDistanceStr)\t\(totalDistanceStr)\t\(totalTimeStr)"
        
        //print(summaryString!)
    }
    
    
    //-////////////////////////////////////////////////////////////////////////
    //
    // _calculateTotalDistanceAndTime_
    //
    private func calculateTotalDistanceAndTime() {
        
        guard !trackPoints.isEmpty else { return }
        
        totalDistance = 0.0
        for i in 1..<trackPoints.count {
            totalDistance! += trackPoints[i].distance(from: trackPoints[i - 1])
        }
        
        // Convert distance to kilometers
        totalDistance = totalDistance! / 1000
        
        
        if let firstTime = trackPointTimestamps.first, let lastTime = trackPointTimestamps.last {
            totalTime = lastTime.timeIntervalSince(firstTime)
        }
    }
}
