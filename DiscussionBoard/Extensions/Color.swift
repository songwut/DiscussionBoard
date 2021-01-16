//
//  Color.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 16/1/2564 BE.
//

import UIKit

extension UIColor {
    
    func add(overlay: UIColor) -> UIColor {
        var bgR: CGFloat = 0
        var bgG: CGFloat = 0
        var bgB: CGFloat = 0
        var bgA: CGFloat = 0
        
        var fgR: CGFloat = 0
        var fgG: CGFloat = 0
        var fgB: CGFloat = 0
        var fgA: CGFloat = 0
        
        self.getRed(&bgR, green: &bgG, blue: &bgB, alpha: &bgA)
        overlay.getRed(&fgR, green: &fgG, blue: &fgB, alpha: &fgA)
        
        let r = fgA * fgR + (1 - fgA) * bgR
        let g = fgA * fgG + (1 - fgA) * bgG
        let b = fgA * fgB + (1 - fgA) * bgB
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    struct Custom {
        static var theme: UIColor  { return primaryColor }
        static var darkGray = UIColor.darkGray
        static var green = UIColor(hex: "B2D234")
        static var progress = UIColor(hex: "fdaf18")
        static var pending = UIColor(hex: "fdaf18")
        static var failed = UIColor(hex: "ee1c25")
        static var red = UIColor(hex: "ee1c25")
        static var blue = UIColor(red: 52.0/255.0, green: 112/255.0, blue: 183/255.0, alpha: 1.0)
        
        static var black = UIColor.black
    }
    
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alphaOpa: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alphaOpa)
    }
    
    convenience init(gray:Int, alpha:CGFloat = 1.0) {
        assert(gray >= 0 && gray <= 255, "Invalid component")
        
        self.init(red: CGFloat(gray) / 255.0, green: CGFloat(gray) / 255.0, blue: CGFloat(gray) / 255.0, alpha: alpha)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex == "" ? "FFFFFF" : hex
        hexWithoutSymbol = hexWithoutSymbol.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.count) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    
}

extension UIColor {
    
    class func light(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hex: "FFFFFF").withAlphaComponent(alpha)//config-primary-color
    }
    
    class func background(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hex: "FBFBFB").withAlphaComponent(alpha)
    }
    
    class func primary(_ alpha: CGFloat = 1.0) -> UIColor {
        return primaryColor.withAlphaComponent(alpha)//config-primary-color
    }
    
    class func primary_10() -> UIColor {
        return primaryColor.withAlphaComponent(0.1)
    }

    class func primary_25() -> UIColor {
       return primaryColor.withAlphaComponent(0.25)
    }

    class func primary_50() -> UIColor {
       return primaryColor.withAlphaComponent(0.50)
    }

    class func primary_75() -> UIColor {
       return primaryColor.withAlphaComponent(0.75)
    }

    class func secondary(_ alpha: CGFloat = 1.0) -> UIColor {
        return secondaryColor.withAlphaComponent(alpha)//config-secondary-color
    }

    class func secondary_10() -> UIColor {
       return secondaryColor.withAlphaComponent(0.1)
    }

    class func secondary_25() -> UIColor {
       return secondaryColor.withAlphaComponent(0.25)
    }

    class func secondary_50() -> UIColor {
       return secondaryColor.withAlphaComponent(0.50)
    }

    class func secondary_75() -> UIColor {
       return secondaryColor.withAlphaComponent(0.75)
    }
    
    class func black() -> UIColor {
       return UIColor( red: (0.0)/255, green: (0.0)/255, blue: (0.0)/255, alpha: (1.00) );
    }

    class func error() -> UIColor {
       return UIColor( red: (249.0)/255, green: (50.0)/255, blue: (12.0)/255, alpha: (1.00) );
    }

    class func info() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (1.00) );
    }

    class func info_10() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (0.10) );
    }

    class func info_25() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (0.25) );
    }

    class func info_50() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (0.50) );
    }

    class func info_75() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (0.75) );
    }

    class func success() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (1.00) );
    }

    class func success_10() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (0.10) );
    }

    class func success_50() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (0.50) );
    }

    class func success_75() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (0.75) );
    }

    class func suceess_25() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (0.25) );
    }

    class func warning() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (1.00) );
    }

    class func warning_10() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (0.10) );
    }

    class func warning_25() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (0.25) );
    }

    class func warning_50() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (0.50) );
    }

    class func warning_75() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (0.75) );
    }

}
