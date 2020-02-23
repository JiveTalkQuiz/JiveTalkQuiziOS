//
//  StorageQuiz.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/22.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct StorageQuiz: Codable, DefaultsSerializable {
  var isSolved: Bool = false
  var idDimmed: [Bool] = []
}

typealias StorageQuizList = [StorageQuiz]

