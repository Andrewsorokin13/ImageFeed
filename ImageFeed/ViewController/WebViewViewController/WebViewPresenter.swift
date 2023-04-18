import Foundation

final class WebViewPresenter {
    
   weak var vc: WebViewViewController?
    
    init(vc: WebViewViewController? = nil) {
        self.vc = vc
    }
    
    
     func updateProgress() {
        guard let vc = vc else { return  }
        vc.progressView.progress = Float(vc.webView.estimatedProgress)
        vc.progressView.isHidden = fabs(vc.webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    func urlRequest() -> URLRequest? {
        var urlComponets = URLComponents(string: Constants.UnsplashAPI.authorizURL)
        urlComponets?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.UnsplashAPI.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.UnsplashAPI.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.UnsplashAPI.redirectURI),
            URLQueryItem(name: "response_type", value: Constants.UnsplashAPI.code),
            URLQueryItem(name: "scope", value: Constants.UnsplashAPI.scope)
        ]
        guard let url = urlComponets?.url else { return nil }
        return URLRequest(url: url)
    }
    
     func didTapBackButton() {
         vc?.dismiss(animated: true, completion: nil)
    }
}
