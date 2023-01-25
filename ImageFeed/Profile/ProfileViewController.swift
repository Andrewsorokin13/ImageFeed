import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: Private property
    private var nameLable: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLable: UILabel?
    private var avatarImageView: UIImageView?
    private var logoutButton: UIButton!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIElements()
        setConstraint()
    }
    
    // MARK: private func
    private func setUIElements() {
        nameLable = createdUILable(textColor: .white, font: UIFont.sfProBold23, text: "Andrew Sorokin")
        loginNameLabel = createdUILable(textColor: .loginLableColor , font: UIFont.sfProRegular13, text: "@andrew13")
        descriptionLable = createdUILable(textColor: .white, font: UIFont.sfProRegular13, text: "Hello world")
        avatarImageView = createdImageView(name: "3", cornerRadius: 35)
        
        guard let imageButton = UIImage(named: Constants.ImageButton.logOutProfileImage) else { return  }
        logoutButton = createdLogOutButton(image: imageButton, target: self, action: #selector(didTapLogoutButton))
    }
    
    // MARK:  action button
    @objc func didTapLogoutButton() {
        //LogOUT
    }
}


//MARK: - Created UI elements
extension ProfileViewController {
    
    func createdImageView(name: String, cornerRadius: CGFloat ) -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: name)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = cornerRadius
        return image
    }
    
    func createdLogOutButton(image: UIImage, target: Any?, action: Selector?) -> UIButton {
        let button = UIButton.systemButton(with: image, target: target, action: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func createdUILable(textColor: UIColor, font: UIFont?, text: String) -> UILabel {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = textColor
        lable.font = font
        lable.text = text
        return lable
    }
}

//MARK: - Set constraint UI elements
extension ProfileViewController {
    private func setConstraint() {
        
        // Avatar ImageView
        guard let image  = avatarImageView else { return }
        view.addSubview(image)
        image.heightAnchor.constraint(equalToConstant: 70).isActive = true
        image.widthAnchor.constraint(equalToConstant: 70).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        image.layer.masksToBounds = true
        image.backgroundColor = .clear
        
        //Name label
        guard let nameLable = nameLable else { return }
        view.addSubview(nameLable)
        nameLable.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nameLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  18).isActive = true
        nameLable.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8).isActive = true
        nameLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 18).isActive = true
        
        //loginName Label
        guard let loginNameLabel = loginNameLabel else { return }
        view.addSubview(loginNameLabel)
        loginNameLabel.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor).isActive = true
        
        //description Lable
        guard let descriptionLable = descriptionLable else { return  }
        view.addSubview(descriptionLable)
        descriptionLable.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLable.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor , constant: 8).isActive = true
        
        //logout Button
        view.addSubview(logoutButton)
        logoutButton.tintColor = .logOutButtonColor
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
