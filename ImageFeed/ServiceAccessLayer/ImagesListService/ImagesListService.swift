import Foundation

final class ImagesListService {
    
    //MARK: - Private property
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private let token = OAuth2TokenStorage().token
    private let urlSession = URLSession.shared
    
    //MARK: - Static property
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    //MARK: - Public method
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        if nextPage == lastLoadedPage { return }
        task?.cancel()
        lastLoadedPage = nextPage
        guard let request = photoRequest(page: nextPage, perPage: 10, token: token) else { return }
        _ = object(for: request) { [weak self] result in
            guard let self = self else { return  }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let result = self.convertToPhoto(data: data)
                    self.photos.append(contentsOf: result)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["photos": result])
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        var request: URLRequest?
        assert(Thread.isMainThread)
        task?.cancel()
        if isLike {
            request = isLikedRequest(id: photoId, token: token, httpMethod: "DELETE")
        } else {
            request = isLikedRequest(id: photoId, token: token, httpMethod: "POST")
        }
        guard let request = request else { return  }
        print(request)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<Like, Error>) in
            guard let self = self else { return  }
            self.task = nil
            switch result {
            case .success:
                guard let index = self.photos.firstIndex(where: {$0.id == photoId}) else { return  }
                let photo = self.photos[index]
                let updatePhoto = Photo(id: photo.id,
                                        size: photo.size,
                                        createdAt: photo.createdAt,
                                        welcomeDescription: photo.welcomeDescription,
                                        thumbImageURL: photo.thumbImageURL,
                                        largeImageURL: photo.largeImageURL,
                                        isLiked: !photo.isLiked)
                self.photos[index] = updatePhoto
                completion(.success(self.photos[index]))
            case .failure(let failure):
                print(failure)
            }
        }
        self.task = task
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
        let formatter = ISO8601DateFormatter()
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
