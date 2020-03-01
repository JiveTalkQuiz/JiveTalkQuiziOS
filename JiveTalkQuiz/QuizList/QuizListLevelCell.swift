//
//  QuizListHeader.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/06.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit

class QuizListLevelCell: UICollectionViewCell {
  
  let imageView = UIImageView(frame: .zero)
  let imageLabel = UILabel(frame: .zero)
  let levelLabel = UILabel(frame: .zero)
  var level: JiveTalkQuizLevel = .아재
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    layer.cornerRadius = 12
    
    imageView.image = UIImage(named: "Level_1")
    addSubview(imageView)
    
    imageLabel.textColor = .black
    imageLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value,
                             size: 8.0)
    addSubview(imageLabel)
    
    levelLabel.textColor = JiveTalkQuizColor.label.value
    levelLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value,
                             size: 12.0)
    addSubview(levelLabel)
  }
  
  func updateContents(solved problem: Int) {
    level = JiveTalkQuizLevel.get(solved: problem)
    imageLabel.text = level.description
    levelLabel.text = level.rawValue
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = false
    self.imageView.leadingAnchor
      .constraint(equalTo: self.leadingAnchor)
      .isActive = true
    self.imageView.topAnchor
      .constraint(equalTo: self.topAnchor)
      .isActive = true
    self.imageView.bottomAnchor
      .constraint(equalTo: self.bottomAnchor)
      .isActive = true
    self.imageView.widthAnchor
      .constraint(equalToConstant: 74.0)
      .isActive = true
    
    self.imageLabel
      .translatesAutoresizingMaskIntoConstraints = false
    self.imageLabel.leadingAnchor
      .constraint(equalTo: imageView.leadingAnchor,
                  constant: 74.0 + 6.0)
      .isActive = true
    self.imageLabel.topAnchor
      .constraint(equalTo: self.topAnchor)
      .isActive = true
    self.imageLabel.bottomAnchor
      .constraint(equalTo: self.bottomAnchor)
      .isActive = true
    
    self.levelLabel.translatesAutoresizingMaskIntoConstraints = false
    self.levelLabel.centerYAnchor
      .constraint(equalTo: self.centerYAnchor)
      .isActive = true
    self.levelLabel.trailingAnchor
      .constraint(equalTo: self.trailingAnchor, constant: -18.0)
      .isActive = true
    self.levelLabel.sizeToFit()
  }
}

enum JiveTalkQuizLevel: String {
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
    case 1...20: return .아재
    case 21...40: return .문찐
    case 41...60: return .프로불편러
    case 61...80: return .오놀아놈
    case 81...100: return .인싸
    default:
      return .아재
    }
  }
}
