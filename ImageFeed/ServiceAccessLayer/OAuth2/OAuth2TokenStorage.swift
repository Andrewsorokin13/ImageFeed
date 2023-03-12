import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage  {
    //MARK: - Private property
    private let keychainWrapper = KeychainWrapper.standard
    
    //MARK: - Calculate  property
    var token: String? {
        get {
            keychainWrapper.string(forKey: "code")
        }
        set {
            guard let newValue = newValue else { return  }
            keychainWrapper.set(newValue, forKey: "code")
        }
    }
}

