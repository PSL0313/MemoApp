//
//  FirstConnectionViewController.swift
//  Memo
//
//  Created by 박선린 on 5/16/25.
//

import UIKit

class FirstConnectionViewController: UIViewController {

    let uiView = FirstConnectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    private func setUI() {
        uiView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view = uiView
        
        
    }
    @objc private func nextButtonTapped() {
        dismiss(animated: true)
    }
    
    

}
