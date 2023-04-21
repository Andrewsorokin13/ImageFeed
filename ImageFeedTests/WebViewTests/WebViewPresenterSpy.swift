import Foundation
import XCTest

@testable import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var webViewDidLoadCall = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        webViewDidLoadCall = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        nil
    }
}
