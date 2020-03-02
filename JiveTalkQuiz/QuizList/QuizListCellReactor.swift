//
//  QuizListCellReactor.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/02.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

class QuizListCellReactor: Reactor {
  typealias Action = NoAction
  
  var quiz: QuizElement?
  var localStorage: LocalStorage?
  var number: Int?
  
  struct State {
    var number: Int
    var isSolved: Bool = false
  }
  
  let initialState: State
  
  init(localStorage: LocalStorage?,
       number: Int) {
    self.localStorage = localStorage
    quiz = localStorage?.storageQuizList[number - 1]
    self.number = number
    initialState = State(number: number)
  }
}
