import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let usersLiked: Bool
    let url: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description = "description"
        case usersLiked = "liked_by_user"
        case url = "urls"
    }
}

typealias Photos = [Photo]

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}


struct Like: Codable {
    let photo: PhotoResult?
}

