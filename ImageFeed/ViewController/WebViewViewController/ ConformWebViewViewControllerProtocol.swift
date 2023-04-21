import Foundation


//MARK: - ConformWebViewViewControllerProtocol
extension WebViewViewController {
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    
    func load(request: URLRequest) {
        webView.load(request)
    }
}
