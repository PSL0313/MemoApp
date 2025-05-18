//
//  FirstConnectionViewController.swift
//  Memo
//
//  Created by 박선린 on 5/16/25.
//

import UIKit

class FirstConnectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    private func setUI() {
        view = FirstConnectionView()
    }
    

}
