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
    
    var audioEngine:AVAudioEngine! //audio engine used for chipmunk and darth vader
    var audioFile:AVAudioFile! //audio file object used by audio engine
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
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudioInternal()
    }
    
    func stopAudioInternal(){
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playPitchShiftedAudio(pitch: Float){
        playRatePitchShiftedAudio(pitch, rate: 1)
    }
    
    func playSpeedAdjustedAudio(rate: Float){
        playRatePitchShiftedAudio(0, rate: rate)
    }
    
    func playRatePitchShiftedAudio(pitch: Float, rate: Float)
    {
        stopAudioInternal()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var pitchRateEffect = AVAudioUnitTimePitch()
        pitchRateEffect.rate = rate
        pitchRateEffect.pitch = pitch
        audioEngine.attachNode(pitchRateEffect)
        
        audioEngine.connect(audioPlayerNode, to: pitchRateEffect, format: nil)
        audioEngine.connect(pitchRateEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            println("audio playback complete")
        })
        audioEngine.startAndReturnError(nil)
        
        println("playing audio file \(receivedAudio.title)")
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
