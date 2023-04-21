import UIKit

final class AuthViewController: UIViewController {
    
    //MARK: - Public property
    weak var delegate: AuthViewControllerDelegate?
    
    @IBOutlet weak var authButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        authButton.accessibilityIdentifier = "Authenticate" 
    }
    //MARK: - Action button
    @IBAction private func showWebViewController(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewVC = storyboard.instantiateViewController(identifier: "WebViewViewController") as? WebViewViewController
        guard let webViewVC = webViewVC else { fatalError("Error loading WebViewViewController") }
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewVC.presenter = webViewPresenter
        webViewPresenter.view = webViewVC
        webViewVC.delegate = self
        webViewVC.modalPresentationStyle = .fullScreen
        show(webViewVC, sender: self)
    }
    
}
