//
//  QuizView.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/08.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit

class QuizView: UIView {
  
  let numberLabel = UILabel(frame: .zero)
  let problemLabel = UILabel(frame: .zero)

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    layer.cornerRadius = 12
    
    numberLabel.textColor = JiveTalkQuizColor.label.value
    numberLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 13.0)
    addSubview(numberLabel)
    
    problemLabel.textColor = JiveTalkQuizColor.label.value
    problemLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 50.0)
    addSubview(problemLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    numberLabel.translatesAutoresizingMaskIntoConstraints = false
    numberLabel.centerXAnchor
      .constraint(equalTo: centerXAnchor).isActive = true
    numberLabel.topAnchor
      .constraint(equalTo: topAnchor, constant: 20.0).isActive = true
    numberLabel.sizeToFit()
    
    problemLabel.translatesAutoresizingMaskIntoConstraints = false
    problemLabel.centerYAnchor
      .constraint(equalTo: centerYAnchor).isActive = true
    problemLabel.centerXAnchor
      .constraint(equalTo: centerXAnchor).isActive = true
    problemLabel.sizeToFit()
  }
}
