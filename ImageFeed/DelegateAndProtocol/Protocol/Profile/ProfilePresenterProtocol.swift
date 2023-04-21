import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
    func logOut()
}
