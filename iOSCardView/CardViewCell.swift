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

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var kindContainerView: UIView!

    var numberOfRows = 0
    var indexPath: IndexPath? = nil
    var isTappable = true

    private var appData: AppData? = nil

    func configure(appData: AppData) {
        self.appData = appData

        //description
        descriptionLabel.text = appData.description
        //amount
        amountLabel.text = "¥\(appData.amount)"

        //pushed_at
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
        if let d = f.date(from: appData.pushed_at) {
            f.dateFormat = "yyyy/MM/dd"
            publishedAt.text = f.string(from: d)
        }
        publishedAt.isHidden = false

        //kind
        kindLabel.text = appData.kind
        kindContainerView.isHidden = false
    }

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

        descriptionLabel.text = nil
        amountLabel.text = nil
        publishedAt.text = nil
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //To draw appropriate layout first
        kindContainerView.layer.cornerRadius = 10
        kindContainerView.layer.borderWidth = 2

        if appData?.kind == "capture" {
            // capture
            kindLabel.textColor = .blue
            kindContainerView.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
            kindContainerView.layer.borderColor = UIColor.blue.cgColor
        } else {
            // refund, cancel
            kindLabel.textColor = .white
            kindContainerView.backgroundColor = .lightGray
            kindContainerView.layer.borderColor = UIColor.darkGray.cgColor
        }

        makeCornerAndShadow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        makeCornerAndShadow()
    }

    func makeCornerAndShadow() {
        let isSingleRow = numberOfRows == 1
        let isFirstRow = numberOfRows == 1 || indexPath?.row == 0
        let isLastRow = numberOfRows == 1 || indexPath?.row == numberOfRows - 1

        // Rect for shadow
        var shadowRect = view.bounds
        if !isSingleRow {
            shadowRect = shadowRect.insetBy(dx: 0, dy: -5)
            if (isFirstRow) { shadowRect.origin.y += 5 }
            if (isLastRow) { shadowRect.size.height -= 5 }
        }

        // Rect for corner radius mask
        var maskRect = view.bounds.insetBy(dx: -20, dy: 0)
        if (isFirstRow) {
            maskRect.origin.y -= 5
            maskRect.size.height += 5
        }
        if (isLastRow) { maskRect.size.height += 10 }

        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = isTappable ? 2 : 0.5
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 5).cgPath
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale

        // Mask for shadow
        let shadowMask = CAShapeLayer()
        shadowMask.path = UIBezierPath(rect: maskRect).cgPath
        shadowView.layer.mask = shadowMask

        // Mask for corner radius
        var corners: UIRectCorner = []
        if isSingleRow { corners = [.allCorners] }
        else if isFirstRow { corners = [.topLeft, .topRight] }
        else if isLastRow { corners = [.bottomLeft, .bottomRight] }

        let cornerMask = CAShapeLayer()
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: 5, height: 5))
        cornerMask.path = path.cgPath
        view.layer.mask = cornerMask
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.borderWidth = 0.3
        view.layer.masksToBounds = false
    }
}

