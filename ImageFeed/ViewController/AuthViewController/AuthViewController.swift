import UIKit

final class AuthViewController: UIViewController {
    
    //MARK: - Public property
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Action button
    @IBAction private func showWebViewController(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewVC = storyboard.instantiateViewController(identifier: "WebViewViewController") as? WebViewViewController
        guard let webViewVC = webViewVC else { fatalError("Error loading WebViewViewController") }
        webViewVC.delegate = self
        webViewVC.modalPresentationStyle = .fullScreen
        show(webViewVC, sender: self)
    }
}
