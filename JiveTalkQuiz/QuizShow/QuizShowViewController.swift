//
//  QuizShowViewController.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/08.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit
import ReactorKit
import GoogleMobileAds
import RxSwift
import RxCocoa
import AdSupport

class QuizShowViewController: UIViewController, View {
  
  enum Section: Int {
    case show, example
  }
  
  var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
    layout.scrollDirection = .vertical
    collectionView.delaysContentTouches = false
    collectionView.backgroundColor = JiveTalkQuizColor.main.value
    collectionView.register(QuizShowCell.self,
                            forCellWithReuseIdentifier: "QuizShowCell")
    collectionView.register(QuizExampleCell.self,
                            forCellWithReuseIdentifier: "QuizExampleCell")
    return collectionView
  }()
  
  var heartButton: UIButton?
  var guideView = UIButton(frame: .zero)
  
  var bannerView: GADBannerView!
  var googleRewardedAdView: GADRewardedAd!
  var guidHintContraint: NSLayoutConstraint?
  var guidAdsContraint: NSLayoutConstraint?
  
  var guideImage: String {
    guard let storage = reactor?.currentState.localStorage else {
      return ""
    }

    if storage.heartPoint <= 0 {
      return "ads"
    } else {
      return "hint"
    }
  }
  var observer = PublishSubject<Bool>()
  
  var disposeBag = DisposeBag()
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    defer {
      setupConstraint()
    }
    
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
    
    super.viewDidLoad()
    
    self.view.backgroundColor = JiveTalkQuizColor.main.value

    view.addSubview(collectionView)
    
    guideView.setImage(UIImage(named: guideImage), for: .normal)
    guideView.alpha = 0.0
    guideView.addTarget(self, action: #selector(touchedDownHeartButton), for: .touchDown)
    view.addSubview(guideView)
    
    initNavigationBar()
    
    createBannerView()
    googleRewardedAdView = createAndLoadRewardedAd()
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
  
  // MARK: Binding
  func bind(reactor: QuizShowViewReactor) {
    self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    self.collectionView.rx.setDataSource(self).disposed(by: disposeBag)
    
    collectionView
      .rx
      .itemSelected
      .filter { Section(rawValue: $0.section) == .example }
      .map { Reactor.Action.answer($0.row) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isCorrect }
      .subscribe(onNext: { [weak self] isCorrect in
        guard let isCorrect = isCorrect else {
          JiveTalkQuizAudioPlayer.shared.playSound(effect: .empty)
          return
        }
        
        let storage = reactor.currentState.localStorage
        if isCorrect {
          if storage.level != reactor.currentState.level {
            storage.setupLevel(reactor.currentState.level)
            storage.calculate(point: .level)
          }
          
          self?.showToast(isCorrect: true)
          self?.setupHeartPoint()
          self?.nextQuiz()
          self?.observer.onNext(true)
          JiveTalkQuizAudioPlayer.shared.playSound(effect: .correct)
        } else {
          self?.showToast(isCorrect: false)
          self?.observer.onNext(false)
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self?.setupHeartPoint()
            self?.collectionView.reloadData()
          }
          JiveTalkQuizAudioPlayer.shared.playSound(effect: .incorrect)
        }
      }).disposed(by: disposeBag)
  }
  
  // MARK: Constraints
  private func setupConstraint() {
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      .isActive = true
    collectionView.leadingAnchor
      .constraint(equalTo: view.leadingAnchor)
      .isActive = true
    collectionView.bottomAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      .isActive = true
    collectionView.trailingAnchor
      .constraint(equalTo: view.trailingAnchor)
      .isActive = true
    
    guideView.translatesAutoresizingMaskIntoConstraints = false
    guideView.widthAnchor
      .constraint(equalToConstant: 58.0)
      .isActive = true
    guideView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      .isActive = true
    let value: CGFloat = heartButton?.imageView?.frame.minX == 0
      ? 0.0 : heartButton!.imageView!.frame.minX
    guideView.trailingAnchor
      .constraint(equalTo: view.trailingAnchor, constant: -12.0 - value)
      .isActive = true
    guidHintContraint = guideView.heightAnchor
      .constraint(equalToConstant: 30.0)
    guidAdsContraint = guideView.heightAnchor
      .constraint(equalToConstant: 42.0)
  }
  
  // MARK: NavigationBar
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
      if let point = reactor?.currentState.localStorage.heartPoint {
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
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    collectionView.collectionViewLayout.invalidateLayout()
  }
}

// MARK: - Action
extension QuizShowViewController {
  
  @objc
  private func touchedDownHeartButton() {
    guard let storage = reactor?.currentState.localStorage else { return }
    
    if storage.heartPoint <= 0 {
      if googleRewardedAdView.isReady {
        googleRewardedAdView.present(fromRootViewController: self, delegate: self)
      }
    } else if let index = reactor?.currentState.number,
      let localIndex = storage.quizList[index]
        .isDimmed
        .enumerated()
        .filter({
          ($0.element == false)
            && ($0.offset != storage.quizList[index].correctNumber)
        })
        .map({ $0.offset })
        .randomElement() {
      
      if storage.solvedNumber <= index {
        storage.calculate(point: .hint)
      }
      storage.dimmed(number: index, example: localIndex)
      
      UIView.animate(withDuration: 1,
                     delay: 0.5,
                     options: .curveEaseIn,
                     animations: { [weak self] in
                      self?.collectionView.reloadData()
        }, completion: nil)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.setupHeartPoint()
        self?.observer.onNext(false)
      }
    }
  }
  
  @objc
  private func touchedDownBackButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
  func setupHeartPoint() {
    if let storage = reactor?.currentState.localStorage {
      heartButton?.setTitle(String(storage.heartPoint), for: .normal)
      guideView.setImage(UIImage(named: guideImage), for: .normal)
      
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
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      self?.collectionView.contentOffset = .zero
      self?.collectionView.reloadData()
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

// MARK: - UICollectionViewDataSource
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
        
        let number = reactor?.currentState.quiz?.id == nil ? -1 : reactor!.currentState.quiz!.id
        cell.updateContents(numberString: "\(number)장",
          problem: reactor?.currentState.quiz?.word ?? "")
        return cell
      case .example:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizExampleCell",
                                                            for: indexPath) as? QuizExampleCell,
          let index = reactor?.currentState.number else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = reactor?.currentState.quiz?.selection[indexPath.row].statement ?? ""
        
        if let storage = reactor?.currentState.localStorage,
          storage.quizList[index].isDimmed[indexPath.row] {
          cell.updateContents()
        }
        
        if let isSolved = reactor?.currentState.localStorage.quizList[index].isSolved,
          isSolved {
          cell.isSolved = isSolved
        }
        return cell
      case .none:
        return UICollectionViewCell()
      }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension QuizShowViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let section = Section(rawValue: indexPath.section)
    switch section {
    case .show:
      let ratio = (1 - (view.bounds.height / 715))
      var height = 335 - (round(335 * ratio) * 2)
      height = height > 335 ? 335 : height
      return CGSize(width: view.bounds.width - 40.0,
                    height: height)
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
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15.0
  }
}

// MARK: - Google AdMobs
extension QuizShowViewController {

  private func createBannerView() {
    #if DEBUG
    let adUnitID = "ca-app-pub-3940256099942544/2934735716"
    #else
    let adUnitID = ""
    #endif
    
    bannerView = GADBannerView(adSize: kGADAdSizeBanner)
    bannerView.adUnitID = adUnitID
    bannerView.rootViewController = self
    bannerView.delegate = self
    addBannerViewToView(bannerView)
    
    let request = GADRequest()
    
    bannerView.load(request)
  }
  
  private func addBannerViewToView(_ bannerView: GADBannerView) {
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bannerView)
    bannerView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }

  private func createAndLoadRewardedAd() -> GADRewardedAd {
    #if DEBUG
    var adUnitID = "ca-app-pub-3940256099942544/1712485313"
    #else
    var adUnitID = ""
    #endif
    
    let adView = GADRewardedAd(adUnitID: adUnitID)
    adView.load(GADRequest()) { error in
      if let error = error {
        print("Loading failed: \(error)")
      } else {
        print("Loading Succeeded")
      }
    }
    return adView
  }
}

// MARK: - GADRewardedAdDelegate
extension QuizShowViewController: GADRewardedAdDelegate {
  /// Tells the delegate that the user earned a reward.
  func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
    print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    if let storage = reactor?.currentState.localStorage {
      storage.calculate(reward: reward.amount.intValue)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.setupHeartPoint()
        self?.observer.onNext(false)
      }
    }
  }
  /// Tells the delegate that the rewarded ad was presented.
  func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
    print("Rewarded ad presented.")
  }
  /// Tells the delegate that the rewarded ad was dismissed.
  func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
    print("Rewarded ad dismissed.")
    googleRewardedAdView = createAndLoadRewardedAd()
  }
  /// Tells the delegate that the rewarded ad failed to present.
  func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
    print("Rewarded ad failed to present.")
  }
}

// MARK: - GADBannerViewDelegate
extension QuizShowViewController: GADBannerViewDelegate {
  /// Tells the delegate an ad request loaded an ad.
  func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    print("adViewDidReceiveAd")
  }
  
  /// Tells the delegate an ad request failed.
  func adView(_ bannerView: GADBannerView,
              didFailToReceiveAdWithError error: GADRequestError) {
    print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
  }
  
  /// Tells the delegate that a full-screen view will be presented in response
  /// to the user clicking on an ad.
  func adViewWillPresentScreen(_ bannerView: GADBannerView) {
    print("adViewWillPresentScreen")
  }
  
  /// Tells the delegate that the full-screen view will be dismissed.
  func adViewWillDismissScreen(_ bannerView: GADBannerView) {
    print("adViewWillDismissScreen")
  }
  
  /// Tells the delegate that the full-screen view has been dismissed.
  func adViewDidDismissScreen(_ bannerView: GADBannerView) {
    print("adViewDidDismissScreen")
  }
  
  /// Tells the delegate that a user click will open another app (such as
  /// the App Store), backgrounding the current app.
  func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
    print("adViewWillLeaveApplication")
  }
}
