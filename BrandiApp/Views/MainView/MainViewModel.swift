//
//  MainViewModel.swift
//  BrandiApp
//
//  Created by 강지윤 on 2022/03/17.
//

import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

class MainViewModel : ViewModelBuilderProtocol {
   
    
    
    struct Input {
        let searchAction : Driver<String>
        let bottomScrollTriger : Driver<Void>
        let cellClick : Driver<ImageSearchModel>
    }
    
    struct Output {
        let imageSearchModels : Driver<ImageSearchModels>
        let searchClear : Driver<Void>
        let outputError : Driver<Error>
    }
    struct Builder {
        let coordinator : MainViewCoordinator
    }
    
    var totalCount : Int = 0
    
    var itemCount : Int = 30
    //스크롤 에따른 페이징 체크
    //해당값이 True 일때만 추가로 요청을한다

    //페이징카운트
    var pagingCount : Int  = 1
    
    
    let errorTracker = ErrorTracker()
    
    let networkAPI : NetworkServiceProtocol
    let builder : Builder
    let disposeBag : DisposeBag = DisposeBag()
    
    required init( networkAPI : NetworkServiceProtocol = NetworkingAPI.shared  , builder : Builder) {
        self.networkAPI = networkAPI
        self.builder = builder
    }
    
    
    func transform(input: Input) -> Output {
        let imageSearchModels = PublishSubject<ImageSearchModels>()
        let searchClear = PublishSubject<Void>()
        let meta = PublishSubject<PagingAbleModel>()
        let scrollPagingCall = PublishSubject<Bool>()
        
        
        input.searchAction
            .asObservable()
            .flatMap { [weak self] keyword -> Observable<ImageSearchResponseModel>  in
                guard let self = self else { return .never() }
                self.pagingCountClear()
                return self.getImageSearchModels(param: ImageSearchRequestModel(query: keyword, sort: .accuracy, page: self.pagingCount, size: self.itemCount), networkAPI: self.networkAPI)
                    .trackError(self.errorTracker)
                    .catch{ error in
                         return .never()
                    }
            }
            .asDriverOnErrorNever()
            .drive(onNext: { response in
                let searchModels = response.documents
                let metaModel = response.meta
                searchClear.onNext(())
                meta.onNext(metaModel)
                imageSearchModels.onNext(searchModels)
            })
            .disposed(by: disposeBag)
        
        
        
        input.bottomScrollTriger
            .asObservable()
            .withLatestFrom(scrollPagingCall) { $1 }
            .filter{ $0 }
            .withLatestFrom(input.searchAction) { $1 }
            .flatMap{ [weak self] keyword -> Observable<ImageSearchResponseModel> in
                guard let self = self else { return .never() }
                return self.getImageSearchModels(param: ImageSearchRequestModel(query: keyword, sort: .accuracy, page: self.pagingCount, size: self.itemCount), networkAPI: self.networkAPI)
                                   .trackError(self.errorTracker)
                                
                                   .catch{ error in
                                        return .never()
                                   }
            }
            .withLatestFrom(imageSearchModels) { ($0 , $1) }
            .asDriverOnErrorNever()
            .drive(onNext: { response , lastSearachModels in
                let searchModels = response.documents
                let metaModel = response.meta
                meta.onNext(metaModel)
                imageSearchModels.onNext(lastSearachModels + searchModels)
            })
            .disposed(by: disposeBag)

        
        input.cellClick
            .asObservable()
            .bind { [weak self] imageModel in
                guard let self = self else { return }
                self.builder.coordinator.openDetailView(imageModel)
            }.disposed(by: disposeBag)
        
        imageSearchModels
            .asObservable()
            .withLatestFrom(meta) { ($0 , $1) }
            .map { [weak self] data in
                guard let self = self else { return false }
                return self.pagingAbleChecking(paingAble: data.1, totalCount:  data.0.count)
            }
            .subscribe(scrollPagingCall)
            .disposed(by: disposeBag)


        
        
        
        
        return .init(
            imageSearchModels: imageSearchModels.asDriverOnErrorNever() ,
            searchClear: searchClear.asDriverOnErrorNever(),
            outputError: errorTracker.asDriver()
        )
    }
}

extension MainViewModel : SearchDataProtocol , ScrollPagingProtocl{
    
    
    
}


