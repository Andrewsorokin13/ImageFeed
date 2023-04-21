import Foundation


// MARK: Constants property all app
struct Constants {
    
    struct StoryboardIdentifier {
        static let imageViewControllerID = "ImageViewController"
        static let segueGoToImageViewController = "goToImageViewController"
        static let imageCellReuseIdentifier = "ImagesListCell"
        static let segueGoToWebViewController = "ShowWebView"
        static let imagesListViewController = "ImagesListViewController"
        static let profileViewController = "ProfileViewController"
    }
    
    struct ImageButton {
        static let backButtonImage = "nav_back_button_white"
        static let shareButtonImage = "shared_button"
        static let logOutProfileImage = "ipad.and.arrow.forward"
        static let activeLikeButtonImage = "active"
        static let noActiveLikeButtonImage  = "noActive"
    }
    
    struct BarButtonImage {
        static let profileBarButtonImage = "tab_profile_active"
        static let imagelistBarButtonImage = "tab_editorial_active"
    }
}

