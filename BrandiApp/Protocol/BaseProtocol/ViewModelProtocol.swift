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


//Builder를 이용하여 이전의 코디네이터에서 받아오는 데이터를 추상화 작업을 처리하고
//사용할때는 빌더에서 꺼내서 사용한다. or 빌더에서 꺼내서 데이터를 넣어줘도된다 뭐가 좋은지는 모르겠네
//뷰모델 프로토콜 선언시 코디네이터 -> 매니저 순서로 선언하고
//기타 값이 필요한경우 disposebag 아래에 작성한다.
//let networkAPI : NetworkingAPI
//let disposeBag = DisposeBag()
//let repo : Repo
protocol ViewModelBuilderProtocol {
    associatedtype Input
    associatedtype Output
    associatedtype Builder
    var networkAPI : NetworkServiceProtocol { get }
    var builder : Builder { get }
    var disposeBag : DisposeBag { get }
    
    init(networkAPI : NetworkServiceProtocol , builder : Builder)
    
    func transform(input: Input) -> Output
   
}
