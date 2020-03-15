//
//  JiveTalkQuizAudioPlayer.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/03/08.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import AVFoundation

class JiveTalkQuizAudioPlayer {
  static let shared = JiveTalkQuizAudioPlayer()
  
  private var backgroundPlayer: AVAudioPlayer?
  private var player: AVAudioPlayer?
  private var isMute: Bool = false
  
  func mute(_ isMute: Bool) {
    activeAudio(isMute)
    self.isMute = isMute
  }
  
  func activeAudio(_ isMute: Bool) {
    do {
      if isMute {
        backgroundPlayer?.stop()
        player?.stop()
      } else {
        backgroundPlayer?.play()
        player?.play()
      }
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(!isMute)
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  func playBackgroundSound() {
    guard isMute == false,
      let url = Bundle.main.url(forResource: "bg",
                                withExtension: "wav") else {
                                  return
    }
    
    do {
      backgroundPlayer = try AVAudioPlayer(contentsOf: url,
                                           fileTypeHint: AVFileType.mp3.rawValue)
      guard let player = backgroundPlayer else { return }
      
      player.numberOfLoops = -1
      
      player.play()
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  func playSound(effect: JiveTalkSoundEffect) {
    guard isMute == false,
      let url = Bundle.main.url(forResource: effect.rawValue,
                                withExtension: "wav") else {
                                  return
    }
    
    do {
      player = try AVAudioPlayer(contentsOf: url,
                                 fileTypeHint: AVFileType.mp3.rawValue)
      guard let player = player else { return }
      
      player.play()
    } catch let error {
      print(error.localizedDescription)
    }
  }
}

enum JiveTalkSoundEffect: String {
  case bg, start, correct, incorrect, empty
}
