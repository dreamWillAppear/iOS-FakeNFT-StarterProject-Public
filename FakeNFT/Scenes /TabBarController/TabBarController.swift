import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    private let statisticTabBarItem = UITabBarItem(title: NSLocalizedString("Tab.statistic", comment: ""), image: UIImage(systemName: "flag.2.crossed.fill"), tag: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let statisticVC = RatingTableViewController()
        let navStatisticVC = UINavigationController(rootViewController: statisticVC)
        navStatisticVC.tabBarItem = statisticTabBarItem
        
        viewControllers = [catalogController, navStatisticVC]

        view.backgroundColor = .systemBackground
    }
}
