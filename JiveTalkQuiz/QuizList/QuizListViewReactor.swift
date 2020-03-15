//
//  QuizListViewReactor.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/02.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

class QuizListViewReactor: Reactor {

  enum Action {
    case refresh
  }
  
  enum Mutation {
    case setHeartPoint(Int)
    case setRefreshing(Bool)
    case setQuizs(Quiz?)
  }
  
  struct State {
    var heartPoint: Int
    let storageService: StorageServiceType
    let localStorage: LocalStorage
    var isRefreshing: Bool = false
    var quiz: Quiz? = nil
  }
  
  var initialState: State
  
  init(storageService: StorageServiceType, localStorage: LocalStorage) {
    initialState = State(heartPoint: localStorage.heartPoint,
                         storageService: storageService,
                         localStorage: localStorage)
    _ = self.state
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      guard !self.currentState.isRefreshing else { return .empty() }
      let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
      let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
      #if DEBUG
      let setQuizs = currentState.storageService.requestLocalData()
        .map { data -> Mutation in
          guard let quiz = try? Quiz(data: data) else {
            debugPrint(QuizError.invalidData)
            return .setQuizs(nil)
          }
          
          return .setQuizs(quiz)
      }
      #else
      let setQuizs = currentState.storageService.request()
        .map { data -> Mutation in
          guard let quiz = try? Quiz(data: data) else {
            debugPrint(QuizError.invalidData)
            return .setQuizs(nil)
          }
          
          return .setQuizs(quiz)
      }
      #endif

      return .concat([startRefreshing, setQuizs, endRefreshing])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setHeartPoint(point):
      state.heartPoint = point
      return state
    case .setRefreshing(_):
      state.isRefreshing = false
      return state
    case let .setQuizs(quiz):
      state.quiz = quiz
      if let list = quiz?.quizList {
        currentState.localStorage.initQuiz(list: list)
      }
      return state
    }
  }
}
