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
    private let filterStackView = UIStackView()
    private var allMemos: [MemoEntity] = []
    private var filteredMemos: [MemoEntity] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemos()
    }

    private func loadMemos() {
        allMemos = MemoDataManager.shared.fetchMemos()
        tableView.reloadData()
    }
    
    //var memoArray: [MemoContents] = []
    // MARK: TestCode - 데이터 모델 미확정으로 우선 임시 데이터
    var memoArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateSetting()
        setUI()
        navigationBarSetting()
    }
    
    private func delegateSetting() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // UI 설정 메서드들을 실행하는 메서드
    private func setUI() {
        view.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.94, alpha: 1.0)
        // 1. 필터 스택뷰
        let titles = ["전체", "일반", "시간", "위치"]
        let buttons = titles.enumerated().map { index, title -> UIButton in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            return button
        }
        filterStackView.axis = .horizontal
        filterStackView.distribution = .fillEqually
        filterStackView.spacing = 8
        buttons.forEach { filterStackView.addArrangedSubview($0) }

        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(filterStackView)
        view.addSubview(tableView)

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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            filteredMemos = allMemos
        case 1:
            filteredMemos = allMemos.filter { memo in
                let noTimeAlarm = memo.alertTime == nil
                let noLocation = (memo.latitude ?? 0) == 0 && (memo.longitude ?? 0) == 0
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        do {
            allMemos = try context.fetch(request)
            filteredMemos = allMemos
            tableView.reloadData()
        } catch {
            print("❌ 메모 불러오기 실패: \(error)")
        }
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearTapped))
        navigationItem.leftBarButtonItem?.tintColor = .red
    }
    
    
    @objc func addTapped() {
        
        let nextVC = MainViewController()
//        nextVC.memo = self.currentMemo   예: 메모 데이터 전달
        nextVC.isFromList = true
        navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    
    @objc func clearTapped() {
        
    }
    
    

}

// MARK: - 확장
// 데이터를 받아오는 로직 구현 후 로직에 맞게 수정 필요
extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMemos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memo = allMemos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)
        cell.textLabel?.text = memo.title
        return cell
    }
    
    // UITableViewDelegate
    // 셀 선택시 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = allMemos[indexPath.row]

        let detailVC = ListDetailViewController() // 네가 만든 상세 뷰컨트롤러
        detailVC.memo = selectedMemo          // ✅ 데이터 넘기기

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
