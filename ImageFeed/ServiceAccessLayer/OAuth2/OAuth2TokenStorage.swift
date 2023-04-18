import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage  {
    //MARK: - Private property
    private let keychainWrapper = KeychainWrapper.standard
    private let codeKey = "code"
    
    //MARK: - Calculate  property
    var token: String? {
        get {
            keychainWrapper.string(forKey: codeKey )
        }
        set {
            guard let newValue = newValue else { return  }
            keychainWrapper.set(newValue, forKey: codeKey)
        }
    }
    
    var deleteToken: Bool {
        return  keychainWrapper.removeObject(forKey: codeKey)
    }
    
    
}

