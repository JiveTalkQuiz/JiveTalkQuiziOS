//
//  QuizShowViewController.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/08.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit
import GoogleMobileAds
import RxSwift
import RxCocoa

class QuizShowViewController: UIViewController {
  
  enum Section: Int {
    case show, example
  }
  
  var collectionView: UICollectionView?
  var heartButton: UIButton?
  var guideView = UIImageView(frame: .zero)
  
  var bannerView: GADBannerView!
  var interstitial: GADInterstitial!
  
  var quiz: QuizElement?
  var localStorage: LocalStorage?
  var guidHintContraint: NSLayoutConstraint?
  var guidAdsContraint: NSLayoutConstraint?
  
  var index: Int?
  var guideImage: String {
    guard let storage = localStorage else {
      return ""
    }

    if storage.heartPoint <= 0 {
      return "ads"
    } else {
      return "hint"
    }
  }
  var observer = PublishSubject<Bool>()
  
  override func viewDidLoad() {
    defer {
        setupConstraint()
    }
    
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: layout)
    
    super.viewDidLoad()
    
    self.view.backgroundColor = JiveTalkQuizColor.main.value

    collectionView?.delaysContentTouches = false
    collectionView?.backgroundColor = JiveTalkQuizColor.main.value
    collectionView?.register(QuizShowCell.self,
                       forCellWithReuseIdentifier: "QuizShowCell")
    collectionView?.register(QuizExampleCell.self,
                       forCellWithReuseIdentifier: "QuizExampleCell")
    collectionView?.dataSource = self
    collectionView?.delegate = self
    view.addSubview(collectionView!)
    
    guideView.image = UIImage(named: guideImage)
    guideView.alpha = 0.0
    view.addSubview(guideView)
    
    initNavigationBar()
    
    bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: view.bounds.width, height: 50.0)))
    bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    bannerView.rootViewController = self
    addBannerViewToView(bannerView)
    bannerView.load(GADRequest())
    
    interstitial = createAndLoadInterstitial()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 0.8,
                   delay: 0.5,
                   options: .curveEaseIn,
                   animations: { [weak self] in
                    self?.guideView.alpha = 1.0
    }, completion: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    UIView.animate(withDuration: 0.8,
                   delay: 0.5,
                   options: .curveEaseIn,
                   animations: { [weak self] in
                    self?.guideView.alpha = 0
    }, completion: nil)
  }

  func createAndLoadInterstitial() -> GADInterstitial {
    interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
    interstitial.delegate = self
    interstitial.load(GADRequest())
    return interstitial
  }
  
  private func initNavigationBar() {
    if #available(iOS 13, *) {
      let navBarAppearance = UINavigationBarAppearance()
      navBarAppearance.configureWithOpaqueBackground()
      navBarAppearance.configureWithTransparentBackground()
      navBarAppearance.backgroundColor = JiveTalkQuizColor.main.value
      navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
      navigationController?.navigationBar.standardAppearance = navBarAppearance
    } else {
      navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                             for: .any,
                                                             barMetrics: .default)
      navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    heartButton = {
      let bt = UIButton()
      bt.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
      bt.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
      if let point = localStorage?.heartPoint {
        bt.setTitle(String(point), for: .normal)
      }
      bt.titleLabel?.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 11.0)
      bt.setTitleColor(JiveTalkQuizColor.label.value, for: .normal)
      bt.titleEdgeInsets = UIEdgeInsets(top: .zero, left: 4.0, bottom: .zero, right: .zero)
      bt.titleLabel?.sizeToFit()
      bt.addTarget(self, action: #selector(touchedDownHeartButton),
                   for: .touchDown)
      return bt
    }()
    
    let backButton: UIButton = {
      let bt = UIButton()
      
      bt.setImage(#imageLiteral(resourceName: "back"), for: .normal)
      bt.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
      bt.titleLabel?.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 11.0)
      bt.setTitleColor(JiveTalkQuizColor.label.value, for: .normal)
      bt.addTarget(self, action: #selector(touchedDownBackButton), for: .touchDown)
      return bt
    }()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton!)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
  }
  
  @objc
  private func touchedDownHeartButton() {
    guard let storage = localStorage else { return }
    
    if interstitial.isReady, storage.heartPoint <= 0 {
      interstitial.present(fromRootViewController: self)
      storage.calculate(point: .ad)
    } else if let index = index,
      let localIndex = storage.quizList[index]
        .isDimmed
        .enumerated()
        .filter({
          ($0.element == false)
          && ($0.offset != storage.quizList[index].correctNumber)
        })
        .map({ $0.offset })
        .randomElement() {
      storage.calculate(point: .hint)
      storage.dimmed(number: index, example: localIndex)
      UIView.animate(withDuration: 1,
                     delay: 0.5,
                     options: .curveEaseIn,
      animations: { [weak self] in
        self?.collectionView?.reloadData()
      }, completion: nil)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.setupHeartPoint()
      self?.observer.onNext(false)
    }
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
    self.navigationController?.popViewController(animated: true)
  }
  
  private func setupConstraint() {
    
    collectionView?.translatesAutoresizingMaskIntoConstraints = false
    collectionView?.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      .isActive = true
    collectionView?.leadingAnchor
      .constraint(equalTo: view.leadingAnchor)
      .isActive = true
    collectionView?.bottomAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      .isActive = true
    collectionView?.trailingAnchor
      .constraint(equalTo: view.trailingAnchor)
      .isActive = true
    
    guideView.translatesAutoresizingMaskIntoConstraints = false
    guideView.widthAnchor
      .constraint(equalToConstant: 58.0)
      .isActive = true
    guideView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      .isActive = true
    guideView.trailingAnchor
      .constraint(equalTo: view.trailingAnchor, constant: -22.0)
      .isActive = true
    guidHintContraint = guideView.heightAnchor
      .constraint(equalToConstant: 30.0)
    guidAdsContraint = guideView.heightAnchor
    .constraint(equalToConstant: 42.0)
  }
  
  func setupHeartPoint() {
    if let storage = localStorage {
      heartButton?.setTitle(String(storage.heartPoint), for: .normal)
      guideView.image = UIImage(named: guideImage)
      
      if storage.heartPoint <= 0 {
        guidHintContraint?.isActive = false
        guidAdsContraint?.isActive = true
      } else {
        guidAdsContraint?.isActive = false
        guidHintContraint?.isActive = true
      }
    }
  }
  
  private func nextQuiz() {
    guard let index = index,
      let totalCount = localStorage?.quizList.count,
      totalCount > index + 1,
      let quizList = localStorage?.storageQuizList else {
        return
    }
    
    self.quiz = quizList[index + 1]
    self.index = index + 1
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   options: .curveEaseIn,
                   animations: { [weak self] in
                    self?.collectionView?.contentOffset = .zero
                    self?.collectionView?.reloadData()
    })
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
    popup.animate()
    
    UIView.animate(withDuration: 0.8,
                   delay: 0.5,
                   options: .curveEaseIn,
                   animations: {
      popup.alpha = 0.0
    }, completion: { _ in
      popup.removeFromSuperview()
    })
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    collectionView?.collectionViewLayout.invalidateLayout()
  }
}

extension QuizShowViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
        let section = Section(rawValue: section)
    switch section {
    case .show:
      return 1
    case .example:
      return 4
    case .none:
      return 0
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
      let section = Section(rawValue: indexPath.section)
      switch section {
      case .show:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizShowCell",
                                                            for: indexPath) as? QuizShowCell else {
            return UICollectionViewCell()
        }
        
        let number = quiz?.id == nil ? -1 : quiz!.id
        cell.numberLabel.text = "\(number)장"
        cell.problemLabel.text = quiz?.word ?? ""
        return cell
      case .example:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizExampleCell",
                                                            for: indexPath) as? QuizExampleCell,
          let index = index else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = quiz?.selection[indexPath.row].statement ?? ""
        if let storage = localStorage,
          storage.quizList[index].isDimmed[indexPath.row] {
          cell.dimmedView.isHidden = false
        }
        if let isSolved = localStorage?.quizList[index].isSolved, isSolved {
          cell.isSolved = isSolved
          
          if let isCorrect = quiz?.selection[indexPath.row].correct, isCorrect {
            cell.checkImageView.isHidden = false
          }
        }
        return cell
      case .none:
        return UICollectionViewCell()
      }
  }
}

extension QuizShowViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let section = Section(rawValue: indexPath.section)
    switch section {
    case .show:
      return CGSize(width: view.bounds.width - 40.0,
                    height: 300)
    case .example:
      return CGSize(width: view.bounds.width - 40.0, height: 45)
    case .none:
      return .zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    let section = Section(rawValue: section)
    switch section {
    case .show:
      return UIEdgeInsets(top: 5.0, left: 20.0, bottom: 25.0, right: 20.0)
    case .example:
      return UIEdgeInsets(top: 25.0, left: 20.0, bottom: 75.0, right: 20.0)
    case .none:
      return .zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15.0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    guard let section = Section(rawValue: indexPath.section),
      section == .example,
      let index = index, let storage = localStorage,
      storage.quizList[index].isSolved == false else {
        return
    }
    
    guard storage.heartPoint > 0 else {
      return
    }
    
    if quiz?.selection[indexPath.row].correct ?? false {
      showToast(isCorrect: true)
      localStorage?.solve(quiz: index)
      observer.onNext(true)
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
        self?.nextQuiz()
      }
    } else {
      showToast(isCorrect: false)
      localStorage?.calculate(point: .wrong)
      localStorage?.dimmed(number: index, example: indexPath.row)
        self.setupHeartPoint()
        self.observer.onNext(false)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      collectionView.reloadData()
    }
    
  }
}

// MARK: - GADInterstitialDelegate
extension QuizShowViewController: GADInterstitialDelegate {
  /// Tells the delegate an ad request succeeded.
  func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    print("interstitialDidReceiveAd")
  }

  /// Tells the delegate an ad request failed.
  func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
    print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
  }

  /// Tells the delegate that an interstitial will be presented.
  func interstitialWillPresentScreen(_ ad: GADInterstitial) {
    print("interstitialWillPresentScreen")
  }

  /// Tells the delegate the interstitial is to be animated off the screen.
  func interstitialWillDismissScreen(_ ad: GADInterstitial) {
    print("interstitialWillDismissScreen")
  }

  /// Tells the delegate the interstitial had been animated off the screen.
  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    print("interstitialDidDismissScreen")
    interstitial = createAndLoadInterstitial()
  }

  /// Tells the delegate that a user click will open another app
  /// (such as the App Store), backgrounding the current app.
  func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
    print("interstitialWillLeaveApplication")
  }
}
