import Foundation

final class ProfileService {
    
    //MARK: - Private property
    private let profileImageService = ProfileImageService.shared
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    //MARK: - Private set property
    private(set) var profile: Profile?
    
    //MARK: - Static property
    static let shared = ProfileService()
    
    //MARK: - Public method
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        guard let request = profileRequest(authToken: token) else { return }
        let task = object(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    self.fetchProfileUsername(username: body.username)
                    self.profile = self.convertToProfile(profileResult: body)
                    completion(.success(body))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    //MARK: - Private method
    private func fetchProfileUsername(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard self != nil else  { return }
            switch result {
            case .success:
                print("Request completed successfully")
            case .failure(let error):
                print("Error to url",error)
            }
        }
    }
    
    private func convertToProfile(profileResult: ProfileResult) -> Profile {
        return Profile(username: profileResult.username, name: profileResult.firstName, loginName: profileResult.id, bio: profileResult.bio ?? "No bio")
    }
    
    private func object(for request: URLRequest, completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionDataTask {
        let decoder = JSONDecoder()
        return urlSession.objectTask(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
    
    private func profileRequest(authToken: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/me"
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}

