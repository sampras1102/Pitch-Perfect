//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Chris Supranowitz on 4/1/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var microphoneSubText: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var paused: Bool! // true if audio recorder is in paused state
    var pauseImage: UIImage! // image to display when recording is paused
    var microphoneImage: UIImage! // image to display when not recording
    
    let recordingText = "recording in progress" //TODO: Put this in a resource file
    let pausedText = "paused - tap to resume" //TODO: Put this in a resource file
    let notRecordingText = "tap to record" //TODO: Put this in a resource file
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pauseImage = UIImage(named: "pause") as UIImage!
        microphoneImage = UIImage(named: "record") as UIImage!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        paused = false
        //set initial state for buttons
        setUIForRecordingState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUIForRecordingState(){
        // three possible states:
        //  - recording
        //  - paused
        //  - not recording or paused
        if (audioRecorder != nil && audioRecorder.recording == true){
            //recording
            stopButton.hidden = false
            microphoneSubText.text = recordingText
            recordButton.setImage(pauseImage, forState: .Normal)
        } else if (paused == true){
            //paused
            stopButton.hidden = false
            microphoneSubText.text = pausedText
            recordButton.setImage(microphoneImage, forState: .Normal)
        } else {
            //not recording or paused
            stopButton.hidden = true
            microphoneSubText.text = notRecordingText
            recordButton.setImage(microphoneImage, forState: .Normal)
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        if (audioRecorder != nil && audioRecorder.recording == true) {
            println("in recordAudio - pausing")
            audioRecorder.pause()
            paused = true
            setUIForRecordingState()
        } else if (paused == true) {
            println("in recordAudio - resume recording")
            audioRecorder.record()
            paused = false
            setUIForRecordingState()
        } else {
            println("in recordAudio - create new recording")
            
            // get directory to save data to
            let dirPath = NSTemporaryDirectory() as String
            
            // generate a file name using the time and date
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println("Recorded audio file path: \(filePath)")
            
            //create a new audio session
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryRecord, error: nil) //set category based on discussion in http://discussions.udacity.com/t/low-volume-on-device/13772
            
            //record the audio
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate=self
            audioRecorder.meteringEnabled = true
            audioRecorder.record()
            paused = false
            setUIForRecordingState()
        }

    }
    
    @IBAction func stopRecording(sender: UIButton) {
        println("user stopped recording")
        
        //stop recording
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // if successfully processed audio, save path and title to model and segue to PlaySoundsViewController
            var recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            //don't perform segue since we don't have a valid recording
            println("audio didn't record successfully")
        }
        //re-set UI (same behavior if recording was successful or failed)
        setUIForRecordingState()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //set up destination ViewController
        let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
        
        // pass RecordedAudio model data
        let data = sender as RecordedAudio
        playSoundsVC.receivedAudio = data
    }
}

