//
//  LocalStorage.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/15.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class LocalStorage {
  
  enum PointAction: Int {
    case wrong, hint, ad, level, adError
    
    var point: Int {
      switch self {
      case .wrong: return -3
      case .hint: return -2
      case .ad: return 15
      case .level: return 5
      case .adError: return 2
      }
    }
  }
  
  var quizList: StorageQuizList { return Defaults.quizList }
  var storageQuizList: [QuizElement] { return Defaults.storageQuizList }
  var heartPoint: Int { return Defaults.heartPoint }
  var level: JiveTalkQuizLevel { return Defaults.level }
  var solvedNumber: Int { return Defaults.solvedNumber }
  var isMute: Bool { return Defaults.isMute }
  
  init() {
    Defaults[\.level] = JiveTalkQuizLevel.get(solved: quizList
      .filter({ $0.isSolved == true })
      .count)
  }
  
  func initQuiz(list: [QuizElement]) {
    Defaults[\.storageQuizList] = list
    
    if Defaults.quizList.isEmpty {
      Defaults[\.quizList] = StorageQuizList(repeating: StorageQuiz(),
                                             count: list.count)
      for (index, quiz) in list.enumerated() {
        for (selIndex, sel) in quiz.selection.enumerated() {
          Defaults.quizList[index].isDimmed.append(false)
          if sel.correct {
            Defaults.quizList[index].correctNumber = selIndex
          }
        }
      }
    } else {
      var copiedQuizList = StorageQuizList(repeating: StorageQuiz(),
                                           count: list.count)
      
      for (index, quiz) in Defaults.quizList.enumerated() {
        copiedQuizList[index] = quiz
      }
      
      Defaults.quizList = copiedQuizList
    }
  }
  
  func solve(quiz index: Int?) {
    guard let index = index else { return }
    Defaults.quizList[index].isSolved = true
  }
  
  func dimmed(number: Int, example index: Int) {
    Defaults.quizList[number].isDimmed[index] = true
  }
  
  func calculate(point action: PointAction) {
    let point = action.point
    Defaults.heartPoint += point
  }
  
  func setupLevel(_ level: JiveTalkQuizLevel) {
    Defaults.level = level
  }
  
  func setupSolvedNumber(number: Int) {
    Defaults.solvedNumber = number
  }
  
  func mute() {
    Defaults.isMute = !isMute
  }
}

extension DefaultsKeys {
  var quizList: DefaultsKey<StorageQuizList> {
    return .init("quizList", defaultValue: StorageQuizList())
  }
  var heartPoint: DefaultsKey<Int> {
    return .init("heartPoint", defaultValue: 15)
  }
    var solvedNumber: DefaultsKey<Int> {
        return .init("solvedNumber", defaultValue: 0)
    }
  var storageQuizList: DefaultsKey<[QuizElement]> {
    return .init("storageQuizList", defaultValue: [QuizElement]())
  }
  var level: DefaultsKey<JiveTalkQuizLevel> {
    return .init("level", defaultValue: .아재)
  }
  var isMute: DefaultsKey<Bool> {
    return .init("isMute", defaultValue: false)
  }
}
