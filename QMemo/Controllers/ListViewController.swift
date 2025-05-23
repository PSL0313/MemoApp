//
//  ListViewController.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit
import CoreData

class MemoListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var allMemos: [MemoEntity] = []
    private var filteredMemos: [MemoEntity] = []
    
    // 필터 버튼
    private let buttonTitles = ["전체", "일반 메모", "시간", "위치"]
    
    private lazy var filterButtons: [UIButton] = {
        buttonTitles.enumerated().map { index, title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = UIColor.systemGray6
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
        return stackView
    }()


    
    // 선택 버튼 눌렀을 때 뜨는 뷰
    private let actionBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.alpha = 0 // 처음엔 안 보이게
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // 액션바뷰 안에 넣을 버튼
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(deleteSelectedMemos), for: .touchUpInside)
        return button
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetting()
        setUI()
        navigationBarSetting()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMemos()
        
    }
    
    // MARK: - 메서드
    
    private func tableViewSetting() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    // UI 설정 메서드들을 실행하는 메서드
    private func setUI() {
        view.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.94, alpha: 1.0)
        

        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        actionBarView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        filterButtons.forEach { button in
            filterStackView.addArrangedSubview(button)
        }

        view.addSubview(filterStackView)
        view.addSubview(tableView)
        view.addSubview(actionBarView)
        actionBarView.addSubview(deleteButton)
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MemoCell")

        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterStackView.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            
//            actionBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ),
            actionBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            actionBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            actionBarView.heightAnchor.constraint(equalToConstant: 53),
            actionBarView.widthAnchor.constraint(equalToConstant: 135),

            deleteButton.centerXAnchor.constraint(equalTo: actionBarView.centerXAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: actionBarView.centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 53),
            deleteButton.widthAnchor.constraint(equalToConstant: 135),
            
        ])
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
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
        tableView.reloadData()
    }
    
    private func fetchMemos() {
        allMemos = MemoDataManager.shared.fetchMemos()
        filteredMemos = allMemos
        tableView.reloadData()
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
        
        print("isEditing 상태: \(isEditing)")

        navigationItem.leftBarButtonItem?.title = isEditing ? "선택" : "취소"

        if isEditing {
            // 선택 모드 종료 → 숨기기
            UIView.animate(withDuration: 0.25) {
                self.actionBarView.alpha = 0
            }
            self.actionBarView.isUserInteractionEnabled = false
        } else {
            // 선택 모드 시작 → 보이기
            UIView.animate(withDuration: 0.25) {
                self.actionBarView.alpha = 1
            }
            self.actionBarView.isUserInteractionEnabled = true
        }
    }

    @objc private func deleteSelectedMemos() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else { return }

        // indexPath를 내림차순으로 정렬 (안그러면 삭제 중 index 오류 날 수 있음)
        let sortedRows = selectedRows.sorted(by: { $0.row > $1.row })

        for indexPath in sortedRows {
            let memo = allMemos[indexPath.row]
            
            // 1. CoreData에서 삭제
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(memo)
            
            // 2. 로컬 배열에서 삭제
            allMemos.remove(at: indexPath.row)
        }

        // 3. 저장 및 UI 갱신
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        tableView.deleteRows(at: sortedRows, with: .automatic)
        selectButtonTapped()
    }
    

}

// MARK: - 확장(UITableViewDataSource, UITableViewDelegate)
extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMemos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memo = filteredMemos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)
        cell.textLabel?.text = memo.title
        return cell
    }
    
    // UITableViewDelegate
    // 셀 선택시 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            // ✅ 선택 모드일 때는 아무 동작 안 해도 됨 (선택만 유지됨)
            return
        }

        // ✅ 일반 모드일 때만 화면 전환
        let selectedMemo = allMemos[indexPath.row]
        let detailVC = ListDetailViewController()
        detailVC.memo = selectedMemo
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // 셀을 오른쪽에서 왼쪽으로 스와이프하면 실행되는 메서드 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, completionHandler) in
            let memoToDelete = self.allMemos[indexPath.row]

            // 1. Core Data에서 삭제
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(memoToDelete)

            do {
                try context.save()
                // 2. 배열에서도 삭제
                self.allMemos.remove(at: indexPath.row)
                // 3. UI에서 삭제
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("삭제 실패: \(error)")
            }

            completionHandler(true)
        }

        // 끝까지 밀면 자동 실행되게
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
