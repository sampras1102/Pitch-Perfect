//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Chris Supranowitz on 4/1/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var stopPlaying: UIButton!
    var avPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var receivedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopPlaying.hidden = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        var audioPath = receivedAudio.filePathUrl
        avPlayer = AVAudioPlayer(contentsOfURL: audioPath, error: nil)
        avPlayer.enableRate=true
        avPlayer.delegate = self
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
        avPlayer.stop()
        stopPlaying.hidden = true
    }
    
    func playAudio(rate: Float)
    {
        stopPlaying.hidden = false
        avPlayer.stop()
        avPlayer.currentTime = 0
        avPlayer.rate = rate
        avPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        println("audio finished playing")
        stopPlaying.hidden = true
    }
    
    func playPitchShiftedAudio(shift: Float)
    {
        avPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = shift
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
