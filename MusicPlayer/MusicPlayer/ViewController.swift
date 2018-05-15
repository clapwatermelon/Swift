//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 박수현 on 11/05/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    // MARK: - Properties
    var player: AVAudioPlayer!
    var timer: Timer!
    
    // MARK: IBOutlets
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializePlayer()
    }
    
    // MARK: - Methods
    // MARK: Custom Method
    func initializePlayer() {
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else {
            print("Could not import sound file assets")
            return
        }
        
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("Player initialization failed")
            print("code : \(error.code), message : \(error.localizedDescription)")
        }
        // AVAudioPlayer 객체의 duration 프로퍼티를 가져와 음원 재생의 진행 상태를 보여주는 UISlider의 최대 값에 할당
        self.progressSlider.maximumValue = Float(self.player.duration)
        // 최소 값 0 할당
        self.progressSlider.minimumValue = 0
        // 시간 초기화
        self.progressSlider.value = Float(self.player.currentTime)
    }
    
    func updateTimeLabelText(time: TimeInterval) {
        let minute: Int = Int(time / 60)
        // truncatingRemainder 정수형이 아닌 수를 % 모듈러스 연산처럼 사용하는 것
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        self.timeLabel.text = timeText
    }
    
    func makeAndFireTimer() {
        // unowned 값이 있음을 가정하고 사용, 밀리세컨드 단위
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            if self.progressSlider.isTracking { return }
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        // fire를 통해 timer 시작, invalidate 종료
        self.timer.fire()
    }
    
    func invalidateTimer() {
        // Stops the timer from ever firing again and requests its removal from its run loop.
        self.timer.invalidate()
        self.timer = nil
    }
  

    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        //버튼이 눌렸을 때 직접 값을 셋팅, 초기값은 항상 false
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
            self.makeAndFireTimer()
        } else {
            self.player?.pause()
            self.invalidateTimer()
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        // 슬라이더를 움직이는 동안은 재생되는 구간이 바뀌지 않고 슬라이더의 움직임을 멈추었을 때 비로소 해당 위치를 재생하게하므로 움직이는 동안 음원이 끊기는 현상을 막기 위함
        if sender.isTracking { return }
        // 슬라이더의 움직임을 멈추었을 때 currentTime의 값을 슬라이더 값에 맞추어 할당해주므로 원하는 구간으로의 이동이 가능
        self.player.currentTime = TimeInterval(sender.value)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류발생")
            return
        }
        
        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //음악 재생이 끝났을 때 버튼이미지, 슬라이더, 시간을 다시 되돌림
       self.playPauseButton.isSelected = false
        self.progressSlider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
}

