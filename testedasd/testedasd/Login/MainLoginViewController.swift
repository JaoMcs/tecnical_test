//
//  MainLoginViewController.swift
//  testedasd
//
//  Created by João Marcos on 29/08/24.
//

import UIKit

class MainLoginViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.coraLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.mainLoginImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 150
        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Conta Digital PJ"
        label.font = FontManager.title1Bold
        label.textColor = ColorManager.secondary
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Poderosamente simples"
        label.font = FontManager.title1Regular
        label.textColor = ColorManager.secondary
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Sua empresa livre burocracias e de taxas para gerar boletos, fazer transferências e pagamentos."
        label.font = FontManager.body1Regular
        label.textColor = ColorManager.secondary
        label.numberOfLines = 0
        return label
    }()

    private let actionButton = NextArrowButton(text: "Quero fazer parte!",
                                        font: FontManager.body1Bold,
                                        textColor: .systemPink,
                                        backgroundColor: .white)

    private let secondaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Já sou cliente", for: .normal)
        button.setTitleColor(ColorManager.secondary, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        validateUserLogger()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func validateUserLogger() {
        let networkManager = NetworkManager.shared
        if networkManager.isUserLogger() {
            let vm = ExtractViewModel()
            let nextVC = ExtractViewController(viewModel: vm)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    private func setupView() {
        view.backgroundColor = ColorManager.primary
        setupSubviews()
        setupConstraints()
        setupAction()
    }

    private func setupAction() {
        actionButton.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
        secondaryButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }

    private func setupSubviews() {
        view.addSubview(mainImageView)
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(actionButton)
        view.addSubview(secondaryButton)
    }

    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),

            mainImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            actionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 50),

            secondaryButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 16),
            secondaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func createAccountAction() {
        print("É PRA FAZER ALGO?!")
    }
    @objc func loginAction() {
        if let navC = self.navigationController {
            let vm = LoginViewModel()
            let nextVC = LoginViewController(viewModel: vm)
            navC.pushViewController(nextVC, animated: true)
        }
    }
}
