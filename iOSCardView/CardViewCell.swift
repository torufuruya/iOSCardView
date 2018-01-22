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
    @IBOutlet weak var shadowView: UIView!

    var numberOfRows = 0
    var indexPath: IndexPath? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //Show tap interaction
        if selected {
            view.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = .white
            })
        }
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

    private func isSingleRow() -> Bool {
        return numberOfRows == 1
    }


    private func makeShadowToLayer(layer: CALayer, corners: UIRectCorner, cornerRadius: CGFloat) {
        // the shadow rect determines the area in which the shadow gets drawn
        var shadowRect = view.bounds
        if !isSingleRow() {
            shadowRect = shadowRect.insetBy(dx: 0, dy: -5)
            if (isFirstRow()) { shadowRect.origin.y += 5 }
            if (isLastRow()) { shadowRect.size.height -= 5 }
        }

        var maskRect = view.bounds.insetBy(dx: -20, dy: 0)
        if (isFirstRow()) {
            maskRect.origin.y -= 5
            maskRect.size.height += 5
        }
        if (isLastRow()) { maskRect.size.height += 10 }

        // now configure the background view layer with the shadow
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 5).cgPath
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale

        // and finally add the shadow mask
        // Mask for shadow
        let shadowMask = CAShapeLayer()
        shadowMask.path = UIBezierPath(rect: maskRect).cgPath
        shadowView.layer.mask = shadowMask

        // Mask for corner radius
        let cornerMask = CAShapeLayer()
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: 5, height: 5))
        cornerMask.path = path.cgPath
        layer.mask = cornerMask
        layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 0.3
        layer.masksToBounds = false
    }
}
