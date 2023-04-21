import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Override methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imageListViewController =  storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIdentifier.imagesListViewController) as? ImagesListViewController
        else { return }
        let presenter = ImageListPresenter()
        imageListViewController.presenter = presenter
        presenter.view = imageListViewController
        
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: Constants.BarButtonImage.profileBarButtonImage),
            selectedImage: nil
        )
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
