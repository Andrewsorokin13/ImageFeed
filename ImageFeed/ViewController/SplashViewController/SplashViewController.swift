import UIKit


final class SplashViewController: UIViewController {
    
    // MARK: - private properrty
    private var presenter: SplashViewPresenter!
    
    private lazy var imageLogo: UIImageView  = {
        UIImageView.customImageView(
            name: "LogoLaunchScreen",
            cornerRadius: 0
        )
    }()
    
    // MARK: - Override methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter.verificateToken()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SplashViewPresenter(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        setConstraint()
        
    }
    
    // MARK: - public methods
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    func showAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authVC = storyboard.instantiateViewController(identifier: "AuthViewController") as? AuthViewController
        guard let authVC = authVC else { fatalError("Error loading WebViewViewController") }
        authVC.delegate = self
        authVC.modalPresentationStyle = .fullScreen
        show(authVC, sender: self)
    }
}

//MARK: - Conform AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.presenter.fetchOAuthToken(code)
        }
    }
}



private extension SplashViewController {
    private func setConstraint() {
        view.backgroundColor = .YPBlack
        view.addSubview(imageLogo)
        
        NSLayoutConstraint.activate([
            imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageLogo.heightAnchor.constraint(equalToConstant: 70),
            imageLogo.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
