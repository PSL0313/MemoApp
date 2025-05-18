//
//  FirstConnectionView.swift
//  Memo
//
//  Created by 박선린 on 5/16/25.
//

import UIKit

class FirstConnectionView: UIView {

    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "원하시는 설정을 선택해주세요."
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.text = "개인 설정에서 언제든지 변경할 수 있습니다."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음으로", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
     
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = .white
        
        addSubview(mainLabel)
        addSubview(subLabel)
        
        addSubview(nextButton)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainLabel.heightAnchor.constraint(equalToConstant: 30),
            
            subLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 5),
            subLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
            subLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -20),
            subLabel.heightAnchor.constraint(equalToConstant: 15),
            
            
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            nextButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            
        ])
        
    }
    
    
}
