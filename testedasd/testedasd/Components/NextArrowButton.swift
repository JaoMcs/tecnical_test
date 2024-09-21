//
//  buttonArrow.swift
//  testedasd
//
//  Created by João Marcos on 15/09/24.
//

import UIKit

/// NextButton
class NextArrowButton: UIButton {

    /// Inicializador personalizado que aceita a fonte, o conteúdo do texto, a cor de fundo e a cor do texto
    init(text: String, font: UIFont, textColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: .zero)
        setupButton(text: text, font: font, textColor: textColor, backgroundColor: backgroundColor)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(text: "Próximo", font: UIFont.systemFont(ofSize: 18), textColor: .white, backgroundColor: .systemPink)
    }

    // Função para configurar o botão
    private func setupButton(text: String, font: UIFont, textColor: UIColor, backgroundColor: UIColor) {
        setTitle(text, for: .normal)
        titleLabel?.font = font
        setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 10
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        if let iconImage = UIImage(named: "ic_arrow-right") {
            setImage(iconImage, for: .normal)
            tintColor = textColor
            semanticContentAttribute = .forceRightToLeft
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 200, bottom: 0, right: 16)
        }

    }
}
