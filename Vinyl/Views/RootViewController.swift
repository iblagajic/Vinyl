//
//  RootViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 04/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    private let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    private let stackView = UIStackView(forAutoLayout: ())
    
    var viewControllers: [UIViewController] = [] {
        didSet {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            viewControllers.compactMap { $0.view }.forEach(stackView.addArrangedSubview)
        }
    }
    
    func select(viewController: UIViewController) throws {
        let optionalViewControllerToSelect = viewControllers.filter { $0 == viewController }.first
        guard let viewControllerToSelect = optionalViewControllerToSelect else {
            throw NavigationError.viewControllerNotAvailable
        }
        scrollView.scrollRectToVisible(viewControllerToSelect.view.frame, animated: true)
    }
    
    override func loadView() {
        scrollView.addSubview(stackView)
        self.view = scrollView
        stackView.pinToSuperview()
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }
}
