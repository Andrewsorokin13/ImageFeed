import UIKit
import WebKit

final class WebViewViewController: UIViewController {

    //MARK: - UI Elemets
    private (set) lazy var webView: WKWebView = {
        WKWebView()
    }()
    
    private (set) lazy var progressView: UIProgressView = {
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
    var presenter: WebViewPresenter!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WebViewPresenter(vc: self)
        setupConstraint()
        webView.navigationDelegate = self
   
        if let request = presenter.urlRequest() {
            webView.load(request)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver( self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        presenter.updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter.updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Action button
    @objc private func didTapBackButton() {
        presenter.didTapBackButton()
    }
    
}

//MARK: - Setup Constraint UI
private extension  WebViewViewController {
    private func setupConstraint() {
        // Back button
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Progress view
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor =  .YPBlack
        progressView.setProgress(0.32, animated: true)
        
        //Web view
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 64),
            
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 1),
            
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor)
        ])
    }
}
