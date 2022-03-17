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

class MainViewModel : ViewModelProtocol {
   
    
    
    struct Input {
        let searchAction : Driver<Void>
    }
    
    struct Output {
        let imageSearchModels : Driver<ImageSearchModels>
    }
    
    let errorTracker = ErrorTracker()
    let activityIndicator = ActivityIndicator()
    let networkAPI : NetworkServiceProtocol
    let coordinator : MainViewCoordinator
    let disposeBag : DisposeBag = DisposeBag()
    
    required init( networkAPI : NetworkServiceProtocol = NetworkingAPI.shared  , coordinator: MainViewCoordinator) {
        self.networkAPI = networkAPI
        self.coordinator = coordinator
    }
    
    
    func transform(input: Input) -> Output {
        let imageSearchModels = PublishSubject<ImageSearchModels>()
        
        
        input.searchAction
            .asObservable()
            .flatMap { [weak self] _ -> Observable<ImageSearchModels>  in
                guard let self = self else { return .never() }
                return self.getImageSearchModels(param: ImageSearchRequestModel(query: "강아지", sort: .accuracy, page: 1, size: 30), networkAPI: self.networkAPI)
                    .trackError(self.errorTracker)
                    .trackActivity(self.activityIndicator)
                    .catch{ error in
                         return .never()
                    }
            }
           
            .subscribe(imageSearchModels)
            .disposed(by: disposeBag)
        
        return .init(
            imageSearchModels: imageSearchModels.asDriverOnErrorNever()
        )
    }
}

extension MainViewModel : SearchDataProtocol{
    
    
    
}


