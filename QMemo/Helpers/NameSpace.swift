//
//  NameSpace.swift
//  QMemo
//
//  Created by 박선린 on 5/25/25.
//

import UIKit

class NameSpace {
    
    static let shared = NameSpace()
    private init() {}
    
    
    enum ColorSetting {
        static let lightBrownColor: UIColor = UIColor(red: 0.99, green: 0.97, blue: 0.94, alpha: 1.0)
        static let overLightBorwnColor = UIColor(red: 1.0, green: 0.985, blue: 0.97, alpha: 1.0)
    }
}
