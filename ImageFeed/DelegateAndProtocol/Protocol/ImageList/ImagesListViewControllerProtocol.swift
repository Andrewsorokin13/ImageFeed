import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    var alertPresenter: AlertPresenter? { get set }
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func updateTableViewAnimated(_ indexPath: [IndexPath])
    
}
