import Foundation


final class ProfilePresenter: ProfilePresenterProtocol {
    
    //MARK: - private property
    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private var alertPresenter: AlertPresenter?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    weak var view: ProfileViewProtocol?
    
    // MARK: -  methods
    func viewDidLoad() {
        guard let profile = profileService.profile else { return }
        profileImageServiceObserved()
        loadAvatar()
        view?.setProfileDetails(profile.name, profile.loginName, profile.bio)
    }
    
    
    func logOut() {
        if oauth2TokenStorage.deleteToken {
            ClearCookie.cleanCookie()
            view?.switchToSplashViewController()
        } else {
            showAlert()
        }
    }
    
    private func loadAvatar() {
        guard let profileImageUrl = ProfileImageService.shared.avatarURL else { return }
        view?.setProfileAvatar(profileImageUrl)
    }
    
    private func profileImageServiceObserved() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else { return  }
            loadAvatar()
        })
    }
    
    private func showAlert() {
        self.alertPresenter?.creationAlert(title: "Что-то пошло не так", messange: "Не удалось выйти из аккаунта", completion: nil)
    }
}

