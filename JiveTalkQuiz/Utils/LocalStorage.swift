//
//  LocalStorage.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/15.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class LocalStorage {
  
}

extension DefaultsKeys {
  var quizList: DefaultsKey<[Bool]> { return .init("quizList", defaultValue: [Bool]()) }
}
