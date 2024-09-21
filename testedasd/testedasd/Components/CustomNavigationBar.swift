//
//  CustomNavigationBar.swift
//  testedasd
//
//  Created by João Marcos on 17/09/24.
//

import UIKit

class CustomNavigationBar {

    /// Método para configurar a Status Bar e a Navigation Bar estilizada
    static func setupNavigationBar(for viewController: UIViewController, title: String, backAction: Selector, rightButtonIcon: UIImage? = nil, rightButtonAction: Selector? = nil) {

        let navBarColor = ColorManager.details
        let backButtonColor = ColorManager.primary

        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let statusBarView = UIView()
        statusBarView.backgroundColor = navBarColor
        statusBarView.frame = CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: statusBarHeight)

        viewController.view.addSubview(statusBarView)

        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: viewController, action: backAction)
        backButton.tintColor = backButtonColor
        viewController.navigationItem.leftBarButtonItem = backButton
        viewController.title = title
        viewController.navigationController?.navigationBar.prefersLargeTitles = false
        viewController.navigationController?.navigationBar.backgroundColor = navBarColor
        viewController.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ColorManager.textPrimary,
            NSAttributedString.Key.font: FontManager.body1Regular
        ]

        viewController.navigationController?.navigationBar.tintColor = backButtonColor

        if let icon = rightButtonIcon, let action = rightButtonAction {
            let rightButton = UIBarButtonItem(image: icon, style: .plain, target: viewController, action: action)
            rightButton.tintColor = backButtonColor
            viewController.navigationItem.rightBarButtonItem = rightButton
        }

        viewController.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

