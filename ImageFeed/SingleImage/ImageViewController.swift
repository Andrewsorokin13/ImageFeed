
import UIKit

class ImageViewController: UIViewController {
    
    // MARK: UIElemets
    private var backButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: Constants.ImageButton.backButtonImage)!,
                                           target: self,
                                           action: #selector(didTapBackButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var sharedButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: Constants.ImageButton.shareButtonImage)!,
                                           target: self,
                                           action: #selector(didTapShareButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    // MARK: public proprty
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        setupConstraintView()
        setContentSize()
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK:  action button
    @objc
    private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapShareButton() {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    // MARK:  Setup Constraint view
    func setupConstraintView() {
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
    
    private  func setContentSize() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
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
