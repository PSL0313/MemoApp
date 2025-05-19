//
//  MainView.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit

class MainView: UIView {

    var memoTitle: UITextField = {
        let tf = UITextField()
        tf.placeholder = "제목"
        tf.textColor = .black
        tf.textAlignment = .left
        tf.font = .boldSystemFont(ofSize: 17)
        tf.backgroundColor = .clear
        tf.clearButtonMode = .always
        return tf
    }()
    
    var betweenLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var memoContents: UITextView = {
       let tv = UITextView()
        tv.textColor = .black
        tv.textAlignment = .left
        tv.font = .systemFont(ofSize: 13)
        tv.backgroundColor = .clear
        tv.text.append("내용 입력하기")
        tv.textColor = .lightGray
        return tv
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        self.addSubview(memoTitle)
        self.addSubview(memoContents)
        self.addSubview(betweenLine)
        memoTitle.translatesAutoresizingMaskIntoConstraints = false
        betweenLine.translatesAutoresizingMaskIntoConstraints = false
        memoContents.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            memoTitle.heightAnchor.constraint(equalToConstant: 30),
            memoTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            memoTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            memoTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            betweenLine.heightAnchor.constraint(equalToConstant: 1),
            betweenLine.topAnchor.constraint(equalTo: memoTitle.bottomAnchor, constant: 5),
            betweenLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            betweenLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            memoContents.topAnchor.constraint(equalTo: betweenLine.bottomAnchor, constant: 5),
            memoContents.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            memoContents.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            memoContents.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ])
    }
    

}
