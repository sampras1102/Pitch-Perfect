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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopPlaying.hidden = true
        if var audioPath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
        {
            var pathAsUrl = NSURL(fileURLWithPath: audioPath)
            avPlayer = AVAudioPlayer(contentsOfURL: pathAsUrl, error: nil)
            avPlayer.enableRate=true
            avPlayer.delegate = self
        }
        else
        {
            println("path is empty")
        }
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
