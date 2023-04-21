import XCTest
import Foundation

@testable import ImageFeed

final class ImageListControllerSp: ImagesListViewControllerProtocol {
    var alertPresenter: ImageFeed.AlertPresenter?
    
    var presenter: ImageFeed.ImageListPresenterProtocol?
    
    
    func configCell(for cell: ImageFeed.ImagesListCell, with indexPath: IndexPath) {
    }
    
    func updateTableViewAnimated(_ indexPath: [IndexPath]) {
    }
}
