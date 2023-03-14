
import UIKit

final class ImageViewController: UIViewController {
    
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
    
    private  var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.contentMode = .scaleToFill
        return scrollView
    }()
    
    private  var imageView: UIImageView = {
       UIImageView()
    }()
    
    
    // MARK: public proprty
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: override func
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        setupConstraintView()
        setContentSize()
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK:  action button
    @objc
    private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:  action button
    @objc private func didTapShareButton() {
        let share = sharedActivity()
        present(share, animated: true, completion: nil)
    }
    
    private  func setContentSize() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func sharedActivity() -> UIActivityViewController {
        UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
    }
}

// MARK:  Setup Constraint view
extension ImageViewController {
   private  func setupConstraintView() {
        // Add subView
        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(sharedButton)
        scrollView.addSubview(imageView)
        
        //Back Button
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.tintColor = .white
        
        //Share Button
        sharedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sharedButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sharedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sharedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -38).isActive = true
        
        //Image View
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //Scroll View
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: rescale and center Image in ScrollView
extension ImageViewController {

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK:  conform UIScrollView Delegate
extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
