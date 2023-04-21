import Foundation

final class ImageListPresenter: ImageListPresenterProtocol {
    
    private var photos: [Photo] = []
    private let imageListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private var alertPreseter: AlertPresenter?
    
    weak var view: ImagesListViewControllerProtocol?
    
    
    func viewDidLoad() {
        imageListServiceObserved()
        fetchPhotosNextPage()
        self.alertPreseter = view?.alertPresenter
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell, _ indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result  in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success :
                    self.photos = self.imageListService.photos
                    cell.setLiked(isLiked: self.photos[indexPath.row].isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.alertPreseter?.creationAlert(title: "Что-то пошло не так", messange: "Не удалось войти в систему", completion: nil)
                }
            }
        }
    }
    
    func getPhotoForIndexPath(_ indexPath: IndexPath) -> Photo {
        return photos[indexPath.row]
    }
    
    func tablViewRowsCount() -> Int {
        return photos.count
    }
    
    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    private func imageListServiceObserved() {
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                                                          object: nil,
                                                                          queue: .main,
                                                                          using: { [weak self] _ in
            guard let self = self else { return  }
            self.updateTableViewAnimated()
        })
    }
    
    private func updateTableViewAnimated() {
        let lastPhoto = photos.count
        let newPhoto = imageListService.photos.count
        photos = imageListService.photos
        if lastPhoto != newPhoto {
            let indexPath = indexPathToAnimatedTableView(lastPhoto, newPhoto)
            view?.updateTableViewAnimated(indexPath)
        }
    }
    
    private func indexPathToAnimatedTableView(_ last: Int,_ new: Int) -> [IndexPath] {
        return (last..<new).map { item in
            IndexPath(row: item, section: 0)
        }
    }
}
