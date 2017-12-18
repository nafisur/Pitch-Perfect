//
//  RecordSoundsVC.swift
//  PitchPerfect
//
//  Created by Nafisur Ahmed on 16/12/17.
//

import UIKit
import AVFoundation

class RecordSoundsVC: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordStopButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI(recording: false)
        
    }

    @IBAction func recordButtonPressed(_ sender: Any) {
        
        setupUI(recording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    @IBAction func stopRecordButtonPressed(_ sender: Any) {
        
        setupUI(recording: false)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        
        
    }
    
    func setupUI(recording : Bool) {
        
        if recording {
            
            recordingLabel.text = "Recording in Progress"
            recordButton.isEnabled = false
            recordStopButton.isEnabled = true
        }
        else {
            
            recordButton.isEnabled = true
            recordStopButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            
            performSegue(withIdentifier: "next", sender: audioRecorder.url)
        }
        else {
            
            let alert = UIAlertController(
                title: "Audio Recorder Error",
                message: "Saving your record was failed",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playSoundsVC = segue.destination as! PlaySoundVC
        let recoredAudioURL = sender as! URL
        playSoundsVC.recordedAudioURL = recoredAudioURL
    }

}
