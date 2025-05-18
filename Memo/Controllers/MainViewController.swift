//
//  ViewController.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit

class MainViewController: UIViewController {
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        defaultSetting()
        
        
    }
    
    private func defaultSetting() {
        view = MainView()
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
        title = "Memo"
        
        // 네비게이션바에 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearTapped))
        navigationItem.leftBarButtonItem?.tintColor = .red
    }
    
    @objc func addTapped() {
        
     
        // MARK: TestCode - 다음 화면을 확인하기 위해 임시로 add버튼에 연결 해놓음 UI 완성 후 삭제 필요
        firstConnection()
    }
    
    @objc func clearTapped() {
        
    }
    
    // 첫 접속인 경우
    private func firstConnection() {
        let vc = FirstConnectionViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

}

