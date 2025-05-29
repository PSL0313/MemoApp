//
//  ListViewController.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit
//import CoreData

class MemoListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var allMemos: [MemoEntity] = []
    private var filteredMemos: [MemoEntity] = []
    private var favoriteMemos: [MemoEntity] = []
    private var normalMemos: [MemoEntity] = []
    private var selectedFilterIndex: Int = 0
    
    private var actionBarBottomConstraint: NSLayoutConstraint!
    private var tableViewBottomConstraint: NSLayoutConstraint!
    
    // 필터 버튼
    private let buttonTitles = ["전체", "일반 메모", "시간", "위치"]
    private lazy var filterButtons: [UIButton] = {
        buttonTitles.enumerated().map { index, title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.setTitleColor(.brown, for: .normal)
            button.backgroundColor = NameSpace.ColorSetting.lightBrownColor
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()
    
    // 스택뷰: 필터버튼 네개
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()

    // 선택 버튼 눌렀을 때 뜨는 뷰
    private let actionBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.91, alpha: 1.0)
//        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    // 액션바뷰 안에 넣을 레이블
    private let selectedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "메모 선택"
        return label
    }()
    
    // 액션바뷰 안에 넣을 버튼
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    private let allSelectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.addTarget(self, action: #selector(deleteSelectedMemos), for: .touchUpInside)
        
        tableViewSetting()
        setUI()
        navigationBarSetting()
        
        // MARK: - NotificationCenter
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleMemoSaved),
                name: .memoSaved,
                object: nil
            )
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleMemoDeleted(_:)),
                name: .memoDeleted,
                object: nil
            )
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchMemosAndRefresh),
            name: .memoUpdated,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoNotification(_:)),
            name: .didReceiveMemoNotification,
            object: nil
        )
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMemos()
        applyFilter(index: selectedFilterIndex)
    }
    
    // MARK: - 메서드
    
    private func tableViewSetting() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "MemoCell")
        
        //편집 모드 = true -> (isEditing = true)에서 여러 셀을 동시에 선택할 수 있게 함
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    // UI 설정 메서드들을 실행하는 메서드
    private func setUI() {
        view.backgroundColor = NameSpace.ColorSetting.overLightBorwnColor
        
        tableView.backgroundColor = NameSpace.ColorSetting.lightBrownColor
        
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        actionBarView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        selectedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 오토레이아웃 변경 애니메이션을 위한 제약
        actionBarBottomConstraint = actionBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 60)
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5)
        
        filterButtons.forEach { button in
            filterStackView.addArrangedSubview(button)
        }
        
        view.addSubview(filterStackView)
        view.addSubview(tableView)
        view.addSubview(actionBarView)
        actionBarView.addSubview(deleteButton)
        actionBarView.addSubview(selectedLabel)
        
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterStackView.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableViewBottomConstraint,
            
            actionBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionBarBottomConstraint,
            actionBarView.heightAnchor.constraint(equalToConstant: 60),

            
            deleteButton.topAnchor.constraint(equalTo: actionBarView.topAnchor, constant: 12),
            deleteButton.trailingAnchor.constraint(equalTo: actionBarView.trailingAnchor, constant: -12),
            deleteButton.widthAnchor.constraint(equalToConstant: 60),
            deleteButton.heightAnchor.constraint(equalToConstant: 36),
            
            selectedLabel.topAnchor.constraint(equalTo: actionBarView.topAnchor, constant: 12),
            selectedLabel.centerXAnchor.constraint(equalTo: actionBarView.centerXAnchor),
            selectedLabel.heightAnchor.constraint(equalToConstant: 36),
            selectedLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // 필터 버튼의 tag를 기준으로 필터링
    @objc private func filterButtonTapped(_ sender: UIButton) {
        selectedFilterIndex = sender.tag
        switch sender.tag {
        case 0:
            filteredMemos = allMemos
        case 1:
            filteredMemos = allMemos.filter { memo in
                let noTimeAlarm = memo.alertTime == nil
                let noLocation = memo.latitude == 0 && memo.longitude == 0
                return noTimeAlarm && noLocation
            }
        case 2:
            filteredMemos = allMemos.filter { $0.alertTime != nil }
        case 3:
            filteredMemos = allMemos.filter { $0.latitude != 0 || $0.longitude != 0 }
        default:
            break
        }
        favoriteMemos = filteredMemos.filter { $0.isFavorite }
        normalMemos = filteredMemos.filter { !$0.isFavorite }

        tableView.reloadData()
    }
    
    // 최근에 필터링한 정보를 담은 속성을 기준으로 필터링
    private func applyFilter(index: Int) {
        switch index {
        case 0:
            filteredMemos = allMemos
        case 1:
            filteredMemos = allMemos.filter { memo in
                memo.alertTime == nil && memo.latitude == 0 && memo.longitude == 0
            }
        case 2:
            filteredMemos = allMemos.filter { $0.alertTime != nil }
        case 3:
            filteredMemos = allMemos.filter { $0.latitude != 0 || $0.longitude != 0 }
        default:
            filteredMemos = allMemos
        }
        favoriteMemos = filteredMemos.filter { $0.isFavorite }
        normalMemos = filteredMemos.filter { !$0.isFavorite }
        
        tableView.reloadData()
    }
    
    // 데이터 받아오기
    private func fetchMemos() {
        allMemos = MemoDataManager.shared.fetchMemos()
        applyFilter(index: selectedFilterIndex)
    }
    
    // 네비게이션바 설정
    private func navigationBarSetting() {
        // (네비게이션바 설정관련) iOS버전 업데이트 되면서 바뀐 설정⭐️⭐️⭐️
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.91, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "목록"
        
        // 네비게이션바에 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "선택",
            style: .plain,
            target: self,
            action: #selector(selectButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .brown
    }
    
    
    @objc func addTapped() {
        let nextVC = MainViewController()
        nextVC.isFromList = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func selectButtonTapped() {
        let isEditing = tableView.isEditing
        tableView.setEditing(!isEditing, animated: true)

        navigationItem.leftBarButtonItem?.title = isEditing ? "선택" : "취소"

        // 1️⃣ 현재 맨 아래인지 상태 저장
        let wasAtBottom = isTableViewAtBottom(tableView)

        // 2️⃣ 제약 변경
        actionBarBottomConstraint.constant = !isEditing ? -5 : 60
        tableViewBottomConstraint.constant = !isEditing ? -70 : 5

        // 3️⃣ 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            // 4️⃣ 애니메이션 끝난 뒤, 이전에 맨 아래였다면 다시 스크롤
            if wasAtBottom {
                self.scrollToBottom(self.tableView)
            }
        })
        
        if !isEditing {
            updateSelectionCount()
        }
    }
    
    // 테이블뷰가 맨 아래까지 스크롤한 상태인지 확인하는 메서드
    func isTableViewAtBottom(_ tableView: UITableView) -> Bool {
        // 내용이 아예 없는 경우 false 반환 -> 내용이 없는 경우에도 true 반환하여 크래시 발생
        guard tableView.numberOfRows(inSection: 0) > 0 else { return false }
        
        let contentHeight = tableView.contentSize.height
        let tableViewHeight = tableView.frame.size.height
        let offsetY = tableView.contentOffset.y
        
        return offsetY + tableViewHeight >= contentHeight - 1
    }
    
    // 테이블뷰를 맨 아래까지 스크롤하는 메서드
    func scrollToBottom(_ tableView: UITableView, animated: Bool = true) {
        let lastSection = max(0, tableView.numberOfSections - 1)
        let lastRow = max(0, tableView.numberOfRows(inSection: lastSection) - 1)
        
        guard lastRow >= 0 else { return }

        let indexPath = IndexPath(row: lastRow, section: lastSection)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    @objc private func deleteSelectedMemos() {
        print("삭제 버튼 눌림")

        guard let selectedRows = tableView.indexPathsForSelectedRows else { return }

        let sortedRows = selectedRows.sorted(by: { $0.section > $1.section || ($0.section == $1.section && $0.row > $1.row) })

        var deletedMemos: [MemoEntity] = []

        for indexPath in sortedRows {
            let memo: MemoEntity

            // ✅ 섹션에 따라 즐겨찾기/일반에서 가져오기
            if indexPath.section == 0 {
                memo = favoriteMemos[indexPath.row]
                favoriteMemos.remove(at: indexPath.row)
            } else {
                memo = normalMemos[indexPath.row]
                normalMemos.remove(at: indexPath.row)
            }

            deletedMemos.append(memo)

            // ✅ allMemos, filteredMemos에서도 제거
            if let index = allMemos.firstIndex(of: memo) {
                allMemos.remove(at: index)
            }
            if let index = filteredMemos.firstIndex(of: memo) {
                filteredMemos.remove(at: index)
            }

            // ✅ 알림 취소
            if memo.alertTime != nil {
                let identifier = memo.id?.uuidString ?? ""
                AlertTimeNotiManager.shared.alertTimeDelete(id: identifier)
            }
        }

        // ✅ CoreData에서 삭제
        MemoDataManager.shared.deleteMemos(deletedMemos)

        // ✅ 테이블 뷰에서 UI 제거
        tableView.deleteRows(at: sortedRows, with: .automatic)

        // ✅ 선택 모드 종료
        selectButtonTapped()
    }
    
    @objc private func handleMemoSaved() {
        showToast(defaultViewName: view, message: "저장 완료")
    }
    
    private func updateSelectionCount() {
        let count = tableView.indexPathsForSelectedRows?.count ?? 0
        if count == 0 {
            selectedLabel.text = "메모 선택"
        } else {
            selectedLabel.text = "\(count)개 선택됨"
        }
    }
    
    @objc private func fetchMemosAndRefresh() {
        fetchMemos()
        applyFilter(index: selectedFilterIndex)
    }
    
    @objc private func handleMemoDeleted(_ notification: Notification) {
        guard let id = notification.userInfo?["id"] as? UUID else { return }
        
        // ✅ 알림 삭제
        AlertTimeNotiManager.shared.alertTimeDelete(id: id.uuidString)
        
        // ✅ 배열에서 제거
        if let index = allMemos.firstIndex(where: { $0.id == id }) {
            allMemos.remove(at: index)
        }
        
        if let index = filteredMemos.firstIndex(where: { $0.id == id }) {
            filteredMemos.remove(at: index)
            let indexPath = IndexPath(row: index, section: 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc private func handleMemoNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let memoIDString = userInfo["memoID"] as? String,
              let memoUUID = UUID(uuidString: memoIDString) else {
            return
        }

        // 이미 보여주고 있는 메모인지 확인해서 중복 push 방지
        if let topVC = navigationController?.topViewController as? ListDetailViewController,
           topVC.memo?.id == memoUUID {
            return
        }

        // CoreData 또는 다른 저장소에서 해당 memo 찾아오기
        guard let memo = MemoDataManager.shared.fetchMemo(byID: memoUUID) else { return }

        let detailVC = ListDetailViewController()
        detailVC.memo = memo
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didReceiveMemoNotification, object: nil)
    }
}




// MARK: - 확장(UITableViewDataSource, UITableViewDelegate)
extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 즐겨찾기, 일반
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? favoriteMemos.count : normalMemos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! ListTableViewCell
        let memo = indexPath.section == 0 ? favoriteMemos[indexPath.row] : normalMemos[indexPath.row]
        cell.memoContent = memo
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "⭐️ 즐겨찾기" : "📄 메모"
    }
    
    // UITableViewDelegate
    // 셀을 오른쪽에서 왼쪽으로 스와이프하면 실행되는 메서드
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // ✅ 섹션 기준으로 메모 가져오기
        let memoToDelete = indexPath.section == 0
            ? favoriteMemos[indexPath.row]
            : normalMemos[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, completionHandler) in
            
            // ✅ 알림도 삭제
            if memoToDelete.alertTime != nil {
                let identifier = memoToDelete.id?.uuidString ?? ""
                AlertTimeNotiManager.shared.alertTimeDelete(id: identifier)
            }
            
            // ✅ CoreData에서 삭제
            MemoDataManager.shared.deleteMemo(memoToDelete)
            
            // ✅ 배열에서 삭제
            if let indexInAll = self.allMemos.firstIndex(of: memoToDelete) {
                self.allMemos.remove(at: indexInAll)
            }
            if let indexInFiltered = self.filteredMemos.firstIndex(of: memoToDelete) {
                self.filteredMemos.remove(at: indexInFiltered)
            }
            if indexPath.section == 0 {
                self.favoriteMemos.remove(at: indexPath.row)
            } else {
                self.normalMemos.remove(at: indexPath.row)
            }
            
            // ✅ UI 반영
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateSelectionCount()
            return
        }

        // ✅ section에 따라 올바른 배열에서 가져오기
        let selectedMemo = indexPath.section == 0
            ? favoriteMemos[indexPath.row]
            : normalMemos[indexPath.row]

        let detailVC = ListDetailViewController()
        detailVC.memo = selectedMemo
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateSelectionCount()
        }
    }
    
    
}
