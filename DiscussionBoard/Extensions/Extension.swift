//
//  Extension.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import Foundation
import UIKit
//import RxSwift
//import RxGesture

class Tap: UITapGestureRecognizer {
    
}

enum StyleName: CGFloat {
    case hero1 = 96.0
    case hero2 = 88.0
    case hero3 = 72.0
    case hero4 = 56.0
    case hero5 = 48.0

    case heading1 = 40.0
    case heading2 = 32.0
    case heading3 = 28.0
    case heading4 = 24.0
    case heading5 = 22.0
    case heading6 = 18.0

    //Body
    case paragraph = 16.0
    case small = 13.0
    case xsmall = 12.0
    case xxsmall = 10.0
}

enum AppFont: Int {
    case regular = 0
    case italic = 1
    case lightItalic = 2
    
    case text = 3
    case medium = 4
    case bold = 5
    
    func fontName() -> String {
        var fontName: String!
        switch self {
        //design system
        case .text: fontName = fontConicleText
        case .medium: fontName = fontConicleMedium
        case .bold: fontName = fontConicleBold
            
        case .regular: fontName = fontConicleText
        case .italic: fontName = fontConicleText
        case .lightItalic: fontName = fontConicleText
        }
        
        assert(fontName != nil)
        return fontName
    }
    
}

class FontHelper {
    //design system
    class func getFontSystem(_ size: StyleName, font: AppFont) -> UIFont {
        return UIFont(name: font.fontName(), size: size.rawValue)!
    }
    
    class func getFont(_ font: AppFont, rawSize: CGFloat) -> UIFont {
        return UIFont(name: font.fontName(), size: rawSize)!
    }
}

open class DidAction {
    var handler: ((_ sender: Any?) -> Void)!
    
    init(handler: @escaping ((_ sender: Any?) -> Void)) {
        self.handler = handler
    }
 
    
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class  var  className: String {
        return String(describing: self)
    }
}

extension UIView {
    
    private struct VAction {
        static var _property = [String:DidAction?]()
    }
    
    var action:DidAction? {
        get {
            return VAction._property[self.debugDescription] ?? nil
        }
        set(newValue) {
            VAction._property[self.debugDescription] = newValue
        }
    }
    
    enum ViewSide {
        case left, right, top, bottom
    }
    //var action: DidAction?
    func addAction(_ action: DidAction) {
        self.action = action
    }
    /*
    func addAction(_ complete: @escaping (_ object: Any) -> Void) {
        let stepBag = DisposeBag()
        self.rx
        .tapGesture()
        .when(.recognized)
            .subscribe({ _ in
            complete(self)
        })
        .disposed(by: stepBag)
    }
    */
    
    func setInputStyle() {
        self.backgroundColor = UIColor(hex:"FAFAFA")
        self.borderColor = .lightGray
        self.borderWidth = 1
        self.cornerRadius = 4
    }
    
    func setUITestId(_ identifier :String) {
        self.accessibilityIdentifier = identifier
    }
    
    func setBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
        case .bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        }
        
        layer.addSublayer(border)
    }
    
    open class func heightAspect(width:CGFloat) -> CGFloat {
        let aspectHeight = width * CGFloat(coverImageRatio)
        return aspectHeight
    }
    
    func addConstraintsWithFormat(format:String, views: UIView...){
        
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func setWidthConstraint(_ width: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeightConstraint(_ height: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    class var noContentLabel: UILabel {
        let label = UILabel()
        label.font = FontHelper.getFontSystem(.paragraph, font: .text)
        label.textColor = UIColor.gray
        return label
    }
    
    func loadNibWithNamed<T: UIView>(_ viewType: T.Type) -> UIView {
        
        var view: UIView
        guard let  bundle = Bundle(identifier: Bundle.main.bundleIdentifier!) else {
            return T()
        }
        
        let nibArray = bundle.loadNibNamed(self.className, owner: self, options: nil)
        if let nibView = nibArray?.first as? UIView {
            view = nibView
        } else {
            print("Error loading view for storyboard preview. Couldn't find view named \(self.className)")
            view = UIView()
        }
        
        return view
    }
    
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.black.cgColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    //Apply params
    func updateView() {
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            } else { return .none }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func updateLayout() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setShadow(radius:CGFloat, opacity:Float,color:UIColor = UIColor.black, offset:CGSize = CGSize.zero) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func dropShadow(scale: Bool = true) {
        /*
         self.layer.shadowColor = UIColor.black.cgColor
         self.layer.shadowOpacity = 0.23
         self.layer.shadowOffset = CGSize.zero
         self.layer.shadowRadius = 3
         self.layer.masksToBounds = false
        */
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.18
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    func shakeUI() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }) { (done) in
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(rotationAngle: .pi / 2)
            }) { (done) in
                
            }
        }
    }
    
    func shake(_ countLoop: Int = 0) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.8
        animation.values = [-12.0, 12.0, -9.0, 9.0, -6.0, 6.0, 3.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
    
    func setGradientBackground(_ colorOne: UIColor, _ colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 4.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func animatejump(_ delay:TimeInterval = 0) {
        
        UIView.animate(withDuration: 0.6, delay: 0 + delay, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finished) in
            
        }
        UIView.animate(withDuration: 0.3, delay: 0.3 + delay, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (finished) in
            
        }
    }
}



extension String {
    private static let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
    private static let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
    private static let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,6}"
    
    public var isEmail: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__emailRegex)
        return predicate.evaluate(with: self)
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func hexToStr() -> String {
        
        let regex = try! NSRegularExpression(pattern: "(0x)?([0-9A-Fa-f]{2})", options: .caseInsensitive)
        let textNS = self as NSString
        let matchesArray = regex.matches(in: textNS as String, options: [], range: NSMakeRange(0, textNS.length))
        let characters = matchesArray.map {
            Character(UnicodeScalar(UInt32(textNS.substring(with: $0.range(at: 2)), radix: 16)!)!)
        }
        
        return String(characters)
    }
    
    
    func uppercasedFirstText() -> String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    mutating func uppercasedFirstText() {
        self = self.uppercasedFirstText()
    }
    
    func getUnderLineAttributedText() -> NSAttributedString {
        return NSMutableAttributedString(string: self,
                                         attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    func toTimeReadable() -> String {
        //"00:12:00" to 12:00 min
        var unitText = "hour"
        let array = self.components(separatedBy: ":")
        if array.count == 3 {
            let hour = array[0]
            let min = array[1]
            let sec = array[2]
            
            if hour == "00", min == "00", sec == "00" {
                return self
                
            } else if hour == "00", min == "00" {
                return "\(sec) sec"
                
            } else if hour == "00" {
                return "\(min):\(sec) min"
                
            }
        }
        return self
    }
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    mutating func replace(_ originalString:String, with newString:String) {
        self = self.replacingOccurrences(of: originalString, with: newString)
    }
    
    var floatValue: Float {
        (self as NSString).floatValue
    }
    
    var intValue: Int {
        if self == "" {
            return 0
        } else {
            return Int(self.floatValue)
        }
    }
    /*
     var lines:[String] {
     var result:[String] = []
     enumerateLines{ result.append($0.line) }
     return result
     }
     
     var managedString:String {
     var managedStr = ""
     for str in self.lines {
     managedStr = "\(managedStr)\n\(str)"
     }
     return managedStr
     }
     */
    // MARK: - Validate data
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    var bool: Bool {
        let lowercase = self.lowercased()
        print("lowercase", lowercase)
        switch lowercase {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return false
        }
    }
    /*
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    */
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func widthFrom(font: UIFont) -> CGFloat {
        //let fontAttributes = [NSAttributedString.Key.font: font] swift 4
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightFrom(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func heightFrom(font: UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    var data: Data {
        return Data(utf8)
    }
    var html2AttributedString: NSAttributedString? {
        do {
            // Create audio player object
            let attrStr = try NSAttributedString(
                data: self.data(using: String.Encoding.unicode, allowLossyConversion: false)!,
                options:[.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attrStr
        }
        catch {
            return nil
        }
        
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func filterAndHighlightTextAttributes(completeString: String, highlightTextfont: UIFont?) -> NSMutableAttributedString {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: completeString)
        let pattern = self.lowercased()
        let range: NSRange = NSMakeRange(0, completeString.count)
        var regex = NSRegularExpression()
        do {
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
            regex.enumerateMatches(in: completeString.lowercased(), options: NSRegularExpression.MatchingOptions(), range: range) {
                (textCheckingResult, matchingFlags, stop) in
                let subRange = textCheckingResult?.range
                let attributes : [NSAttributedString.Key : Any] = [.font : highlightTextfont ?? UIFont.boldSystemFont(ofSize: 16)]
                attributedString.addAttributes(attributes, range: subRange!)
            }
        } catch {
            print(error.localizedDescription)
        }
        return attributedString
    }
    
}

protocol ReuseIdentifiable {
    static func reuseId() -> String
}

extension ReuseIdentifiable {
    static func reuseId() -> String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifiable {}
extension UICollectionViewCell: ReuseIdentifiable {}
