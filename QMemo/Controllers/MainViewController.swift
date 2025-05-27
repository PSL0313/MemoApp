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
    
    var selectedAlertTime: Date? {
        didSet {
            if selectedAlertTime != nil {
                selectedCoordinate = nil
            }
            updateAlarmMenuButtonImage()
        }
    }
    
    var selectedCoordinate: CLLocationCoordinate2D? {
        didSet {
            if selectedCoordinate != nil {
                selectedAlertTime = nil
            }
            updateAlarmMenuButtonImage()
        }
    }
    
    // MARK: - 즐겨찾기 추후 구현
    var isFavorite: Bool = false {
        didSet {
        
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
        
        // MARK: TestCode - 테스트 메서드
        testfunc()
        
        
        
        defaultSetting()
        
        // 옵저버 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoNotification(_:)),
            name: .didReceiveMemoNotification,
            object: nil
        )
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
    
    // 첫 접속인 경우
    private func firstConnection() {
        let vc = FirstConnectionViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    // 메뉴버튼의 액션 생성 메서드
    private func makeMenu() -> UIMenu {
        let alertTimeSetAction = UIAction(title: "시간 알림 설정", image: UIImage(systemName: "alarm")) { _ in
            let vc = AlertTimeViewController()
            vc.modalPresentationStyle = .automatic
            vc.alertTimedelegate = self
            self.present(vc, animated: true)
        }
        
        let coordinateSetAction = UIAction(title: "위치 알림 설정", image: UIImage(systemName: "location")) { _ in
            let vc = CoordinateViewController()
            vc.modalPresentationStyle = .automatic
            self.present(vc, animated: true)
        }
        
        return UIMenu(title: "", children: [alertTimeSetAction, coordinateSetAction])
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
    
    // 앱이 백그라운드에서 동작중일 때 울린 알람 클릭
    @objc private func handleMemoNotification(_ notification: Notification) {
        print("노티함수까지는 실행")
        guard let memoID = notification.userInfo?["memoID"] as? String else { return }
        
        if let uuid = UUID(uuidString: memoID),
           let memo = MemoDataManager.shared.fetchMemo(byID: uuid) {
            let detailVC = ListDetailViewController()
            detailVC.memo = memo
            navigationController?.pushViewController(detailVC, animated: true)
            print("if문에서 걸러짐")
        }
    }
    
    // MARK: TestCode - 테스트 함수
    func testfunc() {
        // MARK: TestCode - 첫 접속인 경우 뜨는 화면을 확인하기 위한 키 삭제
        //UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        
        // MARK: TestCode - 알람 설정 화면 만드는 중
//        let vc = AlertTimeViewController()
//        vc.modalPresentationStyle = .automatic
//        self.present(vc, animated: true)
        
        // MARK: TestCode - 알림 권한 설정(허용 상태인지 확인)
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
//            print(granted ? "✅ 알림 허용됨" : "❌ 알림 거부됨")
//        }
    }
    
    
}

extension MainViewController: AlertTimeDelegate {
    func didSelectAlertTime(_ date: Date) {
        self.selectedAlertTime = date
        print("알림 시간 설정됨: \(date)")
    }
}
