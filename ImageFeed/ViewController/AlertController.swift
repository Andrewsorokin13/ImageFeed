
import UIKit

struct AlertPresenter {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    // MARK: - Methods
    func creationAlert(title: String, messange: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: messange, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ок", style: .default){ _ in
            //можно сделать повторный запрос
        }
        alertController.addAction(alertAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
