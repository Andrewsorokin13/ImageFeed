import UIKit

class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet private weak var gradientView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCell.layer.masksToBounds = true
        imageCell.layer.cornerRadius = 16
        gradientView.backgroundColor = .clear
       
    }
}
