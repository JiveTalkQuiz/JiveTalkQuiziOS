//
//  QuizExampleCell.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/12.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit

class QuizExampleCell: UICollectionViewCell {
  
  let titleLabel = UILabel(frame: .zero)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    layer.cornerRadius = 12
    
    titleLabel.textColor = JiveTalkQuizColor.label.value
    titleLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 15.0)
    
    addSubview(titleLabel)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init(frame: .zero)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.centerXAnchor
      .constraint(equalTo: centerXAnchor)
      .isActive = true
    titleLabel.centerYAnchor
    .constraint(equalTo: centerYAnchor)
    .isActive = true
    titleLabel.sizeToFit()
  }
}
