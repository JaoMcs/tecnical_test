//
//  ExtractViewController.swift
//  testedasd
//
//  Created by João Marcos on 17/09/24.
//

import UIKit
import SwiftUI

class ExtractViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - ViewModel
    var viewModel: ExtractViewModel

    // MARK: - Components
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), 
                                     style: .plain, target: self, action: #selector(didTapBack))
        button.tintColor = .black
        return button
    }()

    private lazy var downloadButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"),
                                     style: .plain, target: self, action: #selector(didTapDownload))
        button.tintColor = .black
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Extrato"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Tudo", "Entrada", "Saída", "Futuro"]
        let segmented = UISegmentedControl(items: items)
        segmented.selectedSegmentIndex = 0
        segmented.removeBorders()
        segmented.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemPink], for: .selected)
        segmented.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)

        segmented.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        return segmented
    }()

    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_filter"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExtractTableViewCell.self, forCellReuseIdentifier: ExtractTableViewCell.identifier)
        return tableView
    }()

    // MARK: - Init
    init(viewModel: ExtractViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupLayout()
        setupConstraints()
        setupContentView()
        setupAction()
        setupSkeletonView()

        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.stopSkeletonLoading()
            }
        }
    }

    private let skeletonLoadingView: UIHostingController = {
        let swiftUIView = SkeletonListView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
    private func setupSkeletonView() {
        addChild(skeletonLoadingView)
        view.addSubview(skeletonLoadingView.view)
        NSLayoutConstraint.activate([
            skeletonLoadingView.view.topAnchor.constraint(equalTo: view.topAnchor),
            skeletonLoadingView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            skeletonLoadingView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            skeletonLoadingView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        skeletonLoadingView.didMove(toParent: self)
    }

    private func stopSkeletonLoading() {
        skeletonLoadingView.view.removeFromSuperview()
        tableView.reloadData()
    }

    private func setupDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupLayout() {
        CustomNavigationBar.setupNavigationBar(
            for: self,
            title: "Extrato",
            backAction: #selector(handleBack),
            rightButtonIcon: UIImage(named: "ic_download"),
            rightButtonAction: #selector(handleDownload)
        )
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, filterButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        view.addSubview(tableView)
    }

    private func setupAction() {
        filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
    }

    private func setupContentView() {
        view.backgroundColor = ColorManager.secondary
        viewModel.getExtract()
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

    }

    @objc func handleBack() {
        viewModel.logout()
        navigationController?.popViewController(animated: true)
    }

    @objc func handleDownload() {
        let pdfFilePath = getDocumentsDirectory().appendingPathComponent("content.pdf")
        let renderer = UIGraphicsPDFRenderer(bounds: self.view.bounds)
        do {
            try renderer.writePDF(to: pdfFilePath, withActions: { (context) in
                context.beginPage()
                self.view.layer.render(in: context.cgContext)
            })

            let alert = UIAlertController(title: "Sucesso", message: "PDF salvo no caminho: \(pdfFilePath)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } catch {
            print("Erro ao salvar o PDF: \(error.localizedDescription)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -8),

            filterButton.centerYAnchor.constraint(equalTo: segmentedControl.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapDownload() {
        print("Download button tapped")
        // Ação de download
    }

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        print("Segmented control changed to index \(sender.selectedSegmentIndex)")
        // Atualizar o conteúdo com base na aba selecionada
        // Não tem categoria pré definida
    }

    @objc private func didTapFilter() {
        print("Filter button tapped")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getExtractListItemsTotalCount()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getExtractListCount(with: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExtractTableViewCell.identifier, for: indexPath) as? ExtractTableViewCell else {
            return UITableViewCell()
        }
        guard let transaction = viewModel.getExtractListTransaction(with: indexPath.section,
                                                                    and: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(with: transaction)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = viewModel.getTransactionID(with: indexPath.section,
                                                     and: indexPath.row)
        let vm = DetailsExtractViewModel(id: transaction)
        let view = DetailsExtractView(viewModel: vm)
        let vc = HostingController(swiftUIView: view)

        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = ColorManager.details

        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = FontManager.body2Regular
        headerLabel.textColor = ColorManager.textSecondary
        headerLabel.text = viewModel.getDate(with: section)

        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}

