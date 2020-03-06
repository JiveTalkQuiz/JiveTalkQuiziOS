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
  
  struct State {
    var number: Int
    var quiz: QuizElement?
    var localStorage: LocalStorage
    var isSolved: Bool = false
  }
  
  let initialState: State
  
  init(localStorage: LocalStorage,
       number: Int) {
    initialState = State(number: number,
                         quiz: localStorage.storageQuizList[number],
                         localStorage: localStorage)
  }
}
