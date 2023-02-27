
import UIKit

extension UILabel {
    static  func customLable(textColor: UIColor, font: UIFont?, text: String) -> UILabel {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = textColor
        lable.font = font
        lable.text = text
        return lable
    }
}
