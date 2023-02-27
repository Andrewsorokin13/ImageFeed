import UIKit

extension UIImageView {
    static  func customImageView(name: String, cornerRadius: CGFloat ) -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: name)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = cornerRadius
        return image
    }
}
