import Foundation

public protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func setProfileDetails(_ name: String, _ loginName: String, _ description: String )
    func setProfileAvatar(_ url: String)
    func switchToSplashViewController()
}
