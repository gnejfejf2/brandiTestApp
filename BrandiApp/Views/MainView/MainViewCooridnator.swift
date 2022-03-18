import Foundation
import UIKit

class MainViewCoordinator : BaseCoordinator {
 
    override func start() {
        let viewModel = MainViewModel(builder: .init(coordinator: self))
        let viewController = MainViewController(viewModel: viewModel)
       
        navigationController.pushViewController(viewController, animated: true)
//        
    }
    
    func openDetailView(_ imageSearchModel : ImageSearchModel){
        let coordinator = DetailViewCoordinator(navigationController: navigationController)
        coordinator.imageSearchModel = imageSearchModel
        coordinator.start()
    }
    
    
}
