import UIKit

extension UIButton {
    static func customButton(image: UIImage, target: Any?, action: Selector?, tinColor: UIColor) -> UIButton {
        let button = UIButton.systemButton(with: image , target: target, action: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = tinColor
        return button
    }
}
