//
//  AudioPlayerCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 28/10/20.
//

import UIKit
import AVFoundation

class AudioPlayerCell: UITableViewCell, AVAudioPlayerDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var showingPlayIcon = true  // if false, then it's showing the pause icon
    var soundRecorder = AVAudioRecorder()
    var soundPlayer = AVAudioPlayer()
    var audioURL: URL? {
        didSet {
            if let audioURL: URL = self.audioURL {
                self.preparePlayer(url: audioURL)
            } else {
                // self.preparePlayer(url: self.getFileURL())
                print("Audio URL não foi populada")
            }
            self.updateTimerLabel()
        }
    }
    //private var contentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupSlider()
        self.setupTimer()
        self.setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Setups
    
    ///Style setup for slider
    func setupSlider() {
        self.slider.tintColor = .systemGray2
        
        //Set style for thumbImage
        let thumb = self.thumbImage(radius: 8)
        self.slider.setThumbImage(thumb, for: .normal)
    }
    
    ///Create image for thumb in slider to change layout style
    private func thumbImage(radius: CGFloat) -> UIImage {
        //Create thumb UIView with style attributes
        let thumbView = UIView()
        thumbView.backgroundColor = UIColor(named: "purple") ?? UIColor.purple
        thumbView.layer.borderWidth = 0.4
        thumbView.layer.borderColor = UIColor.darkGray.cgColor
        
        //Calculate size frame from radius
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        //Transform UIViem in UIImage
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    func setupTimer() {
        //Timer for updatinng the slider when audio is playing
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    func setupLayout() {
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.borderWidth = 2
        self.containerView.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    // MARK: Timer updates
    
    @objc func updateSlider() {
        slider.value = Float(soundPlayer.currentTime)
    }
    
    @objc func updateTimerLabel() {
        let currentTime = Int(self.soundPlayer.currentTime)
        let duration = Int(self.soundPlayer.duration)
        let total = duration - currentTime

        let minutes = total/60
        let seconds = total - minutes / 60

        self.timerLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        self.timerLabel.dynamicFont = Typography().caption1Regular.monospacedDigitFont
    }
    
    // MARK: Audio play methods
    
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording.m4a")
        return audioFilename
    }
    
    @IBAction func playAndPause(_ sender: Any) {
        if showingPlayIcon {
            // Change button from play to pause
            let pauseImage = UIImage(named: "pauseAudio")
            self.playButton.setBackgroundImage(pauseImage, for: .normal)
            self.showingPlayIcon = false
            // Play audio
            self.soundPlayer.play()
        } else {
            // Change button from pause to play
            let playImage =  UIImage(named: "playAudio")
            self.playButton.setBackgroundImage(playImage, for: .normal)
            self.showingPlayIcon = true
            // Stop audio
            self.soundPlayer.stop()
        }
    }
    
    ///Configuration before start recording
    func preparePlayer(url: URL) {
        do {
            // Device configuration regarding audio recording conditions
            // Should be done before play and record, to garatee it will be configured when performing those actions
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.setMode(AVAudioSession.Mode.default)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            
            try self.soundPlayer = AVAudioPlayer(contentsOf: url)
            self.soundPlayer.delegate = self
            self.soundPlayer.prepareToPlay()
            self.soundPlayer.volume = 1.0
            
            // Use bottom speaker for higher volume (overrides default upper speaker)
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
               } catch _ {
                print("Unable to use bottom speaker")
            }

            // Set slider maximum value as the duration of the audio
            self.slider.maximumValue = Float(self.soundPlayer.duration)
        } catch {
            print("Erro: Problemas para reproduzir um áudio")
        }
    }

    ///Enable record when finish playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let playImage =  UIImage(named: "playAudio")
        self.playButton.setBackgroundImage(playImage, for: .normal)
        self.showingPlayIcon = true
    }
    
}
