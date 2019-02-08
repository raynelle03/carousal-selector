//
//  CarousalSelectorCell.swift
//  Networking_Ray
//
//  Created by Raynelle on 24/01/2019.
//  Copyright © 2019 Raynelle. All rights reserved.
//


import UIKit
class CarousalSelectorCell: UICollectionViewCell {
    var animateOncell = 0
    @IBOutlet var itemSelectedButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewSelected: UIView!
    @IBOutlet var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setSelectedOrange() {
        viewSelected.layer.borderWidth = 2.0
        viewSelected.layer.masksToBounds = false
        viewSelected.layer.borderColor = UIColor.blue.cgColor 
        viewSelected.layer.cornerRadius = viewSelected.frame.size.height/2
        viewSelected.clipsToBounds = true
        if animateOncell == 1 {
            viewSelected.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.viewSelected.isHidden = false
            }
            animateOncell = 0
        }
    }
    func setUnselectedOrange() {
        viewSelected.layer.borderWidth = 0.0
        viewSelected.layer.masksToBounds = false
        viewSelected.layer.borderColor = UIColor.clear.cgColor
    }
    func setBorderColor(color: UIColor) {
        imageView.layer.borderWidth = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
    }

    func setUnselectedBlue() {
        imageView.layer.borderWidth = 0.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.clear.cgColor
    }

    func shakeEffect(view: UIView, duration: Double = 0.25, displacement: CGFloat = 1.0, degreesRotation: CGFloat = 2.0) {
            CATransaction.begin()
            let negativeDisplacement = -1.0 * displacement
            let position = CAKeyframeAnimation.init(keyPath: "position")
            position.beginTime = 0.8
            position.duration = duration
            position.values = [
                NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement)),
                NSValue(cgPoint: CGPoint(x: 0, y: 0)),
                NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: 0)),
                NSValue(cgPoint: CGPoint(x: 0, y: negativeDisplacement)),
                NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement))
            ]
            position.calculationMode = .linear
            position.isRemovedOnCompletion = false
            position.repeatCount = Float.greatestFiniteMagnitude
            position.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))
            position.isAdditive = true

            let transform = CAKeyframeAnimation.init(keyPath: "transform")
            transform.beginTime = 2.6
            transform.duration = duration
        transform.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateZ)
            transform.values = [
                degreesToRadians(x: -1.0 * degreesRotation),
                degreesToRadians(x: degreesRotation),
                degreesToRadians(x: -1.0 * degreesRotation)
            ]
            transform.calculationMode = .linear
            transform.isRemovedOnCompletion = false
            transform.repeatCount = Float.greatestFiniteMagnitude
            transform.isAdditive = true
            transform.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))

            view.layer.add(position, forKey: "position")
            view.layer.add(transform, forKey: "transform")
            CATransaction.commit()
    }

    func degreesToRadians(x: CGFloat) -> CGFloat {
        return CGFloat(Double.pi) * x / 180.0
    }

}
