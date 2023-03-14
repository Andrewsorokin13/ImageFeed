import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage  {
    //MARK: - Private property
    private let keychainWrapper = KeychainWrapper.standard
    private let codekey = "code"
    
    //MARK: - Calculate  property
    var token: String? {
        get {
            keychainWrapper.string(forKey: codekey )
        }
        set {
            guard let newValue = newValue else { return  }
            keychainWrapper.set(newValue, forKey: codekey)
        }
    }
}

