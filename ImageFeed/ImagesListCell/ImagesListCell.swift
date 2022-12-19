import UIKit

class ImagesListCell: UITableViewCell {
    
    // MARK: Static reuse Identifier
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: IBOutlet
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK: Private IBOutlet
    @IBOutlet private weak var gradientView: UIView!
    
    // MARK: Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCell.layer.masksToBounds = true
        imageCell.layer.cornerRadius = 16
        gradientView.backgroundColor = .clear
    }
}
