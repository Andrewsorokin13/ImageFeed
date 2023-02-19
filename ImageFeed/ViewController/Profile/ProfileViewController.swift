import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: Private property
    private lazy var nameLable: UILabel = {
        UILabel.customLable(
            textColor: .white,
            font: UIFont.sfProBold23,
            text: "Andrew Sorokin"
        )
    }()
    
    private lazy var loginNameLabel: UILabel = {
        UILabel.customLable(
            textColor: .loginLableColor ,
            font: UIFont.sfProRegular13,
            text: "@andrew13"
        )
    }()
    
    private lazy var descriptionLable: UILabel = {
        UILabel.customLable(
            textColor: .white,
            font: UIFont.sfProRegular13,
            text: "Hello world"
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
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
    }
    
    // MARK:  action button
    @objc private func didTapLogoutButton() {
        //LogOUT
    }
}

//MARK: - Set constraint UI elements
private extension ProfileViewController {
    private func setConstraint() {
        
        // Avatar ImageView
        view.addSubview(avatarImageView)
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = .clear
        
        //Name label
        view.addSubview(nameLable)
        nameLable.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nameLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  18).isActive = true
        nameLable.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 18).isActive = true
        
        //loginName Label
        view.addSubview(loginNameLabel)
        loginNameLabel.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor).isActive = true
        
        //description Lable
        view.addSubview(descriptionLable)
        descriptionLable.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLable.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor , constant: 8).isActive = true
        
        //logout Button
        view.addSubview(logoutButton)
        logoutButton.tintColor = .logOutButtonColor
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
