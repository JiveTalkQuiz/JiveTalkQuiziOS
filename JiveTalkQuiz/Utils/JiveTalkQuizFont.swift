//
//  JiveTalkQuizFont.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/12.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation

enum JiveTalkQuizFont {
  case hannaPro
  
  var value: String {
    switch self {
    case .hannaPro: return "BMHANNAProOTF"
    }
  }
}
