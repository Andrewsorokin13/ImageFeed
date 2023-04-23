import XCTest
import Foundation

@testable import ImageFeed


final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewProtocol?
    var profileViewDidLoadCall: Bool = false
    var isLogout: Bool = false
    
    func viewDidLoad() {
        profileViewDidLoadCall = true
    }
    
    func logOut() {
        isLogout = true
    }
}
