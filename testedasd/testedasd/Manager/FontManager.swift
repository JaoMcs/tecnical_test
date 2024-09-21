//
//  FontManager.swift
//  testedasd
//
//  Created by João Marcos on 15/09/24.
//

import UIKit

struct FontManager {
    static let body1Bold = UIFont(name: "Avenir-Heavy", 
                                  size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    ?? UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)

    static let body2Bold = UIFont(name: "Avenir-Heavy",
                                  size: UIFont.preferredFont(forTextStyle: .body).pointSize * 0.9)
    ?? UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize * 0.9)

    static let body1Regular = UIFont(name: "Avenir-Roman",
                                     size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    ?? UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)

    static let body2Regular = UIFont(name: "Avenir-Roman",
                                     size: UIFont.preferredFont(forTextStyle: .body).pointSize * 0.9)
    ?? UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize * 0.9)

    static let title1Bold = UIFont(name: "Avenir-Heavy",
                                   size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    ?? UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize)

    static let title3Bold = UIFont(name: "Avenir-Heavy",
                                   size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
    ?? UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)

    static let title1Regular = UIFont(name: "Avenir-Roman",
                                      size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    ?? UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)

    static let title3Regular = UIFont(name: "Avenir-Roman",
                                      size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
    ?? UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
}

