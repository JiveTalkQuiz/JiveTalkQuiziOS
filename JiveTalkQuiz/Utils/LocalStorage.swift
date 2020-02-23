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
    case wrong = -3, hint = -1, ad = 15, level = 5
  }
  
  var quizList: StorageQuizList { return Defaults.quizList }
  var heartPoint: Int { return Defaults.heartPoint }
  
  init() { }
  
  func initQuiz(list: [QuizElement]) {
    
    if Defaults.quizList.isEmpty {
      Defaults[\.quizList] = StorageQuizList(repeating: StorageQuiz(),
                                             count: list.count)
      for (index, quiz) in list.enumerated() {
        for _ in quiz.selection {
          Defaults.quizList[index].idDimmed.append(false)
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
    Defaults.quizList[number].idDimmed[index] = true
  }
  
  func calculate(point action: PointAction) {
    Defaults.heartPoint += action.rawValue
  }
}

extension DefaultsKeys {
  var quizList: DefaultsKey<StorageQuizList> { return .init("quizList", defaultValue: StorageQuizList()) }
  var heartPoint: DefaultsKey<Int> { return .init("heartPoint", defaultValue: 15)}
}
