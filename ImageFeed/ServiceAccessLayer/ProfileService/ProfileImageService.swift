import Foundation

final class ProfileImageService {
    
    //MARK: - Private property
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    private var task: URLSessionTask?
    private var lastUsername:String?
    
    //MARK: - Private set property
    private (set) var avatarURL: String?
    
    //MARK: - Private property
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    //MARK: - Public method
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUsername == username { return }
        task?.cancel()
        lastUsername = username
        guard let request = profileImageRequest(username: username, token: oauth2TokenStorage.token) else { return  }
        let task = object(for: request)  { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                self.avatarURL = body.profileImage.small
                if let result = self.avatarURL  {
                    completion(.success(result))
                } else {
                    print("Error load profile image")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": avatarURL])
    }
    
    //MARK: - Private method
    private func object(for request: URLRequest, completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionDataTask {
        let decoder = JSONDecoder()
        return urlSession.objectTask(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result { try decoder.decode(UserResult.self, from: data) }
            }
            completion(response)
        }
    }
    
    private func profileImageRequest(username: String, token: String?) -> URLRequest? {
        guard let token = token else { return nil }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/users/\(username)"
        
        guard let url = urlComponents.url else { return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
