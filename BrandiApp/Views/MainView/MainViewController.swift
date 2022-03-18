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
    lazy var searchBar = DoneSearchBar().then{
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
        }
        
    
        
        
    }
    
    override func uiSetting() {
        
        searchImageCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

    }
    
    override func viewModelBinding() {
        let searchAction = searchBar.rx.text
            .orEmpty
            .filter { $0 != "" }
            .asDriverOnErrorNever()
            //필수 조건 2번  UISearchBar에 문자를 입력 후 1초가 지나면 자동으로 검색이 됩니다.
            .debounce(.seconds(1))
            .distinctUntilChanged()
        
        let bottomScrollTriger = searchImageCollectionView.rx
            .reachedBottom(offset: 0)
            .asDriverOnErrorNever()
     
        let cellClick = searchImageCollectionView.rx.modelSelected(ImageSearchModel.self).asDriverOnErrorNever()
        
        let output = viewModel.transform(input: .init(
            searchAction: searchAction ,
            bottomScrollTriger: bottomScrollTriger,
            cellClick: cellClick
        ))
        
        
        
        output.imageSearchModels
            .drive(searchImageCollectionView.rx.items(cellIdentifier: ImageCollectionViewCell.id, cellType: ImageCollectionViewCell.self)){(index , element , cell) in
                cell.itemSetting(item: element)
            }
            .disposed(by: disposeBag)
        
        output.searchClear
            .drive{ [weak self] _ in
                guard let self = self else { return }
                return self.searchImageCollectionView.setContentOffset(.zero, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.outputError
            .drive(onNext: { [ weak self] value in
                guard let self = self else { return }
                let alert = UIAlertController(title: "오류", message: value.localizedDescription , preferredStyle: .alert)
                let success = UIAlertAction(title: "확인", style: .default)
                alert.addAction(success)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
     
    }
    

}
extension MainViewController : UICollectionViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}




