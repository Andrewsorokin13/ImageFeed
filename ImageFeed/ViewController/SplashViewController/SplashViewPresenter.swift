import Foundation

final class SplashViewPresenter {
    
    //MARK: - private property
    private  let profileService = ProfileService.shared
    private  let oauth2TokenStorage = OAuth2TokenStorage()
    private  let oauth2Service = OAuth2Service()
    private  let imagesListService = ImagesListService.shared
    
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
                self.vc?.switchToTabBarController()
            case .failure(let error):
                print("This error ",error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func verificationToken() {
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3){
                self.vc?.switchToTabBarController()
            }
        } else {
            vc?.showAuthViewController()
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.imagesListService.fetchPhotosNextPage()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.alertPresenter?.creationAlert(title: "Что-то пошло не так", messange: "Не удалось войти в систему", completion: nil)
                break
            }
        }
    }
}
