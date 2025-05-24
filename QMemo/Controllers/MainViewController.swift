//
//  ViewController.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit
import CoreLocation
//import CoreData

class MainViewController: UIViewController {
    
    var memoView = MainView()

    var selectedAlertTime: Date?
    var selectedCoordinate: CLLocationCoordinate2D?
    
    // 메인화면 == false로 사용, 다른 곳에서 재사용하는 경우 false로 사용
    var isFromList: Bool = false
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: TestCode - 첫 접속인 경우 뜨는 화면을 확인하기 위한 키 삭제
//        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        defaultSetting()
        
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 한 번만 실행되도록 체크
        let hasLaunchedKey = "hasLaunchedBefore"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasLaunchedKey)
        
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasLaunchedKey)
            
            // 메인 화면이 먼저 보여지도록 약간의 지연 추가
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.firstConnection()
            }
        }
    }
    
    
    
    private func defaultSetting() {
        
        view.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.94, alpha: 1.0)
        memoViewSetting()
        navigationBarSetting()
        
        
    }
    
    private func memoViewSetting() {
        view.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.94, alpha: 1.0)
        view.addSubview(memoView)
        memoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            memoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            memoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    private func navigationBarSetting() {
        // (네비게이션바 설정관련) iOS버전 업데이트 되면서 바뀐 설정⭐️⭐️⭐️
        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.91, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "메모"
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)  // ← 직접 지정 필요
        )

        let clearButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(clearTapped)
        )
        
        let saveButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.down"), // 저장 의미
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )

        let alarmButton = UIBarButtonItem(
            image: UIImage(systemName: "bell"), // 알람 의미
            style: .plain,
            target: self,
            action: #selector(alarmButtonTapped)
        )

        // 오른쪽부터 순서대로: 저장 → 알람
        navigationItem.rightBarButtonItems = [saveButton, alarmButton]
        navigationItem.rightBarButtonItems?.forEach { $0.tintColor = .brown }
        
        if isFromList == true {
            navigationItem.leftBarButtonItems = [backButton, clearButton]
        } else {
            navigationItem.leftBarButtonItems = [clearButton]
        }
        
        backButton.tintColor = .brown
        clearButton.tintColor = .red
        
//        navigationItem.leftBarButtonItems?.forEach { $0.tintColor = .brown }
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonTapped() {
        guard let title = memoView.memoTitle.text, !title.isEmpty,
              let content = memoView.memoContents.text, !content.isEmpty else {
            print("❌ 제목 또는 내용이 비어 있음")
            return
        }
        
        // 선택된 알람 정보가 있다면 넘기기
        MemoDataManager.shared.addMemo(
            title: title,
            content: content,
            alertTime: selectedAlertTime ?? nil,
            latitude: selectedCoordinate?.latitude ?? nil,
            longitude: selectedCoordinate?.longitude ?? nil
        )
        
        saveAndClearButtonTapped()
        
        if isFromList {
            NotificationCenter.default.post(name: .memoSaved, object: nil)
            navigationController?.popViewController(animated: true)
        } else {
            showToast(defaultViewName: view, message: "저장 완료")
        }
    }
    
    private func saveAndClearButtonTapped() {
        self.memoView.memoTitle.text = ""
        self.memoView.memoContents.text = ""
        self.memoView.memoContents.updatePlaceholderVisibility()
    }
    
    @objc func alarmButtonTapped() {
        print("alarmButtonTapped")
    }
    
    @objc func clearTapped() {
        let alert = UIAlertController(
                title: "입력 초기화",
                message: "작성 중인 내용을 모두 지우시겠어요?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "지우기", style: .destructive, handler: { _ in
                self.memoView.memoTitle.text = ""
                self.memoView.memoContents.text = ""
                self.memoView.memoContents.updatePlaceholderVisibility()
            }))

            present(alert, animated: true, completion: nil)
    }
    
    // 토스트 알림
//    func showToast(message: String, duration: Double = 2.0) {
//        print("showToast 메서드 실행됨")
//        let toastLabel = PaddingLabel() // ✅ 기존 UILabel 대신
//        toastLabel.inset = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
//        toastLabel.text = message
//        toastLabel.textColor = .white
//        toastLabel.textAlignment = .center
//        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        toastLabel.numberOfLines = 0
//        toastLabel.layer.cornerRadius = 12
//        toastLabel.clipsToBounds = true
//        toastLabel.alpha = 0.0
//        toastLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(toastLabel)
//
//        // 💡 오토레이아웃 제약
//        let maxWidth = view.frame.width * 0.6
//        NSLayoutConstraint.activate([
//            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            toastLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
//            toastLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
//            toastLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
//            toastLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
//        ])
//
//        // ⚡️ 필수: 내부 여백을 위해 contentInsets 대신 패딩 추가 (내부 사용 시)
//        toastLabel.setContentHuggingPriority(.required, for: .vertical)
//        toastLabel.setContentCompressionResistancePriority(.required, for: .vertical)
//
//        // 애니메이션
//        UIView.animate(withDuration: 0.3, animations: {
//            toastLabel.alpha = 1.0
//        }) { _ in
//            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
//                toastLabel.alpha = 0.0
//            }) { _ in
//                toastLabel.removeFromSuperview()
//            }
//        }
//    }
    
    // 첫 접속인 경우
    private func firstConnection() {
        let vc = FirstConnectionViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    

}

