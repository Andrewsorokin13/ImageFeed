import Foundation

final class OAuth2TokenStorage  {
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: "code")
        }
        set {
            userDefaults.set(newValue, forKey: "code")
        }
    }
}
