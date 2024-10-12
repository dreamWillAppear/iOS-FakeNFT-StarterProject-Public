import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // Text Colors
    static let ypTextPrimary = UIColor.ypBlack
    static let ypTextSecondary = UIColor.ypGreyUniversal
    static let ypTextOnPrimary = UIColor.ypWhite
    static let ypTextOnSecondary = UIColor.ypBlack

    static let ypWhite = UIColor(named: "YPWhite")
    static let ypBlack = UIColor(named: "YPBlack")
    static let ypLightGrey = UIColor(named: "YPLightGrey")
    static let ypWhiteUniversal = UIColor(named: "YPWhiteUniversal")
    static let ypBlackUniversal = UIColor(named: "YPBlackUniversal")
    static let ypBackgroundUniversal = UIColor(named: "YPBackgroundUniversal")
    static let ypBlueUniversal = UIColor(named: "YPBlueUniversal")
    static let ypGreyUniversal = UIColor(named: "YPGreyUniversal")
    static let ypGreenUniversal = UIColor(named: "YPGreenUniversal")
    static let ypRedUniversal = UIColor(named: "YPRedUniversal")
    static let ypYellowUniversal = UIColor(named: "YPYellowUniversal")
    
    static let segmentActive = UIColor.ypBlack

    static let segmentInactive = UIColor.ypLightGrey

    static let closeButton = UIColor.ypBlack
    
}


