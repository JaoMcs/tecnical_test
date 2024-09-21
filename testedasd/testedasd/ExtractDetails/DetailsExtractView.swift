//
//  DetailsExtractView.swift
//  testedasd
//
//  Created by João Marcos on 20/09/24.
//

import SwiftUI

struct DetailsExtractView: View {

    @ObservedObject private var viewModel: DetailsExtractViewModel

    init(viewModel: DetailsExtractViewModel) {
        _viewModel = ObservedObject(initialValue: viewModel)
        viewModel.getDetails()
    }

    var body: some View {
        if viewModel.isLoading {
            SkeletonDetailsView()
        } else {
            VStack(alignment: .leading, spacing: 24) {
                IconTitleView(icon: .icArrowDownIn,
                              status: viewModel.extract.label)
                primarySecondaryLabelView(key: "Valor",
                                          value: viewModel.extract.amount.toBrazilianCurrency())


                primarySecondaryLabelView(key: "Data",
                                          value: viewModel.extract.amount.toBrazilianCurrency())


                ReciveView(reciveTitle: "De",
                           name: viewModel.extract.sender.name,
                           documentType: viewModel.extract.sender.documentType,
                           document: viewModel.extract.sender.documentNumber,
                           bank: viewModel.extract.sender.bankName,
                           agency: viewModel.extract.sender.bankNumber,
                           bankNumber: viewModel.extract.sender.accountNumber,
                           bankDigit: viewModel.extract.sender.accountNumberDigit)

                ReciveView(reciveTitle: "Para",
                           name: viewModel.extract.recipient.name,
                           documentType: viewModel.extract.recipient.documentType,
                           document: viewModel.extract.recipient.documentNumber,
                           bank: viewModel.extract.recipient.bankName,
                           agency: viewModel.extract.recipient.bankNumber,
                           bankNumber: viewModel.extract.recipient.accountNumber,
                           bankDigit: viewModel.extract.recipient.accountNumberDigit)

                DescriptionView(text: viewModel.extract.description)

                Spacer()

                SharedButton()

            }
            .padding()
            .navigationBarTitle("Comprovante", displayMode: .inline)
        }
    }
}

#Preview {
    DetailsExtractView(viewModel: DetailsExtractViewModel())
}

struct primarySecondaryLabelView: View {
    let key: String
    let value: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(key)
                .font(Font(FontManager.body2Regular))
                .foregroundColor(Color(ColorManager.textPrimary))
            Text(value)
                .font(Font(FontManager.body1Bold))
                .foregroundColor(Color(ColorManager.textPrimary))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct IconTitleView: View {
    let icon: ImageResource
    let status: String
    var body: some View {
        HStack {
            Image(.icArrowDownIn)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(status)
                .font(Font(FontManager.body1Bold))
                .foregroundColor(Color(ColorManager.textPrimary))
            Spacer()
        }
        .padding(.top)
    }
}

struct ReciveView: View {
    let reciveTitle: String
    let name: String
    let documentType: String
    let document: String
    let bank: String
    let agency: String
    let bankNumber: String
    let bankDigit: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(reciveTitle)
                .font(Font(FontManager.body2Regular))
                .foregroundColor(Color(ColorManager.textPrimary))
            Text(name)
                .font(Font(FontManager.body1Bold))
                .foregroundColor(Color(ColorManager.textPrimary))
            Text("\(documentType) \(document.formattedCPFOrCNPJ())")
                .font(Font(FontManager.body2Regular))
                .foregroundColor(Color(ColorManager.textSecondary))
            Text(bank)
                .font(Font(FontManager.body2Regular))
                .foregroundColor(Color(ColorManager.textSecondary))
            Text("Agência \(agency) - Conta \(bankNumber)-\(bankDigit)")
                .font(Font(FontManager.body2Regular))
                .foregroundColor(Color(ColorManager.textSecondary))
        }
    }
}

struct DescriptionView: View {
    let text: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("Descrição")
                .font(Font(FontManager.body2Regular))
                .foregroundColor(Color(ColorManager.textPrimary))
            
            Text(text)
                .font(Font(FontManager.body2Regular))
                .foregroundColor(Color(ColorManager.textSecondary))
        }
    }
}

struct SharedButton: View {
    let contentPadding = 10.0
    var body: some View {
        Button(action: {
            // Ação de compartilhar
        }) {
            HStack {
                Text("Compartilhar comprovante")
                    .font(Font(FontManager.body1Bold))
                    .foregroundColor(Color(ColorManager.secondary))
                    .padding(contentPadding)
                Spacer()
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color(ColorManager.secondary))
                    .padding(contentPadding)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(ColorManager.primary))
            .cornerRadius(16)
        }
    }
}

struct SkeletonListView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: .infinity, height: 40)

            ForEach(0..<4) { _ in
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 250, height: 40)
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 20)
            }
            .padding(.leading)
            .padding(.trailing)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: .infinity, height: 40)
            ForEach(0..<1) { _ in
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 250, height: 40)
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 20)
            }
            .padding(.leading)
            .padding(.trailing)
            Spacer()
        }

        .redacted(reason: .placeholder)
    }
}

struct SkeletonDetailsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 300, height: 40)

            ForEach(0..<4) { _ in
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 250, height: 40)
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 20)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: .infinity, height: 50)
        }
        .padding()
        .redacted(reason: .placeholder)
    }
}
