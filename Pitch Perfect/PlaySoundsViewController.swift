//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Shai Bruhis on 11/7/15.
//  Copyright © 2015 Shai Bruhis. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true

    }
    

    func playSound(rate: Float) {
        stopSound()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopSound()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    @IBAction func slowButtonClicked(sender: UIButton) {
        playSound(0.5)
    }
    
    @IBAction func fastButtonClicked(sender: UIButton) {
        playSound(2.0)
    }
    
    @IBAction func chipmunkButtonClicked(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func darthVaderButtonClicked(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func stopSound() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func stopSound(sender: UIButton) {
        stopSound()
    }
}
