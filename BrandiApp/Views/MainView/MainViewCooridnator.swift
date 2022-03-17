import Foundation
import UIKit

class MainViewCoordinator : BaseCoordinator {
 
    override func start() {
        let viewModel = MainViewModel(coordinator: self)
        let viewController = MainViewController(viewModel: viewModel)
       
        navigationController.pushViewController(viewController, animated: true)
//        
    }
}
