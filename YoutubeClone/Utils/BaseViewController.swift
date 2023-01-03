
import UIKit

protocol BaseViewProtocol {
    func showError(_ error: String, callback: (() -> Void)?)
}

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configNavigationBar() {
        let stackOptions = UIStackView()
        stackOptions.axis = .horizontal
        stackOptions.distribution = .fillEqually
        stackOptions.spacing = 0.0
        stackOptions.translatesAutoresizingMaskIntoConstraints = false
        
        let shareButton = builButton(selector: #selector(shareButtonPressed), image: .castImage, inset: 30)
        let magnifyButton = builButton(selector: #selector(magnifyButtonPressed), image: .magnifyingImage, inset: 33)
        let dotsButton = builButton(selector: #selector(dotsButtonPressed), image: .dotsImage, inset: 33)
        
        stackOptions.addArrangedSubview(shareButton)
        stackOptions.addArrangedSubview(magnifyButton)
        stackOptions.addArrangedSubview(dotsButton)
        
        stackOptions.widthAnchor.constraint(equalToConstant: 120).isActive = true
        let customItemView = UIBarButtonItem(customView: stackOptions)
        customItemView.tintColor = .clear
        navigationItem.rightBarButtonItem = customItemView
    }
    
    private func builButton(selector: Selector, image: UIImage, inset: CGFloat) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = .whiteColor
        let extraPadding: CGFloat = 2.0
        button.imageEdgeInsets = UIEdgeInsets(top: inset+extraPadding, left: inset, bottom: inset+extraPadding, right: inset)
        return button
    }
    
    @objc func shareButtonPressed() {
        
    }
    
    @objc func magnifyButtonPressed() {
        
    }
    
    @objc func dotsButtonPressed() {
        
    }

}

extension BaseViewController {
    func showError(_ error: String, callback: (()-> Void)?) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {action in
            if action.style == .cancel {
                print("cancel pressed button")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {action in
            if action.style == .default {
                if let callback = callback {
                    callback()
                }
                print("retry pressed button")
            }
        }))
        
        present(alert, animated: true)
    }
}
