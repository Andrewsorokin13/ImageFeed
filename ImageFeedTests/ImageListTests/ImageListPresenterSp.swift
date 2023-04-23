import XCTest
import Foundation

@testable import ImageFeed


final class ImageListPresenterSp: ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var imageListViewDidLoadCall: Bool = false
    var isRequstNextPage: Bool = false
    var imagePhoto: [Photo] = []

    
    var count = 0
    func viewDidLoad() {
        imageListViewDidLoadCall = true
        fetchPhotosNextPage()
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell, _ indexPath: IndexPath) {
    }
    
    func getPhotoForIndexPath(_ indexPath: IndexPath) -> ImageFeed.Photo {
        imagePhoto[indexPath.row]
    }
    
    func tablViewRowsCount() -> Int {
        let testModel = [Photo(id: "", size: CGSize(), createdAt: Date(), welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: false) ]
        return testModel.count
    }
    
    func fetchPhotosNextPage() {
        isRequstNextPage = true
    }
}
