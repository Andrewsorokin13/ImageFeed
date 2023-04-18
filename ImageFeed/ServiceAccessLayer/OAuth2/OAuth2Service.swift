import Foundation

final class OAuth2Service {
    
    //MARK: - Private property
    private let urlSession = URLSession.shared
    private let oAuthStorage = OAuth2TokenStorage()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    //MARK: - Private set property
    private (set) var authToken: String? {
        get {
            return oAuthStorage.token
        }
        set {
            oAuthStorage.token = newValue
        } }
    
    //MARK: - Public property
    static let shared = OAuth2Service()
    
    //MARK: - Public method
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        guard let request = authTokenRequest(code: code) else { return  }
        _ = object(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let auth = body.accessToken
                    self.oAuthStorage.token = auth
                    self.task = nil
                    completion(.success(auth))
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
    }
    
    //MARK: - Private method
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionDataTask {
        let decoder = JSONDecoder()
        return urlSession.objectTask(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.UnsplashAPI.accessKey)"
            + "&&client_secret=\(Constants.UnsplashAPI.secretKey)"
            + "&&redirect_uri=\(Constants.UnsplashAPI.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}
