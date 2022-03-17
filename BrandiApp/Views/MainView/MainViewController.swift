//
//  MainViewController.swift
//  BrandiApp
//
//  Created by 강지윤 on 2022/03/17.
//

import Foundation
import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxRelay
import RxGesture


class MainViewController: SuperViewControllerSetting<MainViewModel> {
    lazy var searchBar = UISearchBar().then{
        $0.placeholder = "검색어를 입력해주세요."
        $0.searchBarStyle = .minimal
        
        $0.searchTextField.layer.borderColor = UIColor.gray.cgColor
        $0.searchTextField.layer.cornerRadius = 10
        $0.searchTextField.layer.borderWidth = 1
        $0.searchTextField.largeContentImage?.withTintColor(.gray) // 왼쪽 돋보기 모양 커스텀
        $0.searchTextField.borderStyle = .none // 기본으로 있는 회색배경 없애줌
        $0.searchTextField.leftView?.tintColor = .gray
        

    }
    
    lazy var searchImageCollectionView : UICollectionView = {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.33)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: compositionalLayout)
        collectionView.backgroundColor = .primaryColorReverse
        collectionView.indicatorStyle = .white
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.id)
        return collectionView
    }()
    
   
    override func uiDrawing() {
        view.addSubview(searchBar)
        view.addSubview(searchImageCollectionView)
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        searchImageCollectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom)
//            make.bottom.equalTo()
        }
        
    }
    
    override func viewModelBinding() {
        let searchAction = PublishSubject<Void>()
        
        
        let output = viewModel.transform(input: .init(searchAction: searchAction.asDriverOnErrorNever()))
        
        
        
        output.imageSearchModels
            .drive(searchImageCollectionView.rx.items(cellIdentifier: ImageCollectionViewCell.id, cellType: ImageCollectionViewCell.self)){(index , element , cell) in
                
                cell.itemSetting(item: element)
                
            }
            .disposed(by: disposeBag)
        
        
        searchAction.onNext(())
    }
    

}
