//
//  QuizListViewController.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/02.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class QuizListViewController: UIViewController, View {

  enum Section: Int {
    case title, level, quiz
  }
  
  var collectionView: UICollectionView!
  
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    defer { self.reactor = QuizListViewReactor(heart: 15) }
    
    view.backgroundColor = JiveTalkQuizColor.main.value
    
    collectionView.backgroundColor = JiveTalkQuizColor.main.value
    collectionView.showsVerticalScrollIndicator = false
    collectionView.register(QuizListTitleCell.self,
                            forCellWithReuseIdentifier: "QuizListTitleCell")
    collectionView.register(QuizListLevelCell.self,
                            forCellWithReuseIdentifier: "QuizListLevelCell")
    collectionView.register(QuizListCell.self,
                            forCellWithReuseIdentifier: "QuizListCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    view.addSubview(collectionView)
    
    setupConstraint()
    
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.configureWithTransparentBackground()
    navBarAppearance.backgroundColor = JiveTalkQuizColor.main.value
    navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    navigationController?.navigationBar.standardAppearance = navBarAppearance
    
    let heartButton: UIButton = {
      let bt = UIButton()
      bt.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
      bt.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
      // 99넘을시 예외처리
      bt.setTitle("99+", for: .normal)
      bt.titleLabel?.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 11.0)
      bt.setTitleColor(JiveTalkQuizColor.label.value, for: .normal)
      bt.titleEdgeInsets = UIEdgeInsets(top: .zero, left: 4.0, bottom: .zero, right: .zero)
      bt.titleLabel?.sizeToFit()
      return bt
    }()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton)
  }

  func setupConstraint() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      .isActive = true
    collectionView.rightAnchor
      .constraint(equalTo: view.rightAnchor, constant: -40.0)
      .isActive = true
    collectionView.bottomAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      .isActive = true
    collectionView.leftAnchor
      .constraint(equalTo: view.leftAnchor, constant: 40.0)
      .isActive = true
  }
  
  func bind(reactor: QuizListViewReactor) {

  }
}

extension QuizListViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    let section = Section(rawValue: section)
    switch section {
    case .title:
      return 1
    case .level:
      return 1
    case .quiz:
      return 50
    case .none:
      return 0
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
      let section = Section(rawValue: indexPath.section)
      switch section {
      case .title:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizListTitleCell",
                                                      for: indexPath) as! QuizListTitleCell
        return cell
      case .level:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizListLevelCell",
        for: indexPath) as! QuizListLevelCell
        return cell
      case .quiz:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizListCell",
                                                      for: indexPath) as! QuizListCell
          cell.reactor = QuizListCellReactor(number: indexPath.row)
          cell.viewController = self
          return cell
      case .none:
        return UICollectionViewCell()
      }
  }

}

extension QuizListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let section = Section(rawValue: indexPath.section)
    switch section {
    case .title:
      return CGSize(width: view.bounds.width - 80.0, height: 200.0)
    case .level:
      return CGSize(width: view.bounds.width - 80.0, height: 32.0)
    case .quiz:
      return CGSize(width: 55.0, height: 55.0)
    case .none:
      return .zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let section = Section(rawValue: section)
    switch section {
    case .title:
      return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 106.0, right: 0.0)
    case .level:
      return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 25.0, right: 0.0)
    case .quiz:
      return .zero
    case .none:
      return .zero
    }
  }
}
