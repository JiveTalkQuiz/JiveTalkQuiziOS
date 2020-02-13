//
//  QuizListCell.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/02.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class QuizListCell: UICollectionViewCell, View {
  
  var viewController: UIViewController?
  
  let label = UILabel(frame: .zero)
  
  var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    label.textColor = JiveTalkQuizColor.label.value
    label.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 15.0)
    addSubview(label)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init(frame: .zero)
  }
  
  func bind(reactor: QuizListCellReactor) {
    reactor.state
      .map { $0.number }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] number in
        self?.label.text = String(number)
      })
      .disposed(by: self.disposeBag)
    
    self.contentView.rx.tapGesture()
      .filter { $0.state == .ended }
      .subscribe(onNext: { [weak reactor, weak self] _ in
        guard let reactor = reactor else { return }
        let quizShowVC = QuizShowViewController()
        quizShowVC.modalPresentationStyle = .fullScreen
        self?.viewController?
          .navigationController?
          .pushViewController(quizShowVC,
                              animated: false)
      })
      .disposed(by: disposeBag)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.label.translatesAutoresizingMaskIntoConstraints = false
    self.label.centerYAnchor
      .constraint(equalTo: self.contentView.centerYAnchor)
      .isActive = true
    self.label.centerXAnchor
      .constraint(equalTo: self.contentView.centerXAnchor)
      .isActive = true
    
    self.label.textAlignment = .center
    self.label.sizeToFit()
  }
}
