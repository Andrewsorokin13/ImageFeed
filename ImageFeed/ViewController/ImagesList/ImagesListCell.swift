import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: IBOutlet
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK: Private IBOutlet
    @IBOutlet private weak var gradientView: UIView!
    
    //MARK: Delegate
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCell.layer.masksToBounds = true
        imageCell.layer.cornerRadius = 16
        gradientView.backgroundColor = .clear
        likeButton.accessibilityIdentifier = "likeButton"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked(_ sender: UIButton) {
        self.delegate?.imageListCellDidTapLike(self)
    }
    
    func setLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: Constants.ImageButton.activeLikeButtonImage) : UIImage(named: Constants.ImageButton.noActiveLikeButtonImage)
        likeButton.imageView?.image = likeImage
        likeButton.setImage(likeImage, for: .normal)
    }
}
