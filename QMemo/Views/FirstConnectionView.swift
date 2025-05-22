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
        label.text = "간단한 설정을 완료해주세요."
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
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var textSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "글씨 크기"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var textSizeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 10
        slider.maximumValue = 100
        slider.value = 15
        return slider
    }()
    
    lazy var textSizeSliderMinValueLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var textSizeSliderMAXValueLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var trashToggle: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = true
        return switchView
    }()
    
    lazy var trashLabel: UILabel = {
        let label = UILabel()
        label.text = "휴지통 자동 정리"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var trashDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "자동 정리를 사용하면 용량 관리가 수월합니다."
        label.font = .systemFont(ofSize: 8, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    // 보관기간
    lazy var storagePeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "보관기간"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var storagePeriodTF: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "90"
        return tf
    }()
    lazy var storagePeriodDayLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        return label
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
        addSubview(textSizeLabel)
        addSubview(textSizeSlider)
        addSubview(textSizeSliderMAXValueLabel)
        addSubview(textSizeSliderMinValueLabel)
        addSubview(trashLabel)
        addSubview(trashToggle)
        addSubview(trashDescriptionLabel)
        addSubview(storagePeriodLabel)
        addSubview(storagePeriodTF)
        addSubview(storagePeriodDayLabel)
        addSubview(nextButton)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        textSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        textSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        textSizeSliderMAXValueLabel.translatesAutoresizingMaskIntoConstraints = false
        textSizeSliderMinValueLabel.translatesAutoresizingMaskIntoConstraints = false
        trashLabel.translatesAutoresizingMaskIntoConstraints = false
        trashDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        trashToggle.translatesAutoresizingMaskIntoConstraints = false
        storagePeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        storagePeriodTF.translatesAutoresizingMaskIntoConstraints = false
        storagePeriodDayLabel.translatesAutoresizingMaskIntoConstraints = false
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
            
            textSizeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textSizeLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 70),
            textSizeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textSizeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            textSizeLabel.heightAnchor.constraint(equalToConstant: 25),
            
            textSizeSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
            textSizeSlider.topAnchor.constraint(equalTo: textSizeLabel.bottomAnchor, constant: 10),
            textSizeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70),
            textSizeSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -70),
            
            textSizeSliderMinValueLabel.centerYAnchor.constraint(equalTo: textSizeSlider.centerYAnchor),
            textSizeSliderMinValueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textSizeSliderMinValueLabel.trailingAnchor.constraint(equalTo: textSizeSlider.leadingAnchor, constant: 5),
            
            textSizeSliderMAXValueLabel.centerYAnchor.constraint(equalTo: textSizeSlider.centerYAnchor),
            textSizeSliderMAXValueLabel.leadingAnchor.constraint(equalTo: textSizeSlider.trailingAnchor, constant: 5),
            textSizeSliderMAXValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            trashLabel.topAnchor.constraint(equalTo: textSizeSlider.bottomAnchor, constant: 50),
            trashLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            trashLabel.heightAnchor.constraint(equalToConstant: 20),
            trashLabel.widthAnchor.constraint(equalToConstant: 200),
            
            trashDescriptionLabel.topAnchor.constraint(equalTo: trashLabel.bottomAnchor, constant: 1),
            trashDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            trashDescriptionLabel.heightAnchor.constraint(equalToConstant: 9),
            trashDescriptionLabel.widthAnchor.constraint(equalToConstant: 200),
            
            trashToggle.centerYAnchor.constraint(equalTo: trashLabel.centerYAnchor),
            trashToggle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            trashToggle.heightAnchor.constraint(equalToConstant: 30),
            
            storagePeriodLabel.topAnchor.constraint(equalTo: trashDescriptionLabel.bottomAnchor, constant: 30),
            storagePeriodLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            storagePeriodLabel.heightAnchor.constraint(equalToConstant: 20),
            storagePeriodLabel.widthAnchor.constraint(equalToConstant: 200),
            
            storagePeriodDayLabel.centerYAnchor.constraint(equalTo: storagePeriodLabel.centerYAnchor),
            storagePeriodDayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            storagePeriodDayLabel.heightAnchor.constraint(equalToConstant: 20),
            
            storagePeriodTF.centerYAnchor.constraint(equalTo: storagePeriodLabel.centerYAnchor),
            storagePeriodTF.trailingAnchor.constraint(equalTo: storagePeriodDayLabel.leadingAnchor, constant: -2),
            storagePeriodTF.widthAnchor.constraint(equalToConstant: 50),
            
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            nextButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
    
    
}


