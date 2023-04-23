import XCTest
import Foundation

@testable import ImageFeed

final class ProfileControllerSp: ProfileViewProtocol {
    var presenter: ProfilePresenterProtocol?
    var isSetProfileAvatar: Bool = false
    var name: String = ""
    var login: String = ""
    var description: String = ""
    
    func setProfileDetails(_ name: String, _ loginName: String, _ description: String) {
        self.name = name
        self.login = loginName
        self.description = description
    }
    
    func setProfileAvatar(_ url: String) {
        isSetProfileAvatar = true
    }
    
    func switchToSplashViewController() {}
    
}
