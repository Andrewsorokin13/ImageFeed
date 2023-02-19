import Foundation

//MARK: - WebViewViewController URLRequest
extension WebViewViewController {
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
}
