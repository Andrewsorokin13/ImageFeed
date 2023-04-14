import Foundation
import UIKit
import Kingfisher

final class ImageViewPresenter {
    
    weak var vc: ImageViewController?
    
    init(vc: ImageViewController? = nil) {
        self.vc = vc
    }
    
     func setImage(imageView: UIImageView) {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: vc?.fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure (let error):
                print(error)
            }
        }
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        guard let scrollView = vc?.scrollView else { return  }
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        vc?.view.layoutIfNeeded()
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
    
    func didTapBackButton() {
        vc?.dismiss(animated: true, completion: nil)
    }
}
