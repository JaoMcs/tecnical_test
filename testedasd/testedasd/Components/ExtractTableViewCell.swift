//
//  ExtractTableViewCell.swift
//  testedasd
//
//  Created by João Marcos on 18/09/24.
//

import UIKit

class ExtractTableViewCell: UITableViewCell {


    static let identifier = "ExtractTableViewCell"

    // MARK: - UI Elements

    // Ícone à esquerda
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.icArrowDownIn
        imageView.tintColor = ColorManager.textPrimary
        return imageView
    }()

    // Label para o valor
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "R$ 30,00"
        label.font = FontManager.body1Bold
        label.textColor = ColorManager.receivedColor
        return label
    }()

    // Label para a descrição da transação
    private let transactionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Transferência recebida"
        label.font = FontManager.body2Regular
        label.textColor = ColorManager.receivedColor
        return label
    }()

    // Label para o nome do remetente/destinatário
    private let senderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lucas Costa"
        label.font = FontManager.body2Regular
        label.textColor = ColorManager.textSecondary
        return label
    }()

    // Label para o horário
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "17:35"
        label.font = FontManager.body2Regular
        label.textColor = ColorManager.textSecondary
        label.textAlignment = .right
        return label
    }()


    // MARK: - Constants & Variables

    private var status: StatusTransaction = .paid

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none

        // Adicionar subviews à célula
        contentView.addSubview(iconImageView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(transactionLabel)
        contentView.addSubview(senderLabel)
        contentView.addSubview(timeLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Ícone à esquerda
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            // Valor (R$ 30,00)
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            amountLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),

            // Descrição da transação (Transferência recebida)
            transactionLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            transactionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),

            // Nome do remetente/destinatário (Lucas Costa)
            senderLabel.topAnchor.constraint(equalTo: transactionLabel.bottomAnchor, constant: 4),
            senderLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            senderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Horário à direita (17:35)
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Configuration Method

    func configure(with transaction: TransactionModel) {
        amountLabel.text = transaction.amount
        senderLabel.text = transaction.sender
        timeLabel.text = transaction.time
        transactionLabel.text = transaction.type
        setupStatus(with: transaction.type)
    }

    private func setupStatus(with status: String) {
        let statusTransaction = StatusTransaction(from: status)
        switch statusTransaction {
            case .recive:
                amountLabel.textColor = ColorManager.receivedColor
                transactionLabel.textColor = ColorManager.receivedColor
                iconImageView.image = ImageManager.icArrowDownIn
            case .refunded:
                if let text = amountLabel.text {
                    let attributedString = NSMutableAttributedString(string: text)
                    attributedString.addAttribute(.strikethroughStyle, 
                                                  value: NSUnderlineStyle.single.rawValue,
                                                  range: NSMakeRange(0, attributedString.length))
                    amountLabel.attributedText = attributedString
                }
                amountLabel.textColor = ColorManager.textPrimary
                transactionLabel.textColor = ColorManager.textPrimary
                iconImageView.image = ImageManager.icArrowReturn
            case .paid:
                amountLabel.textColor = ColorManager.textPrimary
                transactionLabel.textColor = ColorManager.textPrimary
                iconImageView.image = ImageManager.icBarCode
            case .sent:
                amountLabel.textColor = ColorManager.textPrimary
                transactionLabel.textColor = ColorManager.textPrimary
                iconImageView.image = ImageManager.icArrowUpOut
            case .compensated:
                amountLabel.textColor = ColorManager.textPrimary
                transactionLabel.textColor = ColorManager.textPrimary
                iconImageView.image = ImageManager.icPercentage
            case .none:
                amountLabel.textColor = ColorManager.textPrimary
                transactionLabel.textColor = ColorManager.textPrimary
                iconImageView.image = ImageManager.icBarCode
        }
    }
}

