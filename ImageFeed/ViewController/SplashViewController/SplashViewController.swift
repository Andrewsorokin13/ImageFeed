import UIKit


final class SplashViewController: UIViewController {
    
    //MARK: - private property
    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    
    private var test = ProfileImageService.shared
    private var alertPresenter: AlertPresenter?
   
    private lazy var imageLogo: UIImageView  = {
        UIImageView.customImageView(
            name: "LogoLaunchScreen",
            cornerRadius: 0
        )
    }()
   
    // MARK: - Override methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.verificationToken()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        setConstraint()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK: - Private methods
    
    private func setConstraint() {
        view.backgroundColor = .YPBlack
        view.addSubview(imageLogo)
        
        imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageLogo.heightAnchor.constraint(equalToConstant: 77).isActive = true
        imageLogo.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func verificationToken() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            if oauth2TokenStorage.token != nil {
                switchToTabBarController()
                guard let token = oauth2TokenStorage.token else { return  }
                fetchProfile(token: token)
            } else {
                showAuthViewController()
            }
        }
    }
    
    private func showAuthViewController() {
        let authVC = AuthViewController()
        authVC.delegate = self
        authVC.modalPresentationStyle = .fullScreen
        show(authVC, sender: self)
    }
}

//MARK: - Conform AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let token):
                self.fetchProfile(token: token)
                self.switchToTabBarController()
            case .failure(let error):
                print("This error ",error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure (let error):
                print(error)
                UIBlockingProgressHUD.dismiss()
                self.alertPresenter?.creationAlert(title: "Что-то пошло не так", messange: "Не удалось войти в систему", completion: nil)
                break
            }
        }
    }
}
