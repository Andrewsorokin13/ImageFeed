import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    //MARK: - Private method
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    //MARK: - Public Static method
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}

