//
//  ImageManager.swift
//  testedasd
//
//  Created by João Marcos on 19/09/24.
//

import UIKit

struct ImageManager {

    // MARK: - Image & Logo
    static let coraLogo = UIImage(named: "cora-logo")
    static let mainLoginImage = UIImage(named: "mainLoginImage")

    // MARK: - Icones
    static let icEyeHidden = UIImage(named: "ic_eye-hidden")
    static let icArrowDownIn = UIImage(named: "ic_arrow-down-in")
    static let icArrowReturn = UIImage(named: "ic_arrow-return")
    static let icBarCode = UIImage(named: "ic_bar-code")
    static let icPercentage = UIImage(named: "ic_percentage")
    static let icArrowUpOut = UIImage(named: "ic_arrow-up-out")


    // MARK: - Imagens de Background
    struct Backgrounds {
        static let mainBackground = UIImage(named: "main_background")
        static let loginBackground = UIImage(named: "login_background")
    }

    // MARK: - Custom Placeholder
    struct Placeholders {
        static let defaultPlaceholder = UIImage(named: "placeholder_default")
        static let userPlaceholder = UIImage(named: "placeholder_user")
    }
}
