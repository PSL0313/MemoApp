//
//  ViewController.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit
import CoreLocation
//import CoreData


final class MainViewController: UIViewController {
    
    private var memoView = MainView()
    
    private var isFavorite: Bool = false
    
    private var selectedAlertTime: Date? {
        didSet {
            if selectedAlertTime != nil {
                selectedCoordinate = nil
            }
            updateAlarmMenuButtonImage()
        }
    }
    
    private var selectedCoordinate: CLLocationCoordinate2D? {
        didSet {
            if selectedCoordinate != nil {  // selectedCoordinate 값이 바뀜 -> nil이 아닌 경우 AlertTime = nil 할당
                selectedAlertTime = nil
            }
            updateAlarmMenuButtonImage()
        }
    }
    
    private var menuButton: UIBarButtonItem!
    private lazy var saveButton = UIBarButtonItem(
        image: UIImage(systemName: "square.and.arrow.down"), // 저장 의미
        style: .plain,
        target: self,
        action: #selector(saveButtonTapped)
    )
    
    // 메인화면 == false로 사용, 다른 곳에서 재사용하는 경우 false로 사용
    var isFromList: Bool = false
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
    
    
    
    
    private func defaultSetting() {
        view.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.94, alpha: 1.0)
        memoViewSetting()
        navigationBarSetting()
        
        memoView.memoTitle.delegate = self
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
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.91, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "메모"
        
        // 버튼
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
        
        menuButton = UIBarButtonItem(image: UIImage(systemName: "bell.slash"), menu: makeMenu())
        navigationItem.rightBarButtonItems = [saveButton, menuButton]
        
        navigationItem.rightBarButtonItems?.forEach { $0.tintColor = .brown }
        
        if isFromList == true {
            navigationItem.leftBarButtonItems = [backButton, clearButton]
            let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backButtonTapped))
            edgePanGesture.edges = .left
            view.addGestureRecognizer(edgePanGesture)
        } else {
            navigationItem.leftBarButtonItems = [clearButton]
        }
        
        backButton.tintColor = .brown
        clearButton.tintColor = .red
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
        let memoId = UUID()  // 새로운 메모는 항상 UUID 생성
        let alertTime = selectedAlertTime  // 사용자가 설정한 시간
        
        // 1. 메모 저장
        MemoDataManager.shared.addMemo(
            uuid: memoId,
            title: title,
            content: content,
            isFavorite: isFavorite,
            alertTime: alertTime
        )
        
        // 2. 시간 알람이 설정되어 있다면 알림 등록
        if let alertTime = alertTime {
            AlertTimeNotiManager.shared.alertTimeAdd(
                id: memoId.uuidString,
                title: title,
                body: content,
                date: alertTime
            )
        }
        
        
        
        saveAndClearButtonTapped()
        
        // 리스트뷰커넹서 새로운 메모를 추가하는 경우 노티 보내기
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
        self.selectedAlertTime = nil
        self.selectedCoordinate = nil
        self.memoView.memoContents.updatePlaceholderVisibility()
    }
    
    @objc func clearTapped() {
        let alert = UIAlertController(
            title: "입력 초기화",
            message: "작성 중인 내용을 모두 지우시겠어요?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "지우기", style: .destructive, handler: { _ in
            print("클리어버튼")
            self.memoView.memoTitle.text = ""
            self.memoView.memoContents.text = ""
            self.selectedAlertTime = nil
            self.selectedCoordinate = nil
            self.memoView.memoContents.updatePlaceholderVisibility()
        }))
        
        present(alert, animated: true, completion: nil)
    }

    
    // 메뉴버튼의 액션 생성 메서드
    private func makeMenu() -> UIMenu {
        let alertTimeSetAction = UIAction(title: "시간 알림 설정", image: UIImage(systemName: "alarm")) { _ in
            let vc = AlertTimeViewController()
            vc.modalPresentationStyle = .automatic
            vc.alertTimedelegate = self
            vc.ToastDelegate = self.view
            self.present(vc, animated: true)
        }
        
        let coordinateSetAction = UIAction(title: "위치 알림 설정", image: UIImage(systemName: "location")) { _ in
            let vc = CoordinateViewController()
            vc.modalPresentationStyle = .automatic
            self.present(vc, animated: true)
        }
        
        return UIMenu(title: "", children: [alertTimeSetAction])
        //return UIMenu(title: "", children: [alertTimeSetAction, coordinateSetAction])
    }
    
    // 알람 상태 업데이트 함수 -> 시간, 위치 알람 설정에 따른 버튼 이미지 변경
    private func updateAlarmMenuButtonImage() {
        var newImage: UIImage?
        
        if selectedAlertTime != nil {
            newImage = UIImage(systemName: "alarm")
        } else if selectedCoordinate != nil {
            newImage = UIImage(systemName: "location")
        } else {
            newImage = UIImage(systemName: "bell.slash")
        }
        
        
        // 다시 menu 붙여서 새로 할당해야 함
        menuButton = UIBarButtonItem(image: newImage, menu: makeMenu())
        menuButton?.tintColor = .brown
        saveButton.tintColor = .brown
        navigationItem.rightBarButtonItems = [saveButton, menuButton]
    }
    
    @objc func handleMemoNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let memoIDString = userInfo["memoID"] as? String,
              let memoUUID = UUID(uuidString: memoIDString) else {
            return
        }
        
        // 탭 전환
        self.tabBarController?.selectedIndex = 1

        // 0.1초 후에 푸시 (뷰 전환 후 푸시)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let memoVC = ListDetailViewController()
            memoVC.memo = MemoDataManager.shared.fetchMemo(byID: memoUUID)
            self.navigationController?.pushViewController(memoVC, animated: true)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        memoView.memoContents.becomeFirstResponder()  // ← 텍스트뷰로 커서 이동
        return true
    }
}

extension MainViewController: AlertTimeDelegate {
    func didSelectAlertTime(_ date: Date) {
        self.selectedAlertTime = date
        print("메인 뷰컨에서 알림 시간 설정됨: \(date)")
    }
}

