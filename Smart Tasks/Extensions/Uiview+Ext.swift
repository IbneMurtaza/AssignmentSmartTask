//
//  Uiview+Ext.swift
//  SafeHerDriver
//
//  Created by TGI on 4/19/23.
//

import Foundation
import UIKit

extension UIView {

    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func setShadow(_ side:ShadowSide, shadowColor:UIColor, shadowRadius:CGFloat, shadowOpacity:Float = 1.0, cornerRadius: CGFloat){
        switch side {
            
        case .top:
            self.layer.shadowOffset = CGSize(width: 0, height: -shadowRadius)
            
        case .left:
            self.layer.shadowOffset = CGSize(width: -shadowRadius, height: 0)
            
        case .right:
            self.layer.shadowOffset = CGSize(width: shadowRadius, height: 0)
            
        case .bottom:
            self.layer.shadowOffset = CGSize(width: 0, height: shadowRadius)
            
        case .all:
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @IBInspectable var makeCircle: Bool {
        get {
            return self.layer.cornerRadius > 0
        }
        set {
            if newValue == true {
                self.layer.cornerRadius = self.layer.frame.height / 2
            }
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.lightGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                   shadowOpacity: Float = 1,
                   shadowRadius: CGFloat = 2.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    //MARK: - Shake a View
    
   
    
    
    func fadeIn(duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
//        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
//            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
//        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.isHidden = true
            
//            self.alpha = 0.0
        }, completion: completion)
    }
    
    
    func hideAnimated(in stackView: UIStackView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = true
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }

    func showAnimated(in stackView: UIStackView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = false
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
}

@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = .init(red: 32, green: 146, blue: 62, alpha: 1) { didSet { updateColors() }}
    
//    @IBInspectable var midColor:     UIColor = .init(red: 41, green: 219, blue: 87, alpha: 1) { didSet { updateColors() }}

    @IBInspectable var endColor:     UIColor = .init(red: 81, green: 216, blue: 87, alpha: 1) { didSet { updateColors() }}
    
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.75 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
        @IBInspectable var dashWidth: CGFloat = 0
        @IBInspectable var dashColor: UIColor = .clear
        @IBInspectable var dashLength: CGFloat = 0
        @IBInspectable var betweenDashesSpace: CGFloat = 0

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var dashBorder: CAShapeLayer?
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    var shouldUpdateColor = true
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        if shouldUpdateColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        } else {
            gradientLayer.colors = []
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
    
//    func updateColors() {
//        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//    }
       override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
// midColor.cgColor,
    
    enum dashedOrientation {
          case horizontal
          case vertical
      }
      
      func makeDashedBorderLine(color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat, orientation: dashedOrientation) {
          let path = CGMutablePath()
          let shapeLayer = CAShapeLayer()
          shapeLayer.lineWidth = width
          shapeLayer.strokeColor = color.cgColor
          shapeLayer.lineDashPattern = [strokeLength, gapLength]
          
          if orientation == .vertical {
              path.addLines(between: [CGPoint(x: bounds.midX, y: bounds.minY),
                                      CGPoint(x: bounds.midX, y: bounds.maxY)])
          } else if orientation == .horizontal {
              path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.midY),
                                      CGPoint(x: bounds.maxX, y: bounds.midY)])
          }
          shapeLayer.path = path
          layer.addSublayer(shapeLayer)
          
      }
    
  
}

enum ShadowSide {
    case top
    case left
    case right
    case bottom
    case all
}
extension UIView {

    // there can be other views between `subview` and `self`
    func getConvertedFrame(fromSubview subview: UIView) -> CGRect? {
        // check if `subview` is a subview of self
        guard subview.isDescendant(of: self) else {
            return nil
        }
        
        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }
        
        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview!.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }
        
        return superview!.convert(frame, to: self)
    }

}
