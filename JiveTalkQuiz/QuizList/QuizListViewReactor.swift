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
    case setRefreshing(Bool)
    case setQuizs(Quiz?)
  }
  
  struct State {
    var isRefreshing: Bool = false
    var quiz: Quiz? = nil
  }
  
  let initialState: State = State()
  private let storageService: StorageServiceType
  
  init(storageService: StorageServiceType) {
    self.storageService = storageService
    _ = self.state
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      guard !self.currentState.isRefreshing else { return .empty() }
      let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
      let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
      let setQuizs = storageService.request()
        .map { data -> Mutation in
          guard let quiz = try? Quiz(data: data) else {
            debugPrint(QuizError.invalidData)
            return .setQuizs(nil)
          }
          
          return .setQuizs(quiz)
      }
      return .concat([startRefreshing, setQuizs, endRefreshing])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setRefreshing(_):
      state.isRefreshing = false
      return state
    case let .setQuizs(quiz):
      state.quiz = quiz
      return state
    }
  }
}
