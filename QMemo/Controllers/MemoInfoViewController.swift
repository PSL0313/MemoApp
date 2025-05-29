//
//  MemoInfoViewController.swift
//  QMemo
//
//  Created by 박선린 on 5/27/25.
//

import UIKit

class MemoInfoViewController: UIViewController {
    
    var memo: MemoEntity? {
        didSet {
            // 생성일
            if let date = memo?.createdAt {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR")
                formatter.dateFormat = "yyyy. MM. dd. a h시 mm분"
                let formattedDate = formatter.string(from: date)
                
                memoCreatedAt2.text = "생성일:"
                memoCreatedAt.text = "\(formattedDate)"
            }
            
            memoTitle2.text = "\(memo?.title ?? "제목 없음")"
            memoContent.text = "\(memo?.content ?? "내용 없음")"
            
            if let date = memo?.alertTime {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR")
                formatter.dateFormat = "yyyy. MM. dd. a h시 mm분"
                let formattedDate = formatter.string(from: date)
                
                memoAlarmChoiceTitle.text = "알람 종류:"
                memoAlarmChoiceValue.text = "시간 알람"
                memoAlarmChoiceDetailTitle.text = "시간:"
                memoAlarmChoiceDetailValue.text = "\(formattedDate)" //시간 알람 설정 상태: yyyy. MM. dd. a h시 mm분
            }
            
            
            if let data = memo?.latitude, let data2 = memo?.longitude {
                if data != 0 && data2 != 0 {
                    memoAlarmChoiceTitle.text = "알람 종류:"
                    memoAlarmChoiceValue.text = "위치 알람"
                    memoAlarmChoiceDetailTitle.text = "위치(좌표):"
                    memoAlarmChoiceDetailValue.text =  "위도- \(data), 경도- \(data2)"
                }
            }
            
            if memo?.latitude == 0 && memo?.longitude == 0 && memo?.alertTime == nil {
                memoAlarmChoiceTitle.text = "알람 종류:"
                memoAlarmChoiceValue.text = "알람 미설정"
                memoAlarmChoiceDetailTitle.text = "세부 정보:"
                memoAlarmChoiceDetailValue.text =  "없음"
            }
            
        }
    }
    var memoCreatedAt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    var memoCreatedAt2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.text = "메모 생성일"
        return label
    }()
    
    // 생성일 스택뷰
    lazy var memoCreatedAtstackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memoCreatedAt2, memoCreatedAt])
        memoCreatedAt2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    var memoAlarmChoiceTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    var memoAlarmChoiceValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    var memoAlarmChoiceDetailTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    var memoAlarmChoiceDetailValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var memoAlarmInfostackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memoAlarmChoiceTitle, memoAlarmChoiceValue])
        memoAlarmChoiceTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var memoAlarmDetailInfostackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memoAlarmChoiceDetailTitle, memoAlarmChoiceDetailValue])
        memoAlarmChoiceDetailTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var memoAlarmstackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memoAlarmInfostackView, memoAlarmDetailInfostackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    var memoTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.text = "제목:"
        return label
    }()
    
    var memoTitle2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var memoTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memoTitle, memoTitle2])
        memoTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    var memoContent: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    var memoContent2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.text = "내용:"
        return label
    }()
    
    var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    var lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    var lineView4: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    var showToastUpdateCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setShowToast()
        
    }
    
    private func setShowToast() {
        if showToastUpdateCheck {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                showToast(defaultViewName: self.view, message: "업데이트 완료")
            }
        }
    }
    
    
    private func setUI() {
        let labelArray: [UIStackView] = [memoCreatedAtstackView, memoAlarmstackView,memoTitleStackView]
        let UIViewArray: [UIView] = [lineView1, lineView2, lineView3, lineView4, memoContent]
        
        view.backgroundColor = .white
        
        labelArray.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        UIViewArray.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        memoContent.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(memoContent)
        
        let subTitleheight:CGFloat = 15
        
        NSLayoutConstraint.activate([
            memoCreatedAtstackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            memoCreatedAtstackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memoCreatedAtstackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            memoCreatedAtstackView.heightAnchor.constraint(equalToConstant: subTitleheight ),
            
            lineView1.topAnchor.constraint(equalTo: memoCreatedAtstackView.bottomAnchor, constant: 10),
            lineView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            lineView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            lineView1.heightAnchor.constraint(equalToConstant: 1),
            
            memoAlarmstackView.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 10),
            memoAlarmstackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memoAlarmstackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            memoAlarmstackView.heightAnchor.constraint(equalToConstant: subTitleheight * 2),
            
            lineView2.topAnchor.constraint(equalTo: memoAlarmstackView.bottomAnchor, constant: 10),
            lineView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            lineView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            lineView2.heightAnchor.constraint(equalToConstant: 1),
            
            memoTitleStackView.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 10),
            memoTitleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memoTitleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            memoTitleStackView.heightAnchor.constraint(equalToConstant: subTitleheight),
            
            memoContent.topAnchor.constraint(equalTo: memoTitleStackView.bottomAnchor, constant: 5),
            memoContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memoContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            memoContent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            
            ])
    }
        
        
        
    
}
