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
  
  func updateContents(level: JiveTalkQuizLevel?) {
    guard let level = level else { return }
    imageLabel.text = level.description
    levelLabel.text = "Lv. " + level.rawValue
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
