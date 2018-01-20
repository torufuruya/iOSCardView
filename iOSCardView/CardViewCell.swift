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
        if selected {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
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
        roundCorner()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorner()
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
        view.layer.mask = mask
    }
}
