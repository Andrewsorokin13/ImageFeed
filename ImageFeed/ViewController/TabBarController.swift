import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Override methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController =  storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIdentifier.imagesListViewController)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: Constants.BarButtonImage.profileBarButtonImage),
            selectedImage: nil
        )
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
