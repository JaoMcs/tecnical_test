//
//  Extension.swift
//  testedasd
//
//  Created by João Marcos on 19/09/24.
//

import UIKit

extension UIImage {
    func resized(_ size: CGSize) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resized(_ size: CGFloat) -> UIImage? {
        guard size > 0, self.size.width > 0, self.size.height > 0 else { return nil }
        let ratio = size / max(self.size.width, self.size.height)
        return self.resized(self.size * ratio)
    }

    func refilled(_ color: UIColor) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.set()
        UIGraphicsGetCurrentContext()?.fill(CGRect(origin: .zero, size: self.size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    public convenience init?(color: UIColor = .clear, size: CGSize) {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor);
        context.fill(CGRect(origin: .zero, size: size));
        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }

        self.init(cgImage: cgImage)
    }
}

extension UISegmentedControl {
    func removeBorders() {
        let image = UIImage(size: self.bounds.size)
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setDividerImage(image?.resized(1), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}

func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}

extension String {
    var isCPF: Bool {
        let numbers = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard numbers.count == 11 else { return false }

        let set = NSCountedSet(array: Array(numbers))
        guard set.count != 1 else { return false }

        let i1 = numbers.index(numbers.startIndex, offsetBy: 9)
        let i2 = numbers.index(numbers.startIndex, offsetBy: 10)
        let i3 = numbers.index(numbers.startIndex, offsetBy: 11)
        let d1 = Int(numbers[i1..<i2])
        let d2 = Int(numbers[i2..<i3])

        var temp1 = 0, temp2 = 0

        for i in 0...8 {
            let start = numbers.index(numbers.startIndex, offsetBy: i)
            let end = numbers.index(numbers.startIndex, offsetBy: i+1)
            let char = Int(numbers[start..<end])

            temp1 += char! * (10 - i)
            temp2 += char! * (11 - i)
        }

        temp1 %= 11
        temp1 = temp1 < 2 ? 0 : 11-temp1

        temp2 += temp1 * 2
        temp2 %= 11
        temp2 = temp2 < 2 ? 0 : 11-temp2

        return temp1 == d1 && temp2 == d2
    }

    func formattedDateString() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = inputFormatter.date(from: self) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            outputFormatter.dateFormat = "d 'de' MMMM"
            outputFormatter.locale = Locale(identifier: "pt_BR")
            let formattedDate = outputFormatter.string(from: date)
            return "Hoje - " + formattedDate
        } else {
            outputFormatter.dateFormat = "EEEE - d 'de' MMMM"
            outputFormatter.locale = Locale(identifier: "pt_BR")
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        }
    }

    func formatToTime() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "pt_BR")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = inputFormatter.date(from: self) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        return outputFormatter.string(from: date)
    }

    func formattedCPFOrCNPJ() -> String {
        let numbersOnly = self.filter { $0.isNumber }

        if numbersOnly.count == 11 {
            return numbersOnly.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{3})(\\d{2})",
                                                    with: "$1.$2.$3-$4",
                                                    options: .regularExpression,
                                                    range: nil)
        } else if numbersOnly.count == 14 {
            return numbersOnly.replacingOccurrences(of: "(\\d{2})(\\d{3})(\\d{3})(\\d{4})(\\d{2})",
                                                    with: "$1.$2.$3/$4-$5",
                                                    options: .regularExpression,
                                                    range: nil)
        } else {
            return self
        }
    }
}



extension Int {
    func toBrazilianCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "R$"
        formatter.locale = Locale(identifier: "pt_BR")

        let number = NSNumber(value: self)

        return formatter.string(from: number) ?? "R$ 0,00"
    }
}
