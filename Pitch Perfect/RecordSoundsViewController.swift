//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Shai Bruhis on 10/28/15.
//  Copyright © 2015 Shai Bruhis. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
//        recordButton.enabled = true
        recordingInProgress.hidden = false
        recordingInProgress.text = "tap to record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        if recordingInProgress.text! == "tap to record" {
            recordingInProgress.text = "recording...\ntap to pause recording"
            stopButton.hidden = false
            //        recordButton.enabled = false
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            print(filePath)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        else if recordingInProgress.text! == "tap to resume recording" {
            recordingInProgress.text = "recording...\ntap to pause recording"
            audioRecorder.record()
        }
        else {
            recordingInProgress.text = "tap to resume recording"
            audioRecorder.pause()
        }
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(fileUrl: recorder.url, fileTitle: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }
        else {
            print("recording failed")
            stopButton.hidden = true
//            recordButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

