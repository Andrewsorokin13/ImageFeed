import XCTest
import Foundation

@testable import ImageFeed

final class ImageListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad(){
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: Constants.StoryboardIdentifier.imagesListViewController) as! ImagesListViewController
        let presenter = ImageListPresenterSp()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.imageListViewDidLoadCall)
    }
    
    func testPresenterfetchPhotosNextPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: Constants.StoryboardIdentifier.imagesListViewController) as! ImagesListViewController
        let presenter = ImageListPresenterSp()
        viewController.presenter = presenter
        presenter.view = viewController

        _ = viewController.view
        
        XCTAssertTrue(presenter.isRequstNextPage)
    }

    func testTablViewRowsCount() {
        let viewController = ImageListControllerSp()
        let presenter = ImageListPresenterSp()
        viewController.presenter =  presenter
        presenter.view = viewController
        
        
  
        XCTAssertEqual( presenter.tablViewRowsCount(), 1)
    }
}
