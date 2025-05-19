//
//  PlaceTextView.swift
//  Memo
//
//  Created by 박선린 on 5/19/25.
//
import UIKit

class PlaceholderTextView: UITextView {

    // 플레이스홀더 라벨
    private let placeholderLabel: UILabel = UILabel()

    // 외부에서 접근 가능한 placeholder 텍스트
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    // 플레이스홀더 색상 설정 가능
    var placeholderColor: UIColor = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    // 초기화
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupPlaceholder()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlaceholder()
    }

    private func setupPlaceholder() {
        // 기본 스타일
        placeholderLabel.font = self.font ?? UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.backgroundColor = .clear

        addSubview(placeholderLabel)

        // 오토레이아웃: 텍스트와 잘 맞도록 조정
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])

        // 텍스트 변경 감지
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChangeNotification),
            name: UITextView.textDidChangeNotification,
            object: self
        )

        // 초기 상태 업데이트
        updatePlaceholderVisibility()
    }

    @objc private func textDidChangeNotification() {
        updatePlaceholderVisibility()
    }

    public func updatePlaceholderVisibility() {
        let trimmed = self.text.trimmingCharacters(in: .whitespacesAndNewlines)
        placeholderLabel.isHidden = !trimmed.isEmpty
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
