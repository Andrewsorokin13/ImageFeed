import UIKit
import WebKit

final class WebViewViewController: UIViewController {

    //MARK: - UI Elemets
    private lazy var webView: WKWebView = {
        WKWebView()
    }()
    
    private lazy var progressView: UIProgressView = {
        UIProgressView()
    }()
    
    private lazy var backButton: UIButton = {
        UIButton.customButton(
            image: UIImage(named: Constants.ImageButton.backButtonImage) ?? UIImage(),
            target: self,
            action:  #selector(didTapBackButton),
            tinColor: .YPBlack
        )
    }()
    
    //MARK: - Public property
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        webView.navigationDelegate = self
        if let request = urlRequest() {
            webView.load(request)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver( self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Action button
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private func
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

//MARK: - Setup Constraint UI
private extension  WebViewViewController {
    private func setupConstraint() {
        view.addSubview(backButton)
        view.addSubview(progressView)
        view.addSubview(webView)
        
        // Back button
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        //Progress view
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        progressView.tintColor =  .YPBlack
        progressView.setProgress(0.32, animated: true)
        
        //Web view
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
        
    }
}
