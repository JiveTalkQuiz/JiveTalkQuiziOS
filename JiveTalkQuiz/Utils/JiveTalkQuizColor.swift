//
//  JiveTalkQuizColor.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/09.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit

enum JiveTalkQuizColor {
  case main, label, incorrect
  
  var value: UIColor {
    switch self {
    case .main: return UIColor(red: 198/255,
                               green: 222/255,
                               blue: 212/255,
                               alpha: 1.0)
    case .label: return UIColor(red: 54/255,
                                green: 128/255,
                                blue: 132/255,
                                alpha: 1.0)
    case .incorrect: return UIColor(red: 143/255,
                                    green: 143/255,
                                    blue: 143/255,
                                    alpha: 1.0)
    }
  }
}
