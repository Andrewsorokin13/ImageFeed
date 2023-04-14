import UIKit


final class ProfileViewController: UIViewController {
    
    // MARK: Private property
    private var profileImageServiceObserver: NSObjectProtocol?
    private var presenter: ProfilePresenter!
  
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
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter(vc: self)
        setConstraint()
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else { return  }
            self.updateAvatar()
        })
        updateAvatar()
        updateProfileDetails()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    private func updateAvatar() {
        presenter.updateAvatar(avatarImageView: avatarImageView)
    }
    
    private func updateProfileDetails() {
        presenter.updateProfileDetails(nameLable: nameLable, loginNameLabel: loginNameLabel, descriptionLable: descriptionLable)
    }
    
    // MARK:  action button
    @objc private func didTapLogoutButton() {
        presenter.logOut()
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
        
        //loginName Label
        view.addSubview(loginNameLabel)
        
        //description Lable
        view.addSubview(descriptionLable)
        
        //logout Button
        view.addSubview(logoutButton)
        logoutButton.tintColor = .logOutButtonColor
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            
            nameLable.heightAnchor.constraint(equalToConstant: 18),
            nameLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  18),
            nameLable.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 18),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            
            descriptionLable.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLable.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor , constant: 8),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 22),
            logoutButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
