import Foundation

final class UserDefaultsManager {
    
    private let userDefaults = UserDefaults.standard
    
    func checkCatalogFilter() -> String? {
        userDefaults.string(forKey: SelectedFilterEnum.key.rawValue)
    }
    
    func saveCatalogFilterByName() {
        userDefaults.set(SelectedFilterEnum.byNameValue.rawValue, forKey: SelectedFilterEnum.key.rawValue)
    }
    
    func saveCatalogFilterByCount() {
        userDefaults.set(SelectedFilterEnum.byCountValue.rawValue, forKey: SelectedFilterEnum.key.rawValue)
    }
    
}
