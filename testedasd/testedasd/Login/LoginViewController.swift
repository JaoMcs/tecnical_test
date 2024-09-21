//
//  LoginViewController.swift
//  testedasd
//
//  Created by João Marcos on 15/09/24.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Variables & Constants
    // Variaveis usadas na logica do teclado
    private var windowSafeArea: CGFloat = 0
    private var windowsSafeAreaWereAdded = false

    private var isPasswordView = false

    // MARK: - ViewModel
    var viewModel: LoginViewModel

    // MARK: - Components
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Bem-vindo de volta!"
        label.textColor = ColorManager.textSecondary
        label.font = FontManager.body1Regular
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Qual seu CPF?"
        label.textColor = ColorManager.textPrimary
        label.font = FontManager.title3Bold
        return label
    }()

    private let contentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite seu CPF"
        textField.textColor = ColorManager.textPrimary
        textField.font = FontManager.title3Regular
        textField.textAlignment = .left
        textField.keyboardType = .numberPad
        return textField
    }()

    private let eyeHiddenButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = ImageManager.icEyeHidden
        button.setImage(icon, for: .normal)
        button.tintColor = ColorManager.primary
        return button
    }()

    private let forgotPassword: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Esqueci minha senha", for: .normal)
        button.setTitleColor(ColorManager.primary, for: .normal)
        button.titleLabel?.font = FontManager.body2Regular
        button.contentHorizontalAlignment = .left
        return button
    }()

    private let nextButton = NextArrowButton(text: "Próximo",
                                             font: FontManager.body2Bold,
                                             textColor: ColorManager.secondary,
                                             backgroundColor: ColorManager.primary)

    // MARK: - Init
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDelegate()
        setupLayout()
        setupNavigationBar()
        setupKeyboardObserver()
        setupAction()
        setupContentView()
        if isPasswordView {
            setupPasswordConstraints()
        } else {
            setupConstraints()
        }
    }

    // MARK: - Methodos

    private func setType(isPassword: Bool) {
        isPasswordView = isPassword
    }

    private func setupDelegate() {
        contentTextField.delegate = self
    }

    private func setupContentView() {
        view.backgroundColor = ColorManager.secondary
        isNextButtonEnable(false)
        if isPasswordView {
            setupPasswordView()
            welcomeLabel.isHidden = true
            contentTextField.isSecureTextEntry = true
            contentTextField.keyboardType = .default
        } else {
            forgotPassword.isHidden = true
            eyeHiddenButton.isHidden = true
        }
    }

    private func setupPasswordView() {
        contentLabel.text = "Digite sua senha de acesso"
        contentTextField.placeholder = "Senha"
    }

    private func setupNavigationBar() {
        CustomNavigationBar.setupNavigationBar(
            for: self,
            title: "Login Cora",
            backAction: #selector(handleBack)
        )
    }

    private func setupLayout() {
        view.addSubview(eyeHiddenButton)
        view.addSubview(contentTextField)
        view.addSubview(nextButton)
        view.addSubview(welcomeLabel)
        view.addSubview(contentLabel)
        view.addSubview(forgotPassword)
    }

    private func setupConstraints() {
        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),

            contentLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),

            contentTextField.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 32),
            contentTextField.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            contentTextField.trailingAnchor.constraint(equalTo: nextButton.trailingAnchor),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupPasswordConstraints() {
        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
        eyeHiddenButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            contentLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),

            contentTextField.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 32),
            contentTextField.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),

            eyeHiddenButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 32),
            eyeHiddenButton.leadingAnchor.constraint(equalTo: contentTextField.trailingAnchor),
            eyeHiddenButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            eyeHiddenButton.widthAnchor.constraint(equalToConstant: 32),

            forgotPassword.topAnchor.constraint(equalTo: contentTextField.bottomAnchor, constant: 48),
            forgotPassword.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            forgotPassword.trailingAnchor.constraint(equalTo: nextButton.trailingAnchor),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupAction() {
        nextButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        forgotPassword.addTarget(self, action: #selector(forgotPasswordAction), for: .touchUpInside)
        contentTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        eyeHiddenButton.addTarget(self, action: #selector(handleEyeHidden), for: .touchUpInside)
    }

    private func isNextButtonEnable(_ status: Bool) {
        nextButton.isUserInteractionEnabled = status
        if status {
            nextButton.backgroundColor = ColorManager.primary
        } else {
            nextButton.backgroundColor = ColorManager.disableButton
        }
    }
    // MARK: - Action
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleEyeHidden() {
        contentTextField.isSecureTextEntry.toggle()
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if isPasswordView {
                isNextButtonEnable(viewModel.isValidPassword(password: text))
            } else {
                textField.text = text.formattedCPFOrCNPJ()
                isNextButtonEnable(viewModel.isValidCPF(cpf: text))
            }
        }
    }

    @objc func forgotPasswordAction() {
        print("É PRA FAZER ALGO?!")
    }

    @objc func loginAction() {
        if isPasswordView {
            viewModel.setPassword(with: contentTextField.text)
            viewModel.login()

            viewModel.onSuccess = { [weak self] in
                DispatchQueue.main.async {
                    let vm = ExtractViewModel()
                    let nextVC = ExtractViewController(viewModel: vm)
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        } else {
            viewModel.setCPF(with: contentTextField.text)
            let nextVC = LoginViewController(viewModel: viewModel)
            nextVC.setType(isPassword: true)
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

// MARK: - Extension
extension LoginViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return prospectiveText.count <= (isPasswordView ? 6 : 11)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let beginKeyboardFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
            let endKeyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            endKeyboardFrame != beginKeyboardFrame
        else {
            return
        }
        let windowSafeArea: CGFloat = windowsSafeAreaWereAdded ? 0 : self.view.safeAreaInsets.bottom - self.additionalSafeAreaInsets.bottom

        self.additionalSafeAreaInsets.bottom += beginKeyboardFrame.origin.y - endKeyboardFrame.origin.y - windowSafeArea

        animateUpdates(userInfo, self)
        windowsSafeAreaWereAdded = true

        if windowSafeArea > 0 {
            self.windowSafeArea = windowSafeArea
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let beginKeyboardFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
            let endKeyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }

        self.additionalSafeAreaInsets.bottom -= (endKeyboardFrame.origin.y - beginKeyboardFrame.origin.y - windowSafeArea)

        animateUpdates(userInfo, self)
        windowsSafeAreaWereAdded = false
    }

    private func animateUpdates(_ userInfo: [AnyHashable: Any], _ viewController: UIViewController) {
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
            .flatMap { $0 as? Double } ?? 0.25

        if duration > 0 {
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]
                .flatMap { $0 as? Int }
                .flatMap { UIView.AnimationCurve(rawValue: $0) } ?? .easeInOut

            UIViewPropertyAnimator(duration: duration, curve: curve) {
                self.view.layoutIfNeeded()
            }
            .startAnimation()
        } else {
            self.view.layoutIfNeeded()
        }
    }
}
