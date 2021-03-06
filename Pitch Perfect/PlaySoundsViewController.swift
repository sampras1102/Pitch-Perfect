//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Chris Supranowitz on 4/1/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    //TODO: Investigate the completionHandler being called too soon.  Apparently it really is just buggy: http://discussions.udacity.com/t/avaudioplayernode-schedulefile-with-a-completionhandler/12872/2?u=chris_341164
    //    A better way to deal with this would be to just start a timer and check to see if the audio engine is playing
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var receivedAudio:RecordedAudio! //model class that stores the audio file path and title
    
    override func viewDidLoad() {
        super.viewDidLoad() // call base implementation first

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        var audioPath = receivedAudio.filePathUrl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // set up observer for "applicationWillEnterForeground"
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationWillEnterForeground:",
            name: UIApplicationWillEnterForegroundNotification,
            object: app)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if (receivedAudio != nil && receivedAudio.filePathUrl != nil) {
            //stop playing audio and delete the file
            stopAudioInternal()
            //delete old audio file
            println("deleting \(receivedAudio.filePathUrl)")
            NSFileManager.defaultManager().removeItemAtURL(receivedAudio.filePathUrl, error: nil)
        }
    }
    
    func applicationWillEnterForeground(notification: NSNotification){
        // called when app resumes
        println("app is now in foreground")
        if !(receivedAudio == nil || receivedAudio.filePathUrl == nil){
            var strPath = receivedAudio.filePathUrl.path
            var fileDoesExist = NSFileManager.defaultManager().fileExistsAtPath(strPath!)
            if (!fileDoesExist) {
                //pop to root since file is no longer available
                println("popping to root since file is not available")
                stopAudioInternal()
                self.navigationController?.popViewControllerAnimated(false)
            }
        }
    }
    
    func playSoundWithEffect(effect: AVAudioNode) {
        // make sure that audio is stopped before playing new audio
        stopAudioInternal()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        let session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil) // set category based on discussion in http://discussions.udacity.com/t/low-volume-on-device/13772
        session.setActive(true, error: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            println("audio playback complete")
            //this does not reliably work.  Audio is still playing when this is called
        })
        audioEngine.startAndReturnError(nil)
        
        println("playing audio file \(receivedAudio.title)")
        audioPlayerNode.play()
    }
    
    func playRatePitchShiftedAudio(pitch: Float, rate: Float) {
        var pitchRateEffect = AVAudioUnitTimePitch()
        pitchRateEffect.rate = rate
        pitchRateEffect.pitch = pitch
        playSoundWithEffect(pitchRateEffect)
    }
    
    func playPitchShiftedAudio(pitch: Float){
        playRatePitchShiftedAudio(pitch, rate: 1)
    }
    
    func playSpeedAdjustedAudio(rate: Float){
        playRatePitchShiftedAudio(0, rate: rate)
    }
    
    func playDistortedAudioInternal(#preGain: Float, wetDryMix: Float) {
        var distortionEffect = AVAudioUnitDistortion()
        distortionEffect.preGain = preGain
        distortionEffect.wetDryMix = wetDryMix
        playSoundWithEffect(distortionEffect)
    }
    
    func playReverbAudioInternal(#wetDryMix: Float) {
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = wetDryMix
        playSoundWithEffect(reverbEffect)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playSpeedAdjustedAudio(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playSpeedAdjustedAudio(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playPitchShiftedAudio(1000)
    }

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playPitchShiftedAudio(-1000)
    }
    
    @IBAction func playDistortedAudio(sender: UIButton) {
        playDistortedAudioInternal(preGain: 10, wetDryMix: 50)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playReverbAudioInternal(wetDryMix: 50)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudioInternal()
    }
    
    func stopAudioInternal() {
        if(audioEngine != nil){
            audioEngine.stop()
            audioEngine.reset()
            let session = AVAudioSession.sharedInstance()
            session.setActive(false, error: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
