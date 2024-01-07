//
//  ViewController.swift
//  GPXAnalyzer
//
//  Created by Pedro Fernandes on 2023-12-29.
//

import UIKit
import UniformTypeIdentifiers

class ViewController: UIViewController, UIDocumentPickerDelegate {

    var progressBar : UIProgressView?
    var totalGPXFiles:Double = 0
    var arrayOFGPXFiles:[GPX]?
    
    //-//////////////////////////////////////////////////
    //
    // _viewDidLoad_
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.black
        
        arrayOFGPXFiles = [GPX]()
        
        let button = UIButton(type: .system) // or .custom
        button.setTitle("Open GPX Data Folder", for: .normal)
        
        // Add target action for the button
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // Layout the button
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50) // Change frame as needed
        
        progressBar = UIProgressView(progressViewStyle: .default)
        progressBar?.frame = CGRect(x: 20, y: 200, width: 280, height: 20)
        view.addSubview(progressBar!)
        progressBar?.progress = 0.0
        progressBar?.progressTintColor = UIColor.blue
        progressBar?.trackTintColor = UIColor.lightGray
        
        // Add the button to the view
        self.view.addSubview(button)
    }

    //-//////////////////////////////////////////////////
    //
    // _buttonTapped_
    //
    @objc func buttonTapped() {
        
        presentFolderPicker()
    
    }

    //-//////////////////////////////////////////////////
    //
    // _presentFolderPicker_
    //
    func presentFolderPicker() {

        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.folder], asCopy: false)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)

    }
    
    
    //-//////////////////////////////////////////////////
    //
    // _documentPicker_
    //
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
     
        guard let folderURL = urls.first else { return }
         
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
                 
                 // print the sorted arrayOFGPXFiles summary field

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
            
        DispatchQueue.main.async {

            self.progressBar?.setProgress((Float) (percentageComplete/100), animated: true)
        }
            
        
    }
    
}

