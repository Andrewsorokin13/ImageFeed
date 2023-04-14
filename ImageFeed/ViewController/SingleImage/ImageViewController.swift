
import UIKit


final class ImageViewController: UIViewController {
    
    private var presenter: ImageViewPresenter!
    
    // MARK: UIElemets
    private var backButton: UIButton = {
        UIButton.customButton(
            image: UIImage(named: Constants.ImageButton.backButtonImage) ?? UIImage(),
            target: self,
            action:  #selector(didTapBackButton),
            tinColor: .YPWhite
        )
    }()
    
    private var sharedButton: UIButton = {
        UIButton.customButton(
            image: UIImage(named: Constants.ImageButton.shareButtonImage) ?? UIImage(),
            target: self,
            action: #selector(didTapShareButton),
            tinColor: .clear)
    }()
    
    private (set) var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.contentMode = .scaleAspectFit
        return scrollView
    }()
    
    private var imageView: UIImageView = {
        UIImageView()
    }()
    
    var fullImageURL: URL!
    
    // MARK: override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ImageViewPresenter(vc: self)
        scrollView.delegate = self
        
        setupConstraintView()
        setContentSize()
        
        presenter.setImage(imageView: imageView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        guard let image = imageView.image else { return }
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK:  action button
    @objc
    private func didTapBackButton() {
        presenter.didTapBackButton()
    }
    
    // MARK:  action button
    @objc private func didTapShareButton() {
        let share = sharedActivity()
        present(share, animated: true, completion: nil)
    }
    
    private  func setContentSize() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.35
    }
    
    private func sharedActivity() -> UIActivityViewController {
        UIActivityViewController(
            activityItems: [imageView.image],
            applicationActivities: nil
        )
    }
}

// MARK:  Setup Constraint view
private extension ImageViewController {
    private  func setupConstraintView() {
        //Scroll View
        view.addSubview(scrollView)
        
        //Back Button
        view.addSubview(backButton)
        backButton.tintColor = .white
        
        //Share Button
        view.addSubview(sharedButton)
        
        //Image View
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            
            sharedButton.heightAnchor.constraint(equalToConstant: 50),
            sharedButton.widthAnchor.constraint(equalToConstant: 50),
            sharedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sharedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -38),
            
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: rescale and center Image in ScrollView
extension ImageViewController {
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        presenter.rescaleAndCenterImageInScrollView(image: image)
    }
}

// MARK:  conform UIScrollView Delegate
extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
