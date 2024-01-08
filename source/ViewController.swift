//
//  ViewController.swift
//  GPXAnalyzer
//
//  Created by Pedro Fernandes on 2023-12-29.
//

import UIKit
import UniformTypeIdentifiers

class ViewController: UIViewController, UIDocumentPickerDelegate, GPXCollectionDelegate {
    
    var progressBar : UIProgressView?

    var gpxCollection : GPXGeneralCollection?
    
    //-//////////////////////////////////////////////////
    //
    // _viewDidLoad_
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        view.backgroundColor = UIColor.black
        
        gpxCollection = GPXGeneralCollection(delegate: self)
        
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

        gpxCollection?.loadFilesFromFolder(folderURL: folderURL)
         
     }
    
    //-//////////////////////////////////////////////////
    //
    // _updateProgressBar_
    //
    func updateProgressBar(progress: Float) {
    
        DispatchQueue.main.async {

            self.progressBar?.setProgress(progress, animated: true)
        }

    }

               
}

