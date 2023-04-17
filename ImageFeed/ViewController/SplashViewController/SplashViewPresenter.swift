import Foundation

final class SplashViewPresenter {
    
    //MARK: - private property
    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    private let imagesListService = ImagesListService.shared
    
    private  var alertPresenter: AlertPresenter?
    
    //MARK: - weak var
    weak var vc: SplashViewController?
    
    //MARK: - init
    init(vc: SplashViewController? = nil) {
        self.vc = vc
    }
    
    //MARK: - method
    
    func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let token):
                    self.fetchProfile(token: token)
            case .failure:
                assertionFailure()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func verificateToken() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            guard let self = self else { return }
            if let token = self.oauth2Service.authToken {
                self.fetchProfile(token: token)
            } else {
                self.vc?.showAuthViewController()
            }
        }
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                    self.vc?.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.alertPresenter?.creationAlert(title: "Что-то пошло не так", messange: "Не удалось войти в систему", completion: nil)
                break
            }
        }
    }
}
