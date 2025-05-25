//
//  ViewController.swift
//  QMemo
//
//  Created by 박선린 on 5/25/25.
//

import UIKit

// MARK: - 델리게이트 패턴을 위한 프로토콜 - 메인화면으로 알람시간 전달
protocol AlertTimeDelegate: AnyObject {
    func didSelectAlertTime(_ date: Date)
}

// MARK: - AlertTimeViewController
class AlertTimeViewController: UIViewController {
    
    weak var alertTimedelegate: AlertTimeDelegate?
    
    private let topbarView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    // "날짜 설정" 레이블
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.text = "날짜 및 시간 설정"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    // 날짜 및 시간 설정 피커
    private var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime     // 🕐 시간만 설정
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.layer.cornerRadius = 15
        datePicker.clipsToBounds = true
        return datePicker
    }()
    
    
    
    let cancelButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.brown.cgColor
        return button
    }()
    
    private let doneButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.brown.cgColor
        return button
    }()
    
    lazy var cancelAndDoneStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = NameSpace.ColorSetting.lightBrownColor
        setUI()
        buttonAddTarget()
    }
    
    private func setUI() {
        datePicker.backgroundColor = .white
        
        topbarView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        cancelAndDoneStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topbarView)
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(cancelAndDoneStackView)
        
        NSLayoutConstraint.activate([
            topbarView.topAnchor.constraint(equalTo: view.topAnchor),
            topbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topbarView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: topbarView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            datePicker.heightAnchor.constraint(equalToConstant: 450),
            
            cancelAndDoneStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            cancelAndDoneStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelAndDoneStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelAndDoneStackView.heightAnchor.constraint(equalToConstant: 50),
            
            
        ])
    }
    
    // 버튼 생성하면서 클로저에 사용시 에드타켓이 제대로 추가가 안될 때도 존재
    @objc private func buttonAddTarget() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        print("✅ 버튼 눌림")
        let selectedDate = datePicker.date
        alertTimedelegate?.didSelectAlertTime(selectedDate)
        print("delegate 있음:", alertTimedelegate != nil)
        dismiss(animated: true)
    }
}
