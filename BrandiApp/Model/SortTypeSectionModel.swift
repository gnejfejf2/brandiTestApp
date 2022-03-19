//
//  SortTypeSectionModel.swift
//  BrandiApp
//
//  Created by 강지윤 on 2022/03/19.
//

import RxDataSources

struct SortTypeSectionModel  {
    let name : String
    var items : [String]
}

extension SortTypeSectionModel : AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = String
    
    var identity: String {
        return name
    }
    
    
    init(original: SortTypeSectionModel, items: [String]) {
        self = original
        self.items = items
    }
}
