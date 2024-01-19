//
//  ViewController.swift
//  GPXAnalyzer
//
//  Created by Pedro Fernandes on 2023-12-29.
//

import UIKit
import WebKit
import UniformTypeIdentifiers

class ViewController: UIViewController, UIDocumentPickerDelegate, GPXCollectionDelegate  {
    
    var button : UIButton?
    var progressBar : UIProgressView?
    var gpxCollection : GPXGeneralCollection?
    
    var screenWidth : Double?
    var screenHeight : Double?
    var scaleFactor : Double?
    
    var vWidth : Double?
    var vHeight : Double?
    
    var webView: WKWebView!

    
    //-//////////////////////////////////////////////////
    //
    // _viewDidLoad_
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //-////////////////////////////////////////
        //
        // data setup
        //
                
        gpxCollection = GPXGeneralCollection(delegate: self)
        
        //-////////////////////////////////////////
        //
        // Build UI
        //
        checkDevice()

        view.backgroundColor = UIColor.black

        vWidth = view.frame.size.width
        vHeight = view.frame.size.height

        // background image
        let backgroundImage = UIImage(named: "gpxAnalyze")
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = backgroundImage
        backgroundImageView.alpha = 0.2
        backgroundImageView.contentMode = .scaleAspectFill

        view.addSubview(backgroundImageView)

        //view.sendSubviewToBack(backgroundImageView)
        
        //
        // open folder button
        //
        button = UIButton(type: .system) // or .custom
        button!.setTitle("Open GPX Data Folder", for: .normal)
        button!.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let buttonWidth = vWidth! / 2.0
        let buttonHeight = 40.0
        button!.backgroundColor = UIColor.blue
        button!.tintColor = UIColor.white
        button!.titleLabel?.font = UIFont.systemFont(ofSize: 20) // Change 20 to your desired font size

        button!.frame = CGRect(x: vWidth! / 2.0 - buttonWidth / 2.0,
                              y: vHeight! / 2.0 - buttonHeight / 2.0,
                              width: buttonWidth,
                              height: buttonHeight)

        //
        // Progress bar
        //
        progressBar = UIProgressView(progressViewStyle: .default)
        
        let margin = 20.0
        
        progressBar?.frame = CGRect(x: margin, y: vHeight! / 2.0 + buttonHeight , width: vWidth! - margin * 2.0, height: 20)
        progressBar?.progress = 0.0
        progressBar?.progressTintColor = UIColor.blue
        progressBar?.trackTintColor = UIColor.lightGray
        
        progressBar?.isHidden = true
        
        let tempFrame = CGRect(x: margin, y: margin, width: vWidth! - margin * 2.0, height: vHeight! - margin * 2.0)
        webView = WKWebView(frame: tempFrame)
        webView.backgroundColor = UIColor.black
        webView.isOpaque = false
        webView.alpha = 0.6
        webView.isHidden = true

        self.view.addSubview(webView)
        view.addSubview(progressBar!)
        self.view.addSubview(button!)

        
    }
    
    //-//////////////////////////////////////////////////
    //
    // _checkDevice_
    //
    func checkDevice() {
        
        screenWidth = (Double) (UIScreen.main.bounds.width)
        screenHeight = (Double) (UIScreen.main.bounds.height)
        scaleFactor = (Double) (UIScreen.main.scale)

    }

    //-//////////////////////////////////////////////////
    //
    // _buttonTapped_
    //
    @objc func buttonTapped() {
        
        button!.setTitle("Loading GPX files, please wait...", for: .disabled)
        // disable button
        button!.isEnabled = false

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

        progressBar?.isHidden = false
        
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

    //-//////////////////////////////////////////////////
    //
    // _finishedProcessingGPXFiles_
    //
    func finishedProcessingGPXFiles() {
        
        DispatchQueue.main.async {
            
            self.progressBar?.isHidden = true
            self.button?.isHidden = true
            self.webView.isHidden = false
        
            //let htmlString = "<pre>Hello GPX\tTesting\tXLS</pre>"
            self.webView.loadHTMLString(self.gpxCollection!.HTMLText!, baseURL: nil)
        }

    }
}

