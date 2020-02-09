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
  }
  
  let initialState: State
  
  init(number: Int) {
    self.initialState = State(number: number)
    _ = self.state
  }
}
