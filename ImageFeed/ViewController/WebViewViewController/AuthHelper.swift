import Foundation

final class AuthHelper: AuthHelperProtocol {
    
    let config: AuthConfiguration
    
    init(configur: AuthConfiguration = .standart) {
        self.config = configur
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authURL() -> URL {
        var urlComponets = URLComponents(string: config.authURLString)!
        urlComponets.queryItems = [
            URLQueryItem(name: "client_id", value: config.accessKey),
            URLQueryItem(name: "client_secret", value: config.secretKey),
            URLQueryItem(name: "redirect_uri", value: config.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: config.accessScope)
        ]
        return urlComponets.url!
    }
}
