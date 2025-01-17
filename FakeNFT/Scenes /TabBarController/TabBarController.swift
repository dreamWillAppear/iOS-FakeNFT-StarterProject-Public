import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let profileTabBarItem =  UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "rectangle.stack.fill"),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "cart.fill"),
        tag: 2
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = tabBar.standardAppearance

        let profileController = ProfileViewController()
        
        let catalogPresenter = CatalogPresenter(view: nil)
        let catalogViewController = CatalogViewController(presenter: catalogPresenter)
        catalogPresenter.setView(catalogViewController)
        
        let cartController = CartViewController()
        let navigationCartViewController = UINavigationController(rootViewController: cartController)
        
        let statisticsController = UINavigationController(rootViewController: RatingTableViewController())
        
        profileController.tabBarItem = profileTabBarItem
        navigationCartViewController.tabBarItem = cartTabBarItem
        catalogViewController.tabBarItem = catalogTabBarItem
        statisticsController.tabBarItem = statisticsTabBarItem
        
        appearance.stackedLayoutAppearance.normal.iconColor = .ypBlack
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ypBlack as Any]
        tabBar.standardAppearance = appearance
        tabBar.backgroundColor = .ypWhite

        viewControllers = [profileController, catalogViewController, navigationCartViewController, statisticsController]
        
        selectedIndex = 0
    }
}
