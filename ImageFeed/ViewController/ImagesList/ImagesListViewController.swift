import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: Private property
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    // MARK: private IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    // MARK: prepare ImageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StoryboardIdentifier.segueGoToImageViewController {
            let viewController = segue.destination as! ImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: Configuration cell to ImagesListViewController
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        cell.imageCell.image = image
        cell.dateLable.text = Date().dateTimeString
        cell.selectionStyle = .none
        let likeImage = setImageLikeButton(with: indexPath)
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    // MARK: private func
    private func setImageLikeButton(with indexPath: IndexPath) -> UIImage {
        if indexPath.row % 2 == 0 {
            guard let image = UIImage(named: Constants.ImageButton.activeLikeButtonImage) else { return UIImage()}
            return image
        } else {
            guard let image = UIImage(named: Constants.ImageButton.noActiveLikeButtonImage) else { return UIImage()}
            return image
        }
    }
}

// MARK: Conform UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifier.imageCellReuseIdentifier, for: indexPath)
        guard let imageCell = cell as? ImagesListCell else {
            print("Error load table view cell ")
            return UITableViewCell()
        }
        configCell(for: imageCell, with: indexPath)
        return imageCell
    }
}


// MARK: Conform UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: Constants.StoryboardIdentifier.segueGoToImageViewController, sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return 0 }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
