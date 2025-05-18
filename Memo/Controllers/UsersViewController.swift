//
//  ListViewController.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit

class UsersViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

    }
    
    private func setUI() {
        
        view.backgroundColor = .white
        navigationBarSetting()

    }
    
    private func navigationBarSetting() {
        // (네비게이션바 설정관련) iOS버전 업데이트 되면서 바뀐 설정⭐️⭐️⭐️
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "사용자"
        
        // 네비게이션바에 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearTapped))
        navigationItem.leftBarButtonItem?.tintColor = .red
    }
    
    @objc func addTapped() {
        
    }
    
    @objc func clearTapped() {
        
    }


}
