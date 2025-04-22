import Foundation
import Checkout

/// Payment Form Utilities
public enum CardUtils {
    
    // MARK: - Methods
    
    /// Format the card number based on the card type
    /// e.g. Visa card: 4242 4242 4242 4242
    ///
    /// - parameter cardNumber: Card number
    /// - parameter cardType: Card type
    ///
    ///
    /// - returns: The formatted card number
    public static func format(cardNumber: String, scheme: Card.Scheme) -> String {
        var cardNumber = cardNumber
        
        for gap in scheme.cardGaps.sorted(by: >) where gap < cardNumber.count {
            cardNumber.insert(" ", at: cardNumber.index(cardNumber.startIndex, offsetBy: gap))
        }
        
        return cardNumber
    }
    
    public static func removeNonDigits(from string: String) -> String {
        return string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    /// Standardize the expiration date by removing non digits and spaces
    ///
    /// - parameter expirationDate: Expiration Date (e.g. 05/2020)
    ///
    ///
    /// - returns: Expiry month and expiry year (month: 05, year: 21)
    public static func standardize(expirationDate: String) -> (month: String, year: String) {
        let digitOnlyDate = expirationDate.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        switch digitOnlyDate.count {
        case ..<1:
            return (month: "", year: "")
        case ..<3:
            if let monthInt = Int(digitOnlyDate) {
                return  monthInt < 10 ? (month: "0\(digitOnlyDate)", year: "") : (month: digitOnlyDate, year: "")
            }
        case ...5:
            let indexEndMonth = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 2)
            let month = digitOnlyDate[..<indexEndMonth]
            let year = digitOnlyDate[indexEndMonth...]
            return (month: String(month), year: String(year))
        case 5...:
            let indexEndMonth = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 2)
            let indexStartYear = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 4)
            let month = digitOnlyDate[..<indexEndMonth]
            let year = digitOnlyDate[indexStartYear...]
            return (month: String(month), year: String(year))
        default:
            break
        }
        return (month: "", year: "")
    }
    
    /// Check if the card number is valid
    ///
    /// - parameter cardNumber: Card number
    ///
    ///
    /// - returns: true if the card number is valid, false otherwise
    public static func isValid(cardNumber: String) -> Bool {
        return luhnCheck(cardNumber: cardNumber)
    }

    
    /// Check if the cvv is valid based on the card type
    ///
    /// - parameter cvv: cvv (card verification value)
    /// - parameter cardType: Card type
    ///
    ///
    /// - returns: true if the cvv is valid, false otherwise
    public static func isValid(cvv: String, cardType: Card.Scheme) -> Bool {
        return cardType.cvvLengths.contains { $0 == cvv.count }
    }
    
    /// Get the type of the card based on the card number
    /// Note: the card number must be without spaces
    ///
    /// - parameter cardNumber: Card number
    ///
    ///
    /// - returns: The card type corresponding to the card number, nil if no card type is found
    public static func getTypeOf(cardNumber: String) -> Card.Scheme? {
        for type in Card.Scheme.allCases {
            guard let regex = type.fullCardNumberRegex else { continue }
            let range = NSRange(location: 0, length: cardNumber.utf16.count)
            if regex.firstMatch(in: cardNumber, options: [], range: range) != nil {
                return type
            }
        }
        return nil
    }
    
    static func luhnCheck(cardNumber: String) -> Bool {
        var sum = 0
        let digitStrings = cardNumber.reversed().map(String.init)
        
        for tuple in digitStrings.enumerated() {
            guard let digit = Int(tuple.element) else {
                return false
            }
            
            let odd = tuple.offset % 2 == 1
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        return sum % 10 == 0
    }
}
