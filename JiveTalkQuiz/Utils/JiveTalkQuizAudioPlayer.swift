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
  private var volume: Float = 1.0
  
  init() {
    
  }
  
  func playBackgroundSound() {
    guard let url = Bundle.main.url(forResource: "bg",
                                    withExtension: "wav") else {
      return
    }
    
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

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
    guard let url = Bundle.main.url(forResource: effect.rawValue,
                                    withExtension: "wav") else {
                                      return
    }
    
    do {
      player = try AVAudioPlayer(contentsOf: url,
                                 fileTypeHint: AVFileType.mp3.rawValue)
      guard let player = player else { return }
      player.volume = volume
      
      player.play()
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  func mute(_ isMute: Bool) {
    if isMute {
      volume = 0.0
      backgroundPlayer?.setVolume(0.0, fadeDuration: .zero)
    } else {
      volume = 1.0
      backgroundPlayer?.setVolume(1.0, fadeDuration: .zero)
    }
  }
}

enum JiveTalkSoundEffect: String {
  case bg, start, correct, incorrect, empty
}
