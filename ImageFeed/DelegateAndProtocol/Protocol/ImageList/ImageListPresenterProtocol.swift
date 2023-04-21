import Foundation

protocol ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func imageListCellDidTapLike(_ cell: ImagesListCell, _ indexPath: IndexPath)
    func getPhotoForIndexPath(_ indexPath: IndexPath) -> Photo
    func tablViewRowsCount() -> Int
    func fetchPhotosNextPage()
}
