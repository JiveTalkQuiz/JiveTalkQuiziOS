//
//  QuizListViewReactor.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/02.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import ReactorKit

class QuizListViewReactor: Reactor {
  
  enum Action {
    case heart
    case header
  }
  
  enum Mutation {
    case setHeart(Int)
  }
  
  struct State {
    var heart: Int
    var level: Int
  }
  
  let initialState: State
  
  init(heart point: Int) {
    initialState = State(heart: 15, level: 1)
  }
}
