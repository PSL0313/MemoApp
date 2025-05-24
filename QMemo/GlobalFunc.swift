//
//  ShowToast.swift
//  QMemo
//
//  Created by 박선린 on 5/24/25.
//

import UIKit

// MARK: - 토스트 메세지 띄우는 메서드
func showToast(defaultViewName defaultView: UIView ,message: String, duration: Double = 2.0) {
    print("showToast 메서드 실행됨")
    let toastLabel = PaddingLabel() // ✅ 기존 UILabel 대신
    toastLabel.inset = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
    toastLabel.text = message
    toastLabel.textColor = .black
    toastLabel.textAlignment = .center
    toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    toastLabel.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.91, alpha: 1.0)
    toastLabel.numberOfLines = 0
    toastLabel.layer.cornerRadius = 12
    toastLabel.clipsToBounds = true
    toastLabel.alpha = 0.0
    toastLabel.translatesAutoresizingMaskIntoConstraints = false
    
    defaultView.addSubview(toastLabel)
    
    // 💡 오토레이아웃 제약
    let maxWidth = defaultView.frame.width * 0.6
    NSLayoutConstraint.activate([
        toastLabel.centerXAnchor.constraint(equalTo: defaultView.centerXAnchor),
        toastLabel.topAnchor.constraint(equalTo: defaultView.safeAreaLayoutGuide.topAnchor, constant: 80),
        toastLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
        toastLabel.leadingAnchor.constraint(greaterThanOrEqualTo: defaultView.leadingAnchor, constant: 20),
        toastLabel.trailingAnchor.constraint(lessThanOrEqualTo: defaultView.trailingAnchor, constant: -20)
    ])
    
    // ⚡️ 필수: 내부 여백을 위해 contentInsets 대신 패딩 추가 (내부 사용 시)
    toastLabel.setContentHuggingPriority(.required, for: .vertical)
    toastLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    
    // 애니메이션
    UIView.animate(withDuration: 0.3, animations: {
        toastLabel.alpha = 1.0
    }) { _ in
        UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
}

