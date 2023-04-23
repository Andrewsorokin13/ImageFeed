import UIKit


final class ProfileViewController: UIViewController & ProfileViewProtocol{
    
    // MARK: UIElemets property
    private lazy var nameLable: UILabel = {
        UILabel.customLable(
            textColor: .white,
            font: UIFont.sfProBold23,
            text: "bio"
        )
    }()
    
    private lazy var loginNameLabel: UILabel = {
        UILabel.customLable(
            textColor: .loginLableColor ,
            font: UIFont.sfProRegular13,
            text:  "bio"
        )
    }()
    
    private lazy var descriptionLable: UILabel = {
        UILabel.customLable(
            textColor: .white,
            font: UIFont.sfProRegular13,
            text: "bio"
        )
    }()
    
    private lazy var avatarImageView: UIImageView  = {
        UIImageView.customImageView(
            name: "3",
            cornerRadius: 35
        )
    }()
    
    private lazy var logoutButton: UIButton = {
        UIButton.customButton(
            image: UIImage(named: Constants.ImageButton.logOutProfileImage) ?? UIImage(),
            target: self, action: #selector(didTapLogoutButton),
            tinColor: .logOutButtonColor
        )
    }()
    
    // MARK: Public property
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
        presenter?.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK:  action button
    @objc private func didTapLogoutButton() {
        showOutAlert()
    }
    
    func setProfileDetails(_ name: String, _ loginName: String, _ description: String) {
        nameLable.text = name
        loginNameLabel.text = ("@\(loginName)")
        descriptionLable.text = description
    }
    
    func setProfileAvatar(_ url: String) {
        guard let avatarUrl = URL(string: url) else { return }
        avatarImageView.kf.setImage(with: avatarUrl)
    }
    
    func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let vc = SplashViewController()
        window.rootViewController = vc
    }
}

//MARK: - Show alert
private extension ProfileViewController {
    private func showOutAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert )
        let alertYesAction = UIAlertAction(title: "Да", style: .default) {[weak self] _ in
            guard let self = self else { return  }
            presenter?.logOut()
        }
        alertYesAction.accessibilityIdentifier = "alertYesAction"
        let alertNoAction = UIAlertAction(title: "Нет", style: .default)
        alert.addAction(alertYesAction)
        alert.addAction(alertNoAction)
        alert.accessibilityLabel = "Пока, пока!"
        self.present(alert, animated: true)
    }
}

//MARK: - Set constraint UI elements
private extension ProfileViewController {
    private func setConstraint() {
        view.backgroundColor = .YPBlack
        // Avatar ImageView
        view.addSubview(avatarImageView)
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = .clear
        
        //Name label
        view.addSubview(nameLable)
        nameLable.accessibilityIdentifier = "ProfileNameLabel"
        //loginName Label
        view.addSubview(loginNameLabel)
        loginNameLabel.accessibilityIdentifier = "ProfileLoginNameLabel"
        
        //description Lable
        view.addSubview(descriptionLable)
        descriptionLable.accessibilityIdentifier = "ProfileDescriptionLable"
        //logout Button
        view.addSubview(logoutButton)
        logoutButton.tintColor = .logOutButtonColor
        logoutButton.accessibilityIdentifier = "ProfileExitButton"
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 32),
            
            
            nameLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  18),
            nameLable.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 18),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            
            descriptionLable.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLable.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor , constant: 8),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 22),
            logoutButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
