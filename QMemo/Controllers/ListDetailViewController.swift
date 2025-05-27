//
//  ListDetailViewController.swift
//  Memo
//
//  Created by 박선린 on 5/20/25.
//

import UIKit
import CoreLocation

class ListDetailViewController: UIViewController {
    
    var memoView = MainView()
    var isFavorite = false
    var selectedAlertTime: Date? = nil
    var selectedCoordinate: CLLocationCoordinate2D? = nil
    
    var memo: MemoEntity? {
        didSet {
            memoView.memoTitle.text = memo?.title
            memoView.memoContents.text = memo?.content
            isFavorite = memo?.isFavorite ?? false
            selectedAlertTime = memo?.alertTime
            selectedCoordinate?.latitude = memo?.latitude ?? 0
            selectedCoordinate?.longitude = memo?.longitude ?? 0
            memoView.memoContents.updatePlaceholderVisibility()
        }
    }
    
    
    private var menuButton: UIBarButtonItem!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultSetting()
        
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
        navigationController?.navigationBar.tintColor = .brown
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "메모"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false    // 기본 제스처 비활
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"), //"<" 아이콘
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem?.title = "뒤로"
        
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleCustomSwipeBack(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
        
        setupMenuButton(isFavorited: isFavorite)
    }
    
    
    private func setupMenuButton(isFavorited: Bool) {
        let alarmSettingAction = UIAction(title: "알람 수정", image: UIImage(systemName: "alarm")) { _ in
            print("알람 설정 선택됨")
            // 내부 코드 구현
        }
        
        let starImage = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        let favoriteMemoAction = UIAction(title: "즐겨찾기", image: starImage) { _ in
                // 즐겨찾기 토글 처리
                self.isFavorite.toggle()
            showToast(defaultViewName: self.memoView, message: "즐겨찾기 \(self.isFavorite ? "추가 완료" : "해제 완료")")
                self.updateMenuIcon()
            }

        let infoAction = UIAction(title: "메모 정보", image: UIImage(systemName: "info.circle")) { _ in
            print("메모 정보정보 선택됨")
            // 내부 코드 구현
        }
        

        let deleteAction = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            print("삭제하기 선택됨")
            // 삭제하기 관련 코드 구현 (destructive 스타일로 빨갛게 표시됨)
            self.showDeleteConfirmation()
            
            
        }

        let menu = UIMenu(title: "", children: [alarmSettingAction, favoriteMemoAction, infoAction, deleteAction])
        menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        menuButton.tintColor = .brown

        // 내비게이션 아이템의 오른쪽에 버튼을 추가합니다.
        navigationItem.rightBarButtonItem = menuButton
    }
    
    // 메뉴창에서 삭제 클릭시 뜨는 액션시트
    func showDeleteConfirmation() {
            let alert = UIAlertController(title: nil, message: "이 메모가 보관함에서 삭제됩니다. 해당 메모는 '최근 삭제된 항목'에 n일간 보관됩니다.", preferredStyle: .actionSheet)

            let confirmDelete = UIAlertAction(title: "메모 삭제", style: .destructive) { _ in
                print("삭제 실행됨") // 실제 삭제 로직 구현
                self.clearTapped()
            }

            let cancelDelete = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            alert.addAction(confirmDelete)
            alert.addAction(cancelDelete)

            present(alert, animated: true, completion: nil)
        }
    
    
    // 삭제
    @objc func clearTapped() {
        guard let memo = self.memo else { return }
        
        // 1️⃣ CoreData에서 삭제
        MemoDataManager.shared.deleteMemo(memo)
        
        // 2️⃣ 삭제 알림 전송
        NotificationCenter.default.post(
            name: .memoDeleted,
            object: nil,
            userInfo: ["id": memo.id ?? UUID()]
        )
        
        // 3️⃣ 화면 닫기
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        let currentTitle = memoView.memoTitle.text ?? ""
        let currentContent = memoView.memoContents.text ?? ""
        let currentisFavorite = isFavorite
        let currentAlertTime = selectedAlertTime
        let currentLatitude = selectedCoordinate?.latitude ?? 0
        let currentLongitude = selectedCoordinate?.longitude ?? 0

        let hasChanges =
            currentTitle != memo?.title ||
            currentContent != memo?.content ||
            currentisFavorite != memo?.isFavorite ||
            currentAlertTime != memo?.alertTime ||
            currentLatitude != memo?.latitude ||
            currentLongitude != memo?.longitude

        if hasChanges {
            let alert = UIAlertController(title: "변경사항 저장",
                                          message: "수정된 내용을 저장하시겠습니까?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "저장", style: .default, handler: { _ in
                self.saveChanges(title: currentTitle,
                                 content: currentContent,
                                 isFavorite: currentisFavorite,
                                 alertTime: currentAlertTime,
                                 latitude: currentLatitude,
                                 longitude: currentLongitude)
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func handleCustomSwipeBack(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            backButtonTapped()
        }
    }
    
    private func saveChanges(title: String, content: String, isFavorite: Bool, alertTime: Date?, latitude: Double?, longitude: Double?) {
        guard let memo = memo else { return }
        
        NotificationCenter.default.post(name: .memoUpdated, object: nil)
        
        MemoDataManager.shared.updateMemo(
            memo,
            title: title,
            content: content,
            isFavorite: isFavorite,
            alertTime: alertTime,
            latitude: latitude,
            longitude: longitude
        )
    }
    
    private func updateMenuIcon() {
        setupMenuButton(isFavorited: isFavorite)
    }
}
