//
//  MainView.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit

class MainView: UIView {

    let memoTitle: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        textField.clearButtonMode = .always
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.setLeftPadding(12)  // 커스텀 extension 아래 참고
        return textField
    }()
    
    var memoContents: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.placeholder = "  내용 입력하기"
        textView.textColor = .black
        textView.textAlignment = .left
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = .interactive
        textView.font = .systemFont(ofSize: 13)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 12
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        return textView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(memoTitle)
        addSubview(memoContents)
        
        memoTitle.translatesAutoresizingMaskIntoConstraints = false
        memoContents.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            memoTitle.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            memoTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            memoTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            memoTitle.heightAnchor.constraint(equalToConstant: 40),
            
            memoContents.topAnchor.constraint(equalTo: memoTitle.bottomAnchor, constant: 12),
            memoContents.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            memoContents.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            memoContents.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
