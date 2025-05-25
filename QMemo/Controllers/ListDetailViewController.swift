//
//  ListDetailViewController.swift
//  Memo
//
//  Created by 박선린 on 5/20/25.
//

import UIKit

class ListDetailViewController: UIViewController {
    
    var memo: MemoEntity? {
        didSet {
            memoView.memoTitle.text = memo?.title
            memoView.memoContents.text = memo?.content
        }
    }
    
    var memoView = MainView()
    
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
        
        let alarmSettingAction = UIAction(title: "알람 수정", image: UIImage(systemName: "alarm")) { _ in
            print("알람 설정 선택됨")
            // 내부 코드 구현
        }
        
        let favoriteMemoAction = UIAction(title: "즐겨찾기", image: UIImage(systemName: "star")) { _ in
            print("즐겨찾기 선택됨")
            // 내부 코드 구현
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
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        menuButton.tintColor = .brown

        // 내비게이션 아이템의 오른쪽에 버튼을 추가합니다.
        navigationItem.rightBarButtonItem = menuButton
        
    }
    
    // 메뉴창에서 삭제 클릭시 뜨는 액션시트
    func showDeleteConfirmation() {
            let alert = UIAlertController(title: nil, message: "이 메모가 보관함에서 삭제됩니다. 해당 메모는 '최근 삭제된 항목'에 n일간 보관됩니다.", preferredStyle: .actionSheet)

            let confirmDelete = UIAlertAction(title: "메모 삭제", style: .destructive) { _ in
                print("삭제 실행됨") // 실제 삭제 로직 구현
            }

            let cancelDelete = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            alert.addAction(confirmDelete)
            alert.addAction(cancelDelete)

            present(alert, animated: true, completion: nil)
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
}
