//
//  CellProtocol.swift
//  BrandiApp
//
//  Created by 강지윤 on 2022/03/17.
//

import Foundation

protocol CellSettingProtocl {
    associatedtype U
    var item : U? { get set }
    
    func uiSetting()
    
    func itemSetting(item : U)
}
