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
  var quizShowVC: QuizShowViewController?
  let label = UILabel(frame: .zero)
  let imageView = UIImageView(frame: .zero)
  
  var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    backgroundView = UIImageView(image: UIImage(named: "stage"))
    
    label.textColor = JiveTalkQuizColor.label.value
    label.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 15.0)
    label.textAlignment = .center
    label.sizeToFit()
    addSubview(label)
    
    imageView.image = UIImage(named: "stageCheck")
    imageView.backgroundColor = .clear
    addSubview(imageView)
  }
    
    override func prepareForReuse() {
        backgroundView = UIImageView(image: UIImage(named: "stage"))
        label.textColor = JiveTalkQuizColor.label.value
        imageView.isHidden = true
    }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init(frame: .zero)
  }
  
  func bind(reactor: QuizListCellReactor) {
    reactor.state
      .map { $0.number }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] number in
        self?.label.text = String(number + 1)
      })
      .disposed(by: self.disposeBag)
    
    self.contentView.rx.tapGesture()
      .filter { $0.state == .ended }
      .subscribe(onNext: { [weak reactor, weak self] _ in
        guard let reactor = reactor,
        reactor.currentState.localStorage.solvedNumber
            >= reactor.currentState.number else { return }
        
        if let quizShow = self?.quizShowVC {
          quizShow.reactor = QuizShowViewReactor(number: reactor.currentState.number,
                                                 localStorage: reactor.currentState.localStorage)
          quizShow.setupHeartPoint()
          quizShow.observer.onNext(false)
          quizShow.collectionView.reloadData()
          self?.viewController?
            .navigationController?
            .pushViewController(quizShow,
                                animated: true)
        }

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
    self.label.sizeToFit()
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = false
    self.imageView.topAnchor
      .constraint(equalTo: topAnchor)
      .isActive = true
    self.imageView.leadingAnchor
      .constraint(equalTo: leadingAnchor)
      .isActive = true
    self.imageView.bottomAnchor
      .constraint(equalTo: bottomAnchor)
      .isActive = true
    self.imageView.trailingAnchor
      .constraint(equalTo: trailingAnchor)
      .isActive = true
    
    if let index = reactor?.currentState.number,
      let isSolved = reactor?.currentState.localStorage.quizList[index].isSolved {
      imageView.isHidden = !isSolved
    }
    
    if let index = reactor?.currentState.number,
        let solvedNumber = reactor?.currentState.localStorage.solvedNumber,
        solvedNumber == index {
        label.textColor = .white
        backgroundView = UIImageView(image: UIImage(named: "stageCopy"))
        backgroundView?.layoutIfNeeded()
    }
  }
}
