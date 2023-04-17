import UIKit
import WebKit
import Kingfisher


final class ProfilePresenter {
    
    //MARK: - private property
    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var alertPresenter: AlertPresenter?
    
    weak var vc: ProfileViewController?
    
    init(vc: ProfileViewController? = nil) {
        self.vc = vc
    }
    
    // MARK: -  methods
    func updateAvatar(avatarImageView: UIImageView) {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else { return  }
        avatarImageView.kf.setImage(with: url)
    }
    
    func updateProfileDetails(nameLable: UILabel, loginNameLabel: UILabel, descriptionLable: UILabel ) {
        guard let profile = profileService.profile else { return  }
        nameLable.text = profile.name
        loginNameLabel.text = ("@\(profile.loginName)")
        descriptionLable.text = profile.bio
    }
    
    func logOut() {
        if oauth2TokenStorage.deleteToken {
            self.cleanCookie()
            self.switchToSplashViewController()
        } else {
            showAlert()
        }
    }
    
    // MARK: -  private  methods
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let vc = SplashViewController()
        window.rootViewController = vc
    }
    
    private func showAlert() {
        self.alertPresenter?.creationAlert(title: "Что-то пошло не так", messange: "Не удалось выйти из аккаунта", completion: nil)
    }
    
    private func cleanCookie() {
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
