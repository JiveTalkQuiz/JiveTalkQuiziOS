//
//  QuizShowViewReactor.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/03/02.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

class QuizShowViewReactor: Reactor {
  enum Action {
    case answer(Int)
  }
  
  enum Mutation {
    case getRight(Int)
    case getWrong(Int)
    case empty
  }
  
  struct State {
    var number: Int
    var quiz: QuizElement?
    var localStorage: LocalStorage
    var isCorrect: Bool?
    var level: JiveTalkQuizLevel {
      return JiveTalkQuizLevel.get(solved: localStorage
        .quizList
        .filter({ $0.isSolved == true })
        .count)
    }
  }
  
  let initialState: State
  
  init(number: Int, localStorage: LocalStorage) {
    initialState = State(number: number,
                         quiz: localStorage.storageQuizList[number],
                         localStorage: localStorage)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    
    switch action {
    case .answer(let selectionNumber):
      guard let isCorrect = currentState.quiz?.selection[selectionNumber].correct,
        currentState.localStorage.heartPoint > 0,
        currentState.localStorage.quizList[currentState.number]
          .isDimmed[selectionNumber] == false else {
        return Observable.just(.empty)
      }
      
      if isCorrect {
        return Observable.just(.getRight(selectionNumber))
      } else {
        return Observable.just(.getWrong(selectionNumber))
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .getRight(_):
      state.localStorage.solve(quiz: state.number)
      let total = state.localStorage.quizList.count
      if total > state.number {
        state.quiz = state.localStorage.storageQuizList[state.number + 1]
        state.number = state.number + 1
        if state.number > state.localStorage.solvedNumber {
          state.localStorage.setupSolvedNumber(number: state.number)
        }
      }
      state.isCorrect = true
      return state
    case .getWrong(let selectionNumber):
      if state.number >= state.localStorage.solvedNumber {
        state.localStorage.calculate(point: .wrong)
      }
      state.localStorage.dimmed(number: state.number, example: selectionNumber)
      state.isCorrect = false
      return state
    case .empty:
      state.isCorrect = nil
      return state
    }
  }
}
