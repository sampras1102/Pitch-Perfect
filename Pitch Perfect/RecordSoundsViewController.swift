//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Chris Supranowitz on 4/1/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class RecordSoundsViewController: UIViewController {

    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        recordButton.enabled = true
        stopButton.hidden = true
        recordingInProgress.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio")
        recordButton.enabled = false
        recordingInProgress.hidden = false
        stopButton.hidden = false
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
    }
}

