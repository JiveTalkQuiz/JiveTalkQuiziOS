//
//  QuizShowPopupView.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/16.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit

class QuizShowPopupView: UIView {
  
  let iconView = UIImageView(frame: .zero)
  let titleLabel = UILabel(frame: .zero)
  
  convenience init(isCorrect: Bool) {
    self.init()
    
    layer.cornerRadius = 12
    self.backgroundColor = UIColor.white
    
    if isCorrect {
      titleLabel.textColor = JiveTalkQuizColor.label.value
      titleLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 20.0)
      titleLabel.text = "정답!"
      iconView.image = UIImage(named: "correct")
    } else {
      titleLabel.textColor = JiveTalkQuizColor.incorrect.value
      titleLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 20.0)
      titleLabel.text = "땡!"
      iconView.image = UIImage(named: "incorrect")
    }
    
    addSubview(titleLabel)
    addSubview(iconView)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.topAnchor
      .constraint(equalTo: topAnchor, constant: 35)
      .isActive = true
    iconView.centerXAnchor
      .constraint(equalTo: centerXAnchor)
      .isActive = true
    iconView.heightAnchor
      .constraint(equalToConstant: 76)
      .isActive = true
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor
      .constraint(equalTo: iconView.topAnchor,
                  constant: 76.0 + 12.0)
      .isActive = true
    titleLabel.centerXAnchor
    .constraint(equalTo: centerXAnchor)
    .isActive = true
  }
}

extension QuizShowPopupView {
  func show() {
    
  }
}
