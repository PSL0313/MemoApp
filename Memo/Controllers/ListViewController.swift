//
//  ListViewController.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit

class ListViewController: UIViewController {
    
    var listTableView = UITableView()
    
    //var memoArray: [MemoContents] = []
    // MARK: TestCode - 데이터 모델 미확정으로 우선 임시 데이터
    var memoArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    // UI 설정 메서드들을 실행하는 메서드
    private func setUI() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.96, alpha: 1.00)
        
        setupTableView()
        tableViewLayout()
        navigationBarSetting()
    }
    
    // 테이블뷰 세팅
    private func setupTableView() {
        
        listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        listTableView.rowHeight = 65            // 셀 높이 설정
        //listTableView.separatorStyle = .none    // 셀과 셀 사이의 구분선 none 처리
    }
    
    // 테이블뷰 오토레이아웃 설정
    private func tableViewLayout() {
        view.addSubview(listTableView)
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
        
    }
    
    @objc func clearTapped() {
        
    }
    
    

}

// MARK: - 확장
// 데이터를 받아오는 로직 구현 후 로직에 맞게 수정 필요
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    // 1) 테이블뷰에 표시할 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray.count
    }
    
    // 2) 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
//        cell.memoContent = memoArray[indexPath.row]
        return cell
    }
}
