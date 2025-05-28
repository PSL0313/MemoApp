//
//  ListView - TableViewCell.swift
//  Memo
//
//  Created by 박선린 on 5/14/25.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    var memoContent: MemoEntity? {
        didSet {
            titleLabel.text = memoContent?.title
            contentLabel.text = memoContent?.content
            
            dateLabel.textColor = .systemGray
            // 알람도 없고 위치 정보도 없는 경우
            guard !(memoContent?.alertTime == nil && memoContent?.latitude == 0 && memoContent?.longitude == 0) else {
                print("알람도 없고 위치 정보도 없음 → 실행 안 함")
                
                if let date = memoContent?.createdAt {
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ko_KR")
                    formatter.dateFormat = "yyyy. MM. dd. a h시 mm분"
//                    formatter.dateFormat = "yyyy년 MM월 dd일 a h시 mm분"
                    let formattedDate = formatter.string(from: date)
                    
                    dateLabel.text = "생성일: \(formattedDate)"
                }
                
                return
            }
            
            
            if memoContent?.alertTime != nil {
                // 알람 시간 설정한게 있는 경우
                
                if let date = memoContent?.alertTime {
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ko_KR")
                    formatter.dateFormat = "yyyy. MM. dd. a h시 mm분"
//                    formatter.dateFormat = "yyyy년 MM월 dd일 a h시 mm분"
                    let formattedDate = formatter.string(from: date)
                    
                    dateLabel.text = "알람 시간: \(formattedDate)"
                }
                
                return
            }
            
            if memoContent?.latitude != nil && memoContent?.longitude != nil {
                // 알람 위치 설정한게 있는 경우
            }
        }
    }
    
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()  // ✅ UI 구성 여기에
        selectedBackgroundView = UIView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()  // ✅ 이건 보통 사용되지 않지만 대비용
        selectedBackgroundView = UIView()
    }
    
    private func setupUI() {
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(dateLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -8),

            // dateLabel - 우측 상단
            dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // contentLabel - 좌우 기준을 titleLabel & dateLabel에 맞춤
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            
            ])
    }
    
}
