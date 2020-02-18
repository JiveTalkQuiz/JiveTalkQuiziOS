//
//  QuizShowViewController.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/08.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit
import GoogleMobileAds

class QuizShowViewController: UIViewController {
  let quizView = QuizView(frame: .zero)
  let stackView = UIStackView(frame: .zero)
  var collectionView: UICollectionView!
  var bannerView: GADBannerView!
  
  var quiz: QuizElement?
  
  override func viewDidLoad() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: layout)
    
    super.viewDidLoad()
    
    self.view.backgroundColor = JiveTalkQuizColor.main.value
    view.addSubview(stackView)
    
    let number = quiz?.id == nil ? -1 : quiz!.id
    quizView.numberLabel.text = "\(number)장"
    quizView.problemLabel.text = quiz?.word ?? ""
    stackView.addSubview(quizView)
    
    collectionView.delaysContentTouches = false
    collectionView.backgroundColor = JiveTalkQuizColor.main.value
    collectionView.register(QuizExampleCell.self,
                       forCellWithReuseIdentifier: "QuizExampleCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    stackView.addSubview(collectionView)
    
    setupConstraint()
    
    initNavigationBar()
    
    bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: view.bounds.width, height: 50.0)))
    bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    bannerView.rootViewController = self
    addBannerViewToView(bannerView)
    bannerView.load(GADRequest())
  }
  
  private func initNavigationBar() {
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
    
    let backButton: UIButton = {
      let bt = UIButton()
      
      bt.setImage(#imageLiteral(resourceName: "back"), for: .normal)
      bt.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
      // 99넘을시 예외처리
      bt.titleLabel?.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 11.0)
      bt.setTitleColor(JiveTalkQuizColor.label.value, for: .normal)
      bt.addTarget(self, action: #selector(touchedDownBackButton), for: .touchDown)
      return bt
    }()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
  }
  
  private func addBannerViewToView(_ bannerView: GADBannerView) {
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bannerView)
    bannerView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }
  
  @objc
  private func touchedDownBackButton() {
    self.navigationController?.popViewController(animated: false)
  }
  
  private func setupConstraint() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                  constant: 5.0)
      .isActive = true
    stackView.leadingAnchor
      .constraint(equalTo: view.leadingAnchor, constant: 20.0)
      .isActive = true
    stackView.bottomAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      .isActive = true
    stackView.rightAnchor
      .constraint(equalTo: view.rightAnchor, constant: -20.0)
      .isActive = true
    
    quizView.translatesAutoresizingMaskIntoConstraints = false
    quizView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                  constant: 20.0)
      .isActive = true
    quizView.leftAnchor
      .constraint(equalTo: view.leftAnchor, constant: 20.0)
      .isActive = true
    quizView.rightAnchor
      .constraint(equalTo: view.rightAnchor, constant: -20.0)
      .isActive = true
    quizView.heightAnchor
      .constraint(equalToConstant: view.bounds.width - 80)
      .isActive = true
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.topAnchor
      .constraint(equalTo: quizView.topAnchor,
                  constant: view.bounds.width + 10)
      .isActive = true
    collectionView.leadingAnchor
      .constraint(equalTo: stackView.leadingAnchor)
      .isActive = true
    collectionView.bottomAnchor
      .constraint(equalTo: stackView.bottomAnchor)
      .isActive = true
    collectionView.trailingAnchor
      .constraint(equalTo: stackView.trailingAnchor)
      .isActive = true
  }
}

extension QuizShowViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView,
                    cellForItemAt indexPath: IndexPath)
  -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizExampleCell", for: indexPath) as? QuizExampleCell else {
      return UICollectionViewCell()
    }
    cell.titleLabel.text = quiz?.selection[indexPath.row].statement ?? ""
    return cell
  }
}

extension QuizShowViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width - 40.0, height: 45)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15.0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if quiz?.selection[indexPath.row].correct ?? false {
      showToast(isCorrect: true)
    } else {
      showToast(isCorrect: false)
    }
  }
  
  private func showToast(isCorrect: Bool) {
    let popup = QuizShowPopupView(isCorrect: isCorrect)
    popup.frame = CGRect(origin: .zero, size: CGSize(width: 156, height: 171))

    view.addSubview(popup)
    popup.translatesAutoresizingMaskIntoConstraints = false
    popup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    popup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    popup.widthAnchor.constraint(equalToConstant: 156.0).isActive = true
    popup.heightAnchor.constraint(equalToConstant: 171.0).isActive = true
    
    UIView.animate(withDuration: 2.0, animations: {
      popup.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
    }, completion: { _ in
      popup.removeFromSuperview()
    })
  }
}
