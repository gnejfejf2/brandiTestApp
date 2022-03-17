//
//  SearchDataProtocol.swift
//  BrandiApp
//
//  Created by 강지윤 on 2022/03/17.
//

import Foundation
import RxSwift
protocol SearchDataProtocol {
    func getImageSearchModels(param : ImageSearchRequestModel , networkAPI : NetworkServiceProtocol) -> Single<ImageSearchModels>
}



extension SearchDataProtocol {
    func getImageSearchModels(param : ImageSearchRequestModel , networkAPI : NetworkServiceProtocol) -> Single<ImageSearchModels> {
        networkAPI.request(type: ImageSearchResponseModel.self, .search(parmas: param))
            .map{ $0.documents }
    }
    
}
