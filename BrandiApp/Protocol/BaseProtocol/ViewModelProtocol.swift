import Foundation
import RxSwift

//뷰모델 프로토콜 선언시 코디네이터 -> 매니저 순서로 선언하고
//기타 값이 필요한경우 disposebag 아래에 작성한다.
//var coordinator : RepoDetailViewCoordinator?
//let networkAPI : NetworkingAPI
//let disposeBag = DisposeBag()
//let repo : Repo
protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    associatedtype U
    var networkAPI : NetworkServiceProtocol { get }
    var coordinator : U { get }
    var disposeBag : DisposeBag { get }
    
    init(networkAPI : NetworkServiceProtocol , coordinator : U)
    
    func transform(input: Input) -> Output
   
}


