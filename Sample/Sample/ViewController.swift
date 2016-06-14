//
//  ViewController.swift
//  Sample
//
//  Created by Magic on 9/5/2016.
//  Copyright © 2016 Magic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var sV: SunshineV = {
        let v = SunshineV(frame: CGRectMake(0, 0, 200, 200))
        v.font = UIFont.systemFontOfSize(30)
        v.textAlignment = .Center
        v.text = "Sunshine\nMagic"
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sample"
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        
        view.addSubview(sV)
        sV.center = view.center
        sV.run()
        
        changeColor()
        
    }
    
    func changeColor() {
        sV.highlightColor = .random
        sV.nomalColor = .random
        sV.shineColor = .random
        
        performSelector(#selector(ViewController.changeColor), withObject: nil, afterDelay: 5)
    }
}

extension UIColor {
    class var random: UIColor {
        return UIColor(hue: CGFloat(arc4random_uniform(255)) / 255, saturation: 1, brightness: 1, alpha: 1)
    }
}

