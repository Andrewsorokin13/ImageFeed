import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: Private property
    private var photos: [Photo] = []
    private let imageListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenter?
    
    // MARK: private IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        alertPresenter = AlertPresenter(viewController: self)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                                                          object: nil,
                                                                          queue: .main,
                                                                          using: { [weak self] _ in
            guard let self = self else { return  }
            self.updateTableViewAnimated()
        })
        imageListService.fetchPhotosNextPage()
    }
    
    // MARK: prepare ImageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StoryboardIdentifier.segueGoToImageViewController {
            let viewController = segue.destination as! ImageViewController
            let indexPath = sender as! IndexPath
            let photo = photos[indexPath.row]
            let imageURL = URL(string: photo.largeImageURL)
            guard let url = imageURL else { return }
            viewController.fullImageURL = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func updateTableViewAnimated() {
        let lastCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if lastCount != newCount {
            tableView.performBatchUpdates {
                let indexPath = (lastCount..<newCount).map { index in
                    IndexPath(row: index, section: 0)
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            }completion: { _ in }
        }
    }
}

//MARK: Configuration cell to ImagesListViewController
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let likeImage = setImageLikeButton(with: indexPath, isLiked: photo.isLiked)
        guard let imageURL = URL(string: photo.thumbImageURL) else { return }
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(with: imageURL) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.imageCell.kf.indicatorType = .none
        }
        cell.dateLable.text =  photo.createdAt?.dateTimeString
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.selectionStyle = .none
    }
    
    // MARK: private func
    private func setImageLikeButton(with indexPath: IndexPath, isLiked: Bool) -> UIImage {
        let image = isLiked ? UIImage(named: Constants.ImageButton.activeLikeButtonImage) : UIImage(named: Constants.ImageButton.noActiveLikeButtonImage)
        guard let image = image else { return UIImage() }
        return image
    }
}

// MARK: Conform UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifier.imageCellReuseIdentifier, for: indexPath)
        guard let imageCell = cell as? ImagesListCell else {
            print("Error load table view cell ")
            return UITableViewCell()
        }
        imageCell.delegate = self
        configCell(for: imageCell, with: indexPath)
        return imageCell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath ) {
        if  indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextPage()
        } else { return }
    }
}


// MARK: Conform UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: Constants.StoryboardIdentifier.segueGoToImageViewController, sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

//MARK: Conform ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
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
                    self.alertPresenter?.creationAlert(title: "Что-то пошло не так", messange: "Не удалось войти в систему", completion: nil)
                }
            }
        }
    }
}
