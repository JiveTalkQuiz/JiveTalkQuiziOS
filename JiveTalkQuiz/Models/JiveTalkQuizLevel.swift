//
//  JiveTalkQuizLevel.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/03/01.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum JiveTalkQuizLevel: String, DefaultsSerializable {
  case 아재, 문찐, 프로불편러, 오놀아놈, 인싸
  
  var description: String {
    switch self {
    case .아재: return "라떼는 말이야~"
    case .문찐: return "아 어려워 급식체 거부!"
    case .프로불편러: return "이걸 또 줄여? 하 불편해"
    case .오놀아놈: return "오~ 당신은 놀줄아는 놈"
    case .인싸: return "이런다고 인싸안되는거 아는 당신은"
    }
  }
  
  static func get(solved problem: Int) -> Self {
    switch problem {
    case 1..<20: return .아재
    case 20..<40: return .문찐
    case 40..<60: return .프로불편러
    case 60..<80: return .오놀아놈
    case 80..<100: return .인싸
    default:
      return .아재
    }
  }
}
