import XCTest
import Foundation

@testable import ImageFeed

final class WebViewControllerSp: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var isRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        isRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
