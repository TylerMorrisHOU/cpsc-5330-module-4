//
//  ViewController.swift
//  appDevModule4
//
//  Created by Tyler Morris on 6/16/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var app: UIView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var countdownDuration: TimeInterval = 0
    var countdown: Timer?
    var timer = Timer()
    var buttonCycle = 0
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        datePicker.datePickerMode = .countDownTimer
        button.setTitle("Start Timer", for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick), userInfo: nil, repeats:true)
    }
    
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") else {
                print("Sound file not found")
                return
            }
            
            do {
                // Prepare audio session
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                // Initialize audio player
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                
                // Play sound
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
    }
    
    func startCountdown() {
        countdown?.invalidate()
        
        countdownDuration = datePicker.countDownDuration
        countdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.countdownDuration > 0 {
                self.countdownDuration -= 1
                self.updateTimeRemaining()
            } else {
                timer.invalidate()
                //let systemSoundID: SystemSoundID = 1304
                //AudioServicesPlaySystemSound(systemSoundId)
                button.setTitle("Stop Music", for: .normal)
                buttonCycle = 1
            }
        }
    }

    @objc func tick() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        currentTime.text = formatter.string(from:Date())
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        if (hour < 12) {
            app.backgroundColor = UIColor.white
        } else {
            app.backgroundColor = UIColor.lightGray
        }
    }
    
    @objc func updateTimeRemaining() {
        let hours = Int(countdownDuration) / 3600
        let minutes = (Int(countdownDuration) % 3600) / 60
        let seconds = Int(countdownDuration) % 60
        
        timeRemaining.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    @IBAction func buttonPress(_ sender: Any) {
        if (buttonCycle == 1) {
            button.setTitle("Start Timer", for: .normal)
            buttonCycle = 0
            audioPlayer?.stop()
        } else {
            startCountdown()
        }
    }
}

