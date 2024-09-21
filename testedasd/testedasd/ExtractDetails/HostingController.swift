//
//  HostingController.swift
//  testedasd
//
//  Created by João Marcos on 20/09/24.
//

import UIKit
import SwiftUI

class HostingController<Content: View>: UIViewController {

    private var swiftUIView: Content

    // MARK: - Init
    init(swiftUIView: Content) {
        self.swiftUIView = swiftUIView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        CustomNavigationBar.setupNavigationBar(
            for: self,
            title: "Detalhes da transferência",
            backAction: #selector(handleBack)
        )


        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }

    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
