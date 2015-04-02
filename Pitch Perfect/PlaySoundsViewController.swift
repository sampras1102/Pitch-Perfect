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
    
    var audioPlayer:AVAudioPlayer! //audio player for slow and fast
    var audioEngine:AVAudioEngine! //audio engine used for chipmunk and darth vader
    var audioFile:AVAudioFile! //audio file object used by audio engine
    var receivedAudio:RecordedAudio! //model class that stores the audio file path and title
    
    override func viewDidLoad() {
        super.viewDidLoad() // call base implementation first

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        var audioPath = receivedAudio.filePathUrl
        audioPlayer = AVAudioPlayer(contentsOfURL: audioPath, error: nil)
        audioPlayer.enableRate=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playPitchShiftedAudio(1000)
    }

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playPitchShiftedAudio(-1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudioInternal()
    }
    
    func stopAudioInternal(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudio(rate: Float)
    {
        stopAudioInternal()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playPitchShiftedAudio(pitch: Float)
    {
        stopAudioInternal()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
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
