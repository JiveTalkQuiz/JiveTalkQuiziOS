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
  let quizView = QuizView(frame: .zero)
  let stackView = UIStackView(frame: .zero)
  var collectionView: UICollectionView?
  var heartButton: UIButton?
  var guideView = UIImageView(frame: .zero)
  
  var bannerView: GADBannerView!
  var interstitial: GADInterstitial!
  
  var quiz: QuizElement?
  var localStorage: LocalStorage?
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
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: layout)
    
    super.viewDidLoad()
    
    self.view.backgroundColor = JiveTalkQuizColor.main.value
    view.addSubview(stackView)

    collectionView?.delaysContentTouches = false
    collectionView?.backgroundColor = JiveTalkQuizColor.main.value
    collectionView?.register(QuizExampleCell.self,
                       forCellWithReuseIdentifier: "QuizExampleCell")
    collectionView?.dataSource = self
    collectionView?.delegate = self
    stackView.addSubview(collectionView!)
    
    guideView.image = UIImage(named: guideImage)
    guideView.alpha = 0.0
    view.addSubview(guideView)
    UIView.animate(withDuration: 0.8,
                   delay: 0.5,
                   options: .curveEaseIn,
                   animations: { [weak self] in
                    self?.guideView.alpha = 1.0
    }, completion: nil)
    
    setupConstraint()
    
    initNavigationBar()
    
    bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: view.bounds.width, height: 50.0)))
    bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    bannerView.rootViewController = self
    addBannerViewToView(bannerView)
    bannerView.load(GADRequest())
    
    interstitial = createAndLoadInterstitial()
  }
  
  func updateContents() {
    let number = quiz?.id == nil ? -1 : quiz!.id
    quizView.numberLabel.text = "\(number)장"
    quizView.problemLabel.text = quiz?.word ?? ""
    stackView.addSubview(quizView)
    collectionView?.reloadData()
  }
  
  func createAndLoadInterstitial() -> GADInterstitial {
    interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
    interstitial.delegate = self
    interstitial.load(GADRequest())
    return interstitial
  }
  
  private func initNavigationBar() {
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.configureWithTransparentBackground()
    navBarAppearance.backgroundColor = JiveTalkQuizColor.main.value
    navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    navigationController?.navigationBar.standardAppearance = navBarAppearance
    
    heartButton = {
      let bt = UIButton()
      bt.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
      bt.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
      // 99넘을시 예외처리
      if let point = localStorage?.heartPoint {
        bt.setTitle(String(point), for: .normal)
      }
      bt.titleLabel?.font = UIFont(name: JiveTalkQuizFont.hannaPro.value, size: 11.0)
      bt.setTitleColor(JiveTalkQuizColor.label.value, for: .normal)
      bt.titleEdgeInsets = UIEdgeInsets(top: .zero, left: 4.0, bottom: .zero, right: .zero)
      bt.titleLabel?.sizeToFit()
      bt.addTarget(self, action: #selector(showFrontAds),
                   for: .touchDown)
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
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton!)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
  }
  
  @objc
  private func showFrontAds() {
    if let storage = localStorage,
      interstitial.isReady, storage.heartPoint <= 0 {
      interstitial.present(fromRootViewController: self)
      storage.calculate(point: .ad)
      setupHeartPoint()
      observer.onNext(false)
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
    
    collectionView?.translatesAutoresizingMaskIntoConstraints = false
    collectionView?.topAnchor
      .constraint(equalTo: quizView.topAnchor,
                  constant: view.bounds.width + 10)
      .isActive = true
    collectionView?.leadingAnchor
      .constraint(equalTo: stackView.leadingAnchor)
      .isActive = true
    collectionView?.bottomAnchor
      .constraint(equalTo: stackView.bottomAnchor)
      .isActive = true
    collectionView?.trailingAnchor
      .constraint(equalTo: stackView.trailingAnchor)
      .isActive = true
    
    guideView.translatesAutoresizingMaskIntoConstraints = false
    guideView.widthAnchor
      .constraint(equalToConstant: 58.0)
      .isActive = true
    guideView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4)
      .isActive = true
    guideView.trailingAnchor
      .constraint(equalTo: view.trailingAnchor, constant: -22.0)
      .isActive = true
  }
  
  private func setupHeartPoint() {
    if let storage = localStorage {
      heartButton?.setTitle(String(storage.heartPoint), for: .normal)
      guideView.image = UIImage(named: guideImage)
      var height: CGFloat = 0.0
      if storage.heartPoint <= 0 {
        height = 42.0
      } else {
        height = 30.0

      }
      
      guideView.heightAnchor
        .constraint(equalToConstant: height)
        .isActive = true
    }
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
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizExampleCell", for: indexPath) as? QuizExampleCell,
        let index = index else {
          return UICollectionViewCell()
      }
      cell.titleLabel.text = quiz?.selection[indexPath.row].statement ?? ""
      if let storage = localStorage,
        storage.quizList[index].idDimmed[indexPath.row] {
        cell.dimmedView.isHidden = false
      }
      if let isSolved = localStorage?.quizList[index].isSolved, isSolved {
        cell.isSolved = isSolved
        
        if let isCorrect = quiz?.selection[indexPath.row].correct, isCorrect {
          cell.checkImageView.isHidden = false
        }
      }
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
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    guard let index = index, let storage = localStorage,
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
    } else {
      showToast(isCorrect: false)
      localStorage?.calculate(point: .wrong)
      localStorage?.dimmed(number: index, example: indexPath.row)
      setupHeartPoint()
      observer.onNext(false)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      collectionView.reloadData()
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
}

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
