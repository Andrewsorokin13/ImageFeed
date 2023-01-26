import Foundation


// MARK: Constants property all app
struct Constants {
    
    struct StoryboardIdentifier {
        static let imageViewControllerID = "ImageViewController"
        static let segueGoToImageViewController = "goToImageViewController"
        static let imageCellReuseIdentifier = "ImagesListCell"
    }
    
    struct ImageButton {
        static let backButtonImage = "nav_back_button_white"
        static let shareButtonImage = "shared_button"
        static let logOutProfileImage = "ipad.and.arrow.forward"
        static let activeLikeButtonImage = "active"
        static let noActiveLikeButtonImage  = "noActive"
    }
    
    struct UnsplashAPI {
        static let accessKey = "wOxFRUzch7zue7IbCjOTpvZUEdrcvxSMGIKChG3bLGc"
        static let secretKey = "aVizbi_3xSwj0DB6jK0ntUu7CBpwDTXKN6Whatlzlio"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    }
}
