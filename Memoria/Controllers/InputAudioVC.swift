//
//  InputAudioVC.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 06/10/20.
//

import UIKit
import AVFoundation
import CloudKit

class InputAudioVC: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var audioPlayView: AudioPlayerView!
    @IBOutlet weak var contentBackground: UIView!
    @IBOutlet weak var dismissView: UIView!
    
    var soundRecorder = AVAudioRecorder()
    var isRecording: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRecorder()
        
        self.contentBackground.layer.cornerRadius = 20
        self.audioPlayView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAudioInputView))
        self.dismissView.addGestureRecognizer(tap)
    }
    
    @objc func dismissAudioInputView() {
        self.dismiss(animated: true)
    }
    
    ///Initial configuration for the recorder
    func setupRecorder() {
        //Some default audio configurations
        let recordSettings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                              AVSampleRateKey: 12000,
                              AVNumberOfChannelsKey: 1,
                              AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

        do {
            self.soundRecorder =  try AVAudioRecorder(url: self.getFileURL(), settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print("Error: Problemas para preparar a gravação")
        }

    }
    
    ///Get documents diretory - permission to Microfone usage add in info.plist
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording.m4a")
        return audioFilename
    }
    
    ///Change states when recording or stop recording
    @IBAction func record(_ sender: Any) {
        if !self.isRecording {
            soundRecorder.record()
            guard let stopImage = UIImage(named: "stopRecording") else {return}
            self.recordButton.setBackgroundImage(stopImage, for: UIControl.State.normal)
            self.isRecording = true
        } else {
            soundRecorder.stop()
            guard let startImage = UIImage(named: "startRecording") else {return}
            self.recordButton.setBackgroundImage(startImage, for: UIControl.State.normal)
            self.isRecording = false
            self.audioPlayView.isHidden = false
        }
    }
    
    ///Enable play when finish recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard let audioCKAsset = try? Data(contentsOf: getFileURL()) else { return }

        //let audioCKAsset = CKAsset(fileURL: getFileURL())
        
        let record = CKRecord(recordType: "Detail")

        record.setValue(audioCKAsset, forKey: "audio")

        CKContainer.default().privateCloudDatabase.save(record) { (savedRecord, error) in

                if error == nil {
                    print("Record Saved")
                    print(savedRecord?.object(forKey: "audio") ?? "Nil")
                } else {
                    print("Record Not Saved")
                    print(error ?? "Nil")
                    
                }
        }
    }
    
}
