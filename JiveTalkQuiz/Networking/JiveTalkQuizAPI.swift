//
//  JiveTalkQuizAPI.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/15.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation

enum JiveTalkQuizAPI {
  case quiz
}

extension JiveTalkQuizAPI {
  var baseURL: String {
    return "gs://jivetalk-quiz.appspot.com"
  }
  
  var route: String {
    switch self {
    case .quiz:
      return baseURL + "/quiz.json"
    }
  }
}
