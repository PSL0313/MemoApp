//
//  MemoInfoViewController.swift
//  QMemo
//
//  Created by 박선린 on 5/27/25.
//

import UIKit

class MemoInfoViewController: UIViewController {
    
    var memo: MemoEntity? {
        didSet {
            //            memoView.memoTitle.text = memo?.title
            //            memoView.memoContents.text = memo?.content
            //            isFavorite = memo?.isFavorite ?? false
            //            selectedAlertTime = memo?.alertTime
            //            selectedCoordinate?.latitude = memo?.latitude ?? 0
            //            selectedCoordinate?.longitude = memo?.longitude ?? 0
            //            memoView.memoContents.updatePlaceholderVisibility()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
