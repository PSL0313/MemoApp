//
//  PaddingLabel.swift
//  QMemo
//
//  Created by 박선린 on 5/22/25.
//

import UIKit

class PaddingLabel: UILabel {
    var inset: UIEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + inset.left + inset.right,
                      height: size.height + inset.top + inset.bottom)
    }
}
