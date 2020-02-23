//
//  QuizExampleCell.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/12.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit

class QuizExampleCell: UICollectionViewCell {
  
  var isSolved = false
  let titleLabel = UILabel(frame: .zero)
  let checkImageView = UIImageView(frame: .zero)
  let dimmedView = UIView(frame: .zero)
  
  override var isHighlighted: Bool {
    didSet {
      guard isSolved == false else { return }
      if isHighlighted {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
          self.updateContents(isSelected: true)
        }, completion: nil)
      } else {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
          self.updateContents(isSelected: false)
        }, completion: nil)
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    layer.cornerRadius = 12
      
    titleLabel.textColor = JiveTalkQuizColor.label.value
    titleLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 15.0)
    addSubview(titleLabel)
    
    checkImageView.image = UIImage(named: "check")
    addSubview(checkImageView)
    checkImageView.isHidden = true
    
    dimmedView.backgroundColor = .black
    dimmedView.layer.cornerRadius = 12
    dimmedView.alpha = 0.3
    dimmedView.isHidden = true
    addSubview(dimmedView)
  }
  
  override func prepareForReuse() {
    dimmedView.isHidden = true
    checkImageView.isHidden = true
    isSolved = false
  }
  
  func updateContents(isSelected: Bool) {
    if isSelected {
      titleLabel.textColor = .white
      titleLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 15.0)
      backgroundColor = JiveTalkQuizColor.label.value
      checkImageView.isHidden = false
    } else {
      titleLabel.textColor = JiveTalkQuizColor.label.value
      titleLabel.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 15.0)
      backgroundColor = .white
      checkImageView.isHidden = true
    }
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
    
    checkImageView.translatesAutoresizingMaskIntoConstraints = false
    checkImageView.widthAnchor
      .constraint(equalToConstant: 17.0)
      .isActive = true
    checkImageView.heightAnchor
      .constraint(equalToConstant: 17.0)
      .isActive = true
    checkImageView.topAnchor
      .constraint(equalTo: topAnchor, constant: 14.0)
      .isActive = true
    checkImageView.trailingAnchor
      .constraint(equalTo: trailingAnchor, constant: -14.0)
      .isActive = true
    
    dimmedView.translatesAutoresizingMaskIntoConstraints = false
    dimmedView.topAnchor
      .constraint(equalTo: topAnchor)
      .isActive = true
    dimmedView.leadingAnchor
      .constraint(equalTo: leadingAnchor)
      .isActive = true
    dimmedView.bottomAnchor
      .constraint(equalTo: bottomAnchor)
      .isActive = true
    dimmedView.trailingAnchor
      .constraint(equalTo: trailingAnchor)
      .isActive = true
  }
}
