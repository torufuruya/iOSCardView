//
//  CardViewCell.swift
//  iOSCardView
//
//  Created by Toru Furuya on 2018/01/20.
//  Copyright © 2018年 toru.furuya. All rights reserved.
//

import UIKit

class CardViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!

    var numberOfRows = 0
    var indexPath: IndexPath? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //Show tap interaction
//        if selected {
////            view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//            view.layer.sublayers?.first?.backgroundColor = UIColor.black.withAlphaComponent(0.1).cgColor
//            UIView.animate(withDuration: 0.5, animations: {
////                self.view.backgroundColor = .white
//                self.view.layer.sublayers?.first?.backgroundColor = UIColor.white.cgColor
//            })
//        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //Remove created mask to reuse for another cell
        if let mask = view.layer.mask {
            mask.removeFromSuperlayer()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //To draw appropriate layout first
//        roundCorner()

        if numberOfRows == 1 {
            makeShadowToLayer(layer: view.layer, corners: .allCorners, cornerRadius: 5)
        } else if indexPath?.row == 0 {
            makeShadowToLayer(layer: view.layer, corners: [.topLeft, .topRight], cornerRadius: 5)
        } else if indexPath?.row == numberOfRows - 1 {
            makeShadowToLayer(layer: view.layer, corners: [.bottomLeft, .bottomRight], cornerRadius: 5)
        } else {
            makeShadowToLayer(layer: view.layer, corners: [], cornerRadius: 0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        roundCorner()

        if numberOfRows == 1 {
            makeShadowToLayer(layer: view.layer, corners: .allCorners, cornerRadius: 5)
        } else if indexPath?.row == 0 {
            makeShadowToLayer(layer: view.layer, corners: [.topLeft, .topRight], cornerRadius: 5)
        } else if indexPath?.row == numberOfRows - 1 {
            makeShadowToLayer(layer: view.layer, corners: [.bottomLeft, .bottomRight], cornerRadius: 5)
        } else {
            makeShadowToLayer(layer: view.layer, corners: [], cornerRadius: 0)
        }
    }

    private func roundCorner() {
        view.layer.masksToBounds = false
        if numberOfRows == 1 {
            roundCorners(.allCorners)
        } else if indexPath?.row == 0 {
            roundCorners([.topLeft, .topRight])
        } else if indexPath?.row == numberOfRows - 1 {
            roundCorners([.bottomLeft, .bottomRight])
        } else {
            view.layer.masksToBounds = false
        }
    }

    private func roundCorners(_ corners: UIRectCorner) {
        let radius = 5
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))

        let mask = CAShapeLayer()
        mask.path = path.cgPath
//        mask.backgroundColor = UIColor.white.cgColor
        view.layer.mask = mask

    }

    private func isFirstRow() -> Bool {
        if numberOfRows == 1 || indexPath?.row == 0 {
            return true
        }
        return false
    }

    private func isLastRow() -> Bool {
        if numberOfRows == 1 || indexPath?.row == numberOfRows - 1 {
            return true
        }
        return false
    }


    private func makeShadowToLayer(layer: CALayer, corners: UIRectCorner, cornerRadius: CGFloat) {
        // the shadow rect determines the area in which the shadow gets drawn
        var shadowRect = view.bounds.insetBy(dx: 0, dy: -10)
        if (isFirstRow()) {
            shadowRect.origin.y += 10;
        } else if (isLastRow()) {
            shadowRect.size.height -= 10;
        }

        var maskRect = view.frame.insetBy(dx: -20, dy: 0)
        if (isFirstRow()) {
            maskRect.origin.y -= 10;
            maskRect.size.height += 10;
        } else if (isLastRow()) {
            maskRect.size.height += 10;
        }

        // now configure the background view layer with the shadow
//        layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
//        layer.borderWidth = 0.3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: cornerRadius).cgPath
        layer.masksToBounds = false
//        if !isFirstRow() && !isLastRow() {
//            self.layer.masksToBounds = true
//            return
//        }

        // and finally add the shadow mask
        // Mask for shadow
        let maskLayer_ = CAShapeLayer()
        let path_ = UIBezierPath(rect: maskRect)
        maskLayer_.path = path_.cgPath
        layer.mask = maskLayer_

        // Mask for corner radius
        layer.cornerRadius = 10
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: view.bounds,
                                 byRoundingCorners: corners,
                                 cornerRadii: CGSize(width: 10, height: 10))
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        maskLayer.shadowRadius = 3
        maskLayer.shadowOpacity = 0.5
        maskLayer.shadowColor = UIColor.black.cgColor
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.shadowOffset = .zero
        maskLayer.shouldRasterize = true
        maskLayer.rasterizationScale = UIScreen.main.scale
        maskLayer.name = "shadowMask"

        layer.sublayers?.filter({$0.name == "shadowMask" }).forEach({$0.removeFromSuperlayer()})
        layer.insertSublayer(maskLayer, at: 0)
    }
}
