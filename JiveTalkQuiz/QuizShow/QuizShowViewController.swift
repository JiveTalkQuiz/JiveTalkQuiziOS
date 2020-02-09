//
//  QuizShowViewController.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/08.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit

class QuizShowViewController: UIViewController {
  let quizView = QuizView(frame: .zero)
  let stackView = UIStackView(frame: .zero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    quizView.backgroundColor = .blue
    view.addSubview(quizView)
    
    stackView.backgroundColor = .systemPink
    view.addSubview(stackView)
    
    setupConstraint()
  }
  
  func setupConstraint() {
    quizView.translatesAutoresizingMaskIntoConstraints = false
    quizView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0)
      .isActive = true
    quizView.leftAnchor
      .constraint(equalTo: view.leftAnchor, constant: 20.0)
      .isActive = true
    quizView.rightAnchor
      .constraint(equalTo: view.rightAnchor, constant: -20.0)
      .isActive = true
    quizView.bottomAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20.0)
      .isActive = true

//    stackView.heightAnchor
//      .constraint(equalToConstant: 260.0)
//      .isActive = true
//    stackView.leftAnchor
//      .constraint(equalTo: view.leftAnchor, constant: 20.0)
//      .isActive = true
//    stackView.bottomAnchor
//      .constraint(equalTo: view.bottomAnchor, constant: 100.0)
//      .isActive = true
//    stackView.rightAnchor
//      .constraint(equalTo: view.rightAnchor, constant: 20.0)
//      .isActive = true
  }
}
