//
//  BaseViewController.swift
//  YoutubeClone
//
//  Created by Desarrollo DevIOS on 26/12/2022.
//

import UIKit

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
