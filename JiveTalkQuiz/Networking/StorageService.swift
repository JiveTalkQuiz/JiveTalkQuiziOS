//
//  FirebaseStorageService.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/14.
//  Copyright © 2020 sihon321. All rights reserved.
//

import Foundation
import FirebaseStorage
import RxFirebase
import RxSwift

protocol StorageServiceType {
  func request() -> Observable<Data>
  func requestLocalData() -> Observable<Data>
}

class StorageService: StorageServiceType  {
  private var reference: Reactive<StorageReference>?
  private let disposeBag = DisposeBag()
  
  init() {
    #if RELEASE
    reference = Storage.storage()
      .reference(forURL: JiveTalkQuizAPI.quiz.route)
      .rx
    #endif
  }
  
  func request() -> Observable<Data> {
    return Observable<Data>.create { [weak self] observer in
      guard let strongSelf = self else {
        return Disposables.create()
      }
      
      strongSelf.reference?.getData(maxSize: 1 * 1024 * 1024)
        .subscribe(onNext: { data in
          observer.onNext(data)
          observer.onCompleted()
        }, onError: { error in
          observer.onError(error)
        }).disposed(by: strongSelf.disposeBag)
      
      return Disposables.create()
    }
  }
  
  func requestLocalData() -> Observable<Data> {
    return Observable<Data>.create { observer in
      guard let url = Bundle.main.url(forResource: "quiz",
                                      withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
          return Disposables.create()
      }
      
      observer.onNext(data)
      observer.onCompleted()
      
      return Disposables.create()
    }
  }
  
}

extension Reactive where Base: StorageService {
  
}
