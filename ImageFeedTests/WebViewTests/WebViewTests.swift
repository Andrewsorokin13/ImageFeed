
import XCTest
import Foundation

@testable import ImageFeed

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad(){
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "WebViewViewController") as! WebViewViewController
        let preseter = WebViewPresenterSpy()
        viewController.presenter = preseter
        preseter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(preseter.webViewDidLoadCall)
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewControllerSp()
        let helper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: helper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.isRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let helper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: helper)
        let progress = 0.6
        
        let  shouldHideProgress = presenter.isHiddenProgress(for: Float(progress))
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        let helper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: helper)
        let progress = 1.0
        
        let shouldProgress = presenter.isHiddenProgress(for: Float(progress))
        
        XCTAssertTrue(shouldProgress)
    }
    
    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standart
        let autHelper = AuthHelper(configur: configuration)
        
        let url = autHelper.authURL()
        let urlString = url.absoluteString
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        let code = "my code"
        
        var urlComponets = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponets.queryItems = [URLQueryItem(name: "code", value: code )]
        
        let autHelper = AuthHelper()
        let url = urlComponets.url!
        
        let getCode = autHelper.code(from: url)
        
        XCTAssertEqual(getCode, code)
    }
    
}
