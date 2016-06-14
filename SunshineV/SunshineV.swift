//
//  SunshineV.swift
//  Sample
//
//  Created by Magic on 14/6/2016.
//  Copyright © 2016 Magic. All rights reserved.
//

import Foundation
import CoreText
import QuartzCore
import UIKit

private let kHFShowBtnAnimationKey = "kHFShowBtnAnimationKey"

class SunshineV: UIControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(gradientLy)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    var nomalColor = UIColor(white: 0.7, alpha: 1) { didSet{ refreshColor() } }
    var highlightColor = UIColor(white: 1, alpha: 1) { didSet{ refreshColor() } }
    var shineColor = UIColor(red: 105/255, green: 128/255, blue: 1, alpha: 1) { didSet{ refreshColor() } }
    var textAlignment: NSTextAlignment = .Left {
        didSet{ textLy.alignmentMode = textAlignment.alignmentMode }
    }
    
    private func refreshColor() {
        gradientLy.colors = gradientLy.animationForKey(kHFShowBtnAnimationKey) == nil ? nomalColors:highlightColors
    }
    
    private var nomalColors: [CGColor] {
        return [nomalColor.CGColor,
                shineColor.CGColor,
                nomalColor.CGColor]
    }
    
    private var highlightColors: [CGColor] {
        return [highlightColor.CGColor,
                shineColor.CGColor,
                highlightColor.CGColor]
    }
    
    // MARK: - UI
    private lazy var gradientLy: CAGradientLayer = {
        let ly = CAGradientLayer()
        ly.startPoint = CGPointMake(-1, -1)
        ly.endPoint = CGPointMake(0, 0)
        ly.colors = self.nomalColors
        ly.mask = self.textLy
        return ly
    }()
    
    private lazy var textLy: CATextLayer = {
        let ly = CATextLayer()
        ly.contentsScale = UIScreen.mainScreen().scale
        ly.backgroundColor = UIColor.clearColor().CGColor
        ly.fontSize = 16
        return ly
    }()
    
    // MARK: - Method
    var text: String {
        set{ textLy.string = newValue}
        get{ return textLy.string as? String ?? ""}
    }
    
    override var frame: CGRect {
        didSet { [gradientLy, textLy].forEach{ $0.frame = bounds } }
    }
    
    var font: UIFont {
        set(ft) {
            var i = CGAffineTransformIdentity
            let ctFont = CTFontCreateWithName(ft.fontName, ft.pointSize, &i)
            textLy.font = ctFont
            textLy.fontSize = ft.pointSize
            setNeedsLayout()
        }
        get {
            let ctFont = textLy.font as! CTFont
            let fontName = CTFontCopyName(ctFont, kCTFontPostScriptNameKey)
            let fontSize: CGFloat = CTFontGetSize(ctFont)
            return UIFont(name: String(fontName), size: fontSize)!
        }
    }
    
    func run() {
        guard gradientLy.animationForKey(kHFShowBtnAnimationKey) == nil else { return }
        
        gradientLy.colors = highlightColors
        let startPointAnm = CABasicAnimation(keyPath: "startPoint")
        startPointAnm.toValue = NSValue(CGPoint: CGPointMake(1.0, 0))
        startPointAnm.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let endPointAnm = CABasicAnimation(keyPath: "endPoint")
        endPointAnm.toValue = NSValue(CGPoint: CGPointMake(2.0, 0))
        endPointAnm.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let group = CAAnimationGroup()
        group.animations = [startPointAnm,endPointAnm]
        group.speed = 0.1
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        group.repeatCount = FLT_MAX
        gradientLy.addAnimation(group, forKey: kHFShowBtnAnimationKey)
    }
    
    func stop() {
        if gradientLy.animationForKey(kHFShowBtnAnimationKey) != nil {
            gradientLy.removeAnimationForKey(kHFShowBtnAnimationKey)
        }
        gradientLy.colors = nomalColors
    }
}

private extension NSTextAlignment {
    var alignmentMode: String {
        switch self {
        case .Left:
            return kCAAlignmentLeft
        case .Center:
            return kCAAlignmentCenter
        case .Right:
            return kCAAlignmentRight
        case .Justified:
            return kCAAlignmentJustified
        case .Natural:
            return kCAAlignmentNatural
        }
    }
}