//
//  QuizListTitleCell.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/09.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit

class QuizListTitleCell: UICollectionViewCell {
  let titleLabel = UILabel(frame: .zero)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    titleLabel.font = UIFont(name: "BMDoHyeon-OTF", size: 70.0)
    titleLabel.text = "신조어테스트"
    titleLabel.numberOfLines = 2
    titleLabel.textColor = JiveTalkQuizColor.label.value
    addSubview(titleLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor
      .constraint(equalTo: topAnchor)
      .isActive = true
    titleLabel.leftAnchor
      .constraint(equalTo: leftAnchor)
      .isActive = true
    titleLabel.widthAnchor
      .constraint(equalToConstant: 230.0)
      .isActive = true
    titleLabel.heightAnchor
      .constraint(equalToConstant: 200.0)
      .isActive = true
    titleLabel.sizeToFit()
  }
}
