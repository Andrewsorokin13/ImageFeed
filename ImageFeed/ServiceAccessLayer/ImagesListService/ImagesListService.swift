import Foundation

final class ImagesListService {
    
    //MARK: - Private property
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private let tokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private  let formatter = ISO8601DateFormatter()
    
    //MARK: - Static property
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    
    //MARK: - Public method
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard task == nil else { return }
        if nextPage == lastLoadedPage {
            task?.cancel()
            return
        }
        lastLoadedPage = nextPage
        guard let token = tokenStorage.token else { return }
        guard let request = photoRequest(page: nextPage, perPage: 10, token: token) else { return }
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return  }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let result = self.convertToPhoto(data: data)
                    self.photos.append(contentsOf: result)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["photos": result])
                    self.task = nil
                }
            case .failure:
                assertionFailure()
                self.task = nil
            }
        }
        self.task = task
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        var request: URLRequest?
        assert(Thread.isMainThread)
        guard task == nil else { return }
        guard let token = tokenStorage.token else { return }
        request = isLikedRequest(id: photoId, token: token, httpMethod: isLike ? "DELETE": "POST")
        guard let request = request else { return  }
        let task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    guard let index = self.photos.firstIndex(where: {$0.id == photoId}) else { return  }
                    var photo = self.photos[index]
                    photo.isLiked.toggle()
                    self.photos[index] = photo
                    completion(.success(()))
                    self.task = nil
                } else {
                    completion(.failure(error!))
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(error!))
            }
        })
        self.task = task
        task.resume()
    }
    
    //MARK: - Private method
    private func object(for request: URLRequest, completion: @escaping (Result<[PhotoResult], Error>) -> Void) -> URLSessionDataTask {
        let decoder = JSONDecoder()
        return urlSession.objectTask(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<[PhotoResult], Error> in
                Result {
                    try decoder.decode([PhotoResult].self, from: data)
                }
            }
            completion(response)
        }
    }
    
    private func convertToPhoto(data: [PhotoResult]) -> [Photo] {
        return  data.map { data in
            return Photo(
                id: data.id,
                size: CGSize(width: data.width, height: data.height),
                createdAt: formatter.date(from: data.createdAt ?? ""),
                welcomeDescription: data.description,
                thumbImageURL: data.url.thumb,
                largeImageURL: data.url.full,
                isLiked: data.usersLiked
            )
        }
    }
    
    private func photoRequest(page:Int , perPage: Int, token: String?) -> URLRequest? {
        guard let token = token else { return nil }
        var request = URLRequest.makeHTTPRequest(path: "/photos?"
                                                 + "page=\(page)"
                                                 + "&&per_page=\(perPage)",
                                                 httpMethod: "GET")
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func isLikedRequest(id: String, token: String?,httpMethod: String ) -> URLRequest? {
        guard let token = token else { return nil }
        var request = URLRequest.makeHTTPRequest(path: "/photos/"
                                                 + "\(id)"
                                                 + "/like",
                                                 httpMethod: "\(httpMethod)")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
