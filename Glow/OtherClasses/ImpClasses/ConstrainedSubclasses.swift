//  Created by iOS Development Company on 01/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit


//MARK: - Constained Classes for All device support
/// Below all calssed reduces text of button and Lavel according to device screen size
class KPFixButton: UIButton {
    override func awakeFromNib() {
        if let img = self.imageView{
            let btnsize = self.frame.size
            let imgsize = img.frame.size
            let verPad = ((btnsize.height - (imgsize.height * _widthRatio)) / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: verPad, left: 0, bottom: verPad, right: 0)
            self.imageView?.contentMode = .scaleAspectFit
        }
        if let afont = titleLabel?.font {
            titleLabel?.font = afont.withSize(afont.pointSize * _widthRatio)
        }
    }
}

class KPWidthButton: UIButton {
    override func awakeFromNib() {
        if let img = self.imageView{
            img.contentMode = .scaleAspectFit
            let padding = 12.widthRatio
            self.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: 20.widthRatio, right: padding)
        }
        if let afont = titleLabel?.font {
            titleLabel?.font = afont.withSize(afont.pointSize * _widthRatio)
        }
    }
}

class JPWidthTextField: UITextField {
    @IBInspectable var letterSpace : CGFloat = 0{
        didSet{
            letterSpace = letterSpace * _widthRatio
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = font {
            font = afont.withSize(afont.pointSize * _widthRatio)
        }
        
        if let place = placeholder{
            self.addCharactersSpacingInPlaceHolder(spacing: letterSpace, text: place)
        }
        
        if let txt = text{
            self.addCharactersSpacingInTaxt(spacing: letterSpace, text: txt)
        }
    }
}

class JPHeightTextField: UITextField {
    @IBInspectable var letterSpace : CGFloat = 0{
        didSet{
            letterSpace = letterSpace * _heightRatio
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = font {
            font = afont.withSize(afont.pointSize * _heightRatio)
        }
        
        if let place = placeholder{
            self.addCharactersSpacingInPlaceHolder(spacing: letterSpace, text: place)
        }
        if let txt = text{
            self.addCharactersSpacingInTaxt(spacing: letterSpace, text: txt)
        }
    }
}


class JPWidthTextView: UITextView {
    @IBInspectable var letterSpace : CGFloat = 0{
        didSet{
            letterSpace = letterSpace * _heightRatio
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = font {
            font = afont.withSize(afont.pointSize * _widthRatio)
        }
        if let txt = text{
            self.addCharactersSpacingInTaxt(spacing: letterSpace, text: txt)
        }
    }
}

class JPTextView: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.hexStringToUIColor(hexStr: "2D2D41", alpha: 0.4).cgColor
        tintColor = UIColor.hexStringToUIColor(hexStr: "2D2D41", alpha: 1.0)
        textColor = UIColor.hexStringToUIColor(hexStr: "2D2D41", alpha: 1.0)
        textContainerInset = UIEdgeInsets(top: 12.widthRatio, left: 7, bottom: 0, right: 0)
        font = UIFont.DUCEFontWith(.sfProDisplayRegular, size: 16.widthRatio)
    }
}

class JPWidthButton: UIButton {
    @IBInspectable var letterSpace : CGFloat = 0{
        didSet{
            letterSpace = letterSpace * _widthRatio
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = titleLabel?.font {
            titleLabel?.font = afont.withSize(afont.pointSize * _widthRatio)
        }
        if let title = titleLabel?.text{
            titleLabel?.addCharactersSpacing(spacing: letterSpace, text: title)
        }
    }
}

class JPHeightButton: UIButton {
    @IBInspectable var letterSpace : CGFloat = 0{
        didSet{
            letterSpace = letterSpace * _heightRatio
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = titleLabel?.font {
            titleLabel?.font = afont.withSize(afont.pointSize * _heightRatio)
        }
        if let title = titleLabel?.text{
            titleLabel?.addCharactersSpacing(spacing: letterSpace, text: title)
        }
    }
}

class KPWidthAttriLabel: UILabel {
    
    @IBInspectable var letterSpace : CGFloat = 0 {
        didSet{
            letterSpace = letterSpace * _widthRatio
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let att = self.attributedText{
            let str = att.string as NSString
            let range = str.range(of: att.string)
            let newAttriString = NSMutableAttributedString(attributedString: att)
            att.enumerateAttributes(in: range, options: [], using: { (attri, range, pointer) in
                if let font = attri[NSAttributedString.Key.font] as? UIFont{
                    let newFont = font.withSize(font.pointSize * _widthRatio)
                    newAttriString.addAttributes([NSAttributedString.Key.font: newFont], range: range)
                }
            })
            self.attributedText = newAttriString
        }
        if let _ = text{
            //            addCharactersSpacing(spacing: letterSpace, text: title)
        }
    }
}


class JPWidthLabel: UILabel {
    @IBInspectable var letterSpace : CGFloat = 0 {
        didSet{
            letterSpace = letterSpace * _widthRatio
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _widthRatio)
        if let title = text{
            addCharactersSpacing(spacing: letterSpace, text: title)
        }
    }
}

class BlurredLabel: UILabel {
    
    var isBlurring = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var blurRadius: Double = 2.5 {
        didSet {
            blurFilter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
        }
    }

    lazy var blurFilter: CIFilter? = {
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setDefaults()
        blurFilter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
        return blurFilter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.isOpaque = false
        layer.needsDisplayOnBoundsChange = true
        layer.contentsScale = UIScreen.main.scale
        layer.contentsGravity = .center
        isOpaque = false
        isUserInteractionEnabled = false
        contentMode = .redraw
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func display(_ layer: CALayer) {
        let bounds = layer.bounds
        guard !bounds.isEmpty && bounds.size.width < CGFloat(UINT16_MAX) else {
            layer.contents = nil
            return
        }
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, layer.contentsScale)
        if let ctx = UIGraphicsGetCurrentContext() {
            self.layer.draw(in: ctx)
        
            var image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
            if isBlurring, let cgImage = image {
                blurFilter?.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
                let ciContext = CIContext(cgContext: ctx, options: nil)
                if let blurOutputImage = blurFilter?.outputImage,
                   let cgImage = ciContext.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
                    image = cgImage
                }
            }
            layer.contents = image
        }
        UIGraphicsEndImageContext()
    }
}

class JPHeightLabel: UILabel {
    @IBInspectable var letterSpace : CGFloat = 0{
        didSet{
            letterSpace = letterSpace * _heightRatio
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _heightRatio)
        if let title = text{
            addCharactersSpacing(spacing: letterSpace, text: title)
        }
    }
}

class KPWidthAttriButton: JPWidthButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let att = self.currentAttributedTitle{
            let str = att.string as NSString
            let range = str.range(of: att.string)
            let newAttriString = NSMutableAttributedString(attributedString: att)
            att.enumerateAttributes(in: range, options: [], using: { (attri, range, pointer) in
                if let font = attri[NSAttributedString.Key.font] as? UIFont{
                    let newFont = font.withSize(font.pointSize * _widthRatio)
                    newAttriString.addAttributes([NSAttributedString.Key.font: newFont], range: range)
                }
            })
            self.setAttributedTitle(newAttriString, for: UIControl.State.normal)
        }
        
        if let afont = titleLabel?.font {
            titleLabel?.font = afont.withSize(afont.pointSize * _widthRatio)
        }
    }
}

/// This View contains collection of Horizontal and Vertical constrains. Who's constant value varies by size of device screen size.
class ConstrainedControl: UIControl {
    
    // MARK: Outlets
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    // MARK: Awaken
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintUpdate()
    }
    
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heightRatio
                const.constant = v2
            }
        }
    }
}


class ConstrainedView: UIView {
    
    // MARK: Outlets
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    // MARK: Awaken
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintUpdate()
    }
    
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heightRatio
                const.constant = v2
            }
        }
    }
}

class GenericTableViewCell: ConstrainedTableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var imgv: UIImageView!
    @IBOutlet var lblSeprator : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

/// This Collection view cell contains collection of Horizontal and Vertical constrains. Who's constant value varies by size of device screen size.
class ConstrainedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintUpdate()
    }
    
    // This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heightRatio
                const.constant = v2
            }
        }
    }
    
    // MARK: Activity
    lazy internal var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: kActivityButtonImageName)!
        return CustomActivityIndicatorView(image: image)
    }()
    
    lazy internal var smallActivityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: kActivitySmallImageName)!
        return CustomActivityIndicatorView(image: image)
    }()
    
    func showSmallSpinnerIn(container: UIView, control: UIButton, isCenter: Bool) {
        container.addSubview(smallActivityIndicator)
        let xConstraint = NSLayoutConstraint(item: smallActivityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: -8.5)
        let yConstraint = NSLayoutConstraint(item: smallActivityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -8.5)
        smallActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        smallActivityIndicator.alpha = 0.0
        layoutIfNeeded()
        isUserInteractionEnabled = false
        smallActivityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.smallActivityIndicator.alpha = 1.0
            if isCenter{
                control.alpha = 0.0
            }
        }
    }
    
    func hideSmallSpinnerIn(container: UIView, control: UIButton) {
        isUserInteractionEnabled = true
        smallActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.smallActivityIndicator.alpha = 0.0
            control.alpha = 1.0
        }
    }
    
    // This will show and hide spinner. In middle of container View
    // You can pass any view here, Spinner will be placed there runtime and removed on hide.
    func showSpinnerIn(container: UIView, control: UIButton, isCenter: Bool) {
        container.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
        let xPoint: CGFloat!
        if isCenter {
            xPoint = -10
        }else{
            let str = control.title(for: .selected)
            control.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
            xPoint = (str!.WidthWithNoConstrainedHeight(font: (control.titleLabel?.font)!)/2) - 5
        }
        
        let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: xPoint)
        let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -10)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        activityIndicator.alpha = 0.0
        layoutIfNeeded()
        isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.activityIndicator.alpha = 1.0
            if isCenter{
                control.alpha = 0.0
            }
        }
    }
    
    
    func hideSpinnerIn(container: UIView, control: UIButton) {
        isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        control.contentEdgeInsets = UIEdgeInsets.zero
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.activityIndicator.alpha = 0.0
            control.alpha = 1.0
        }
        
    }
}

/// This Header view cell contains tableview of Horizontal and Vertical constrains. Who's constant value varies by size of device screen size.
class ConstrainedHeaderTableView: UITableViewHeaderFooterView {
    
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintUpdate()
    }
    
    // This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heightRatio
                const.constant = v2
            }
        }
    }
}



/// This Table view cell contains collection of Horizontal and Vertical constrains. Who's constant value varies by size of device screen size.
class ConstrainedTableViewCell: UITableViewCell {
    
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        constraintUpdate()
    }
    
    // This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heightRatio
                const.constant = v2
            }
        }
    }
    
    
    // MARK: Activity
    lazy internal var activityIndicator : UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        act.color = UIColor.white
        return act
    }()
    
    lazy internal var smallActivityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: kActivitySmallImageName)!
        return CustomActivityIndicatorView(image: image)
    }()
    
    func showSmallSpinnerIn(container: UIView, control: UIControl, isCenter: Bool) {
        container.addSubview(smallActivityIndicator)
        let xConstraint = NSLayoutConstraint(item: smallActivityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: -8.5)
        let yConstraint = NSLayoutConstraint(item: smallActivityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -8.5)
        smallActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        smallActivityIndicator.alpha = 0.0
        layoutIfNeeded()
        isUserInteractionEnabled = false
        smallActivityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.smallActivityIndicator.alpha = 1.0
            if isCenter{
                control.alpha = 0.0
            }
        }
    }
    
    func hideSmallSpinnerIn(container: UIView, control: UIControl) {
        isUserInteractionEnabled = true
        smallActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.smallActivityIndicator.alpha = 0.0
            control.alpha = 1.0
        }
    }
    
    // This will show and hide spinner. In middle of container View
    // You can pass any view here, Spinner will be placed there runtime and removed on hide.
    func showSpinnerIn(container: UIView, control: UIButton, isCenter: Bool) {
        container.addSubview(activityIndicator)
        
        let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        activityIndicator.alpha = 0.0
        layoutIfNeeded()
        isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.activityIndicator.alpha = 1.0
            if isCenter{
                control.alpha = 0.0
            }
        }
    }
    
    
    func hideSpinnerIn(container: UIView, control: UIButton) {
        isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        control.contentEdgeInsets = UIEdgeInsets.zero
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.activityIndicator.alpha = 0.0
            control.alpha = 1.0
        }
    }
}
