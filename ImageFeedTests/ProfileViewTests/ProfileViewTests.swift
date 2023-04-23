import XCTest
import Foundation

@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad(){
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.profileViewDidLoadCall)
    }
    
    func testSetProfileAvatar() {
        let viewController = ProfileControllerSp()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
    
        presenter.view?.setProfileAvatar("")
        
        XCTAssertTrue(viewController.isSetProfileAvatar)
    }
    
    func testSetProfileDetails() {
        let viewController = ProfileControllerSp()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.view?.setProfileDetails("one", "two", "three")
        
        XCTAssertEqual(viewController.name, "one")
        XCTAssertEqual(viewController.login, "two")
        XCTAssertEqual(viewController.description, "three")
    }
    
    func testCallLogout() {
        let viewController = ProfileControllerSp()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.logOut()
        
        XCTAssertTrue(presenter.isLogout)
    }
}
