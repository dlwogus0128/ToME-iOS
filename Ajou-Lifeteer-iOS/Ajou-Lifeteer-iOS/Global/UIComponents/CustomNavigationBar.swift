//
//  CustomNavigationBar.swift
//  Ajou-Lifeteer-iOS
//
//  Created by 몽이 누나 on 2023/07/10.
//

import UIKit

import SnapKit
import Then

@frozen
enum NaviType {
    /// 나중에 필요없는 코드 삭제할 것!!!!!!
    case backButton // 뒤로가기 버튼
    case backButtonWithTitle // 뒤로가기 버튼 + 중앙 타이틀
    case buttonsWithTitle // 뒤로가기 버튼 + 중앙 타이틀
    case onlyBI // BI만 존재
    case onlyTitle // Title만 존재
    
    case home // 홈에 존재하는 네비바
    case singleTitle // 타이틀이 한줄인 네비바
    case withoutBackground  // 뒷배경이 존재하지 않는 네비바
}

final class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var naviType: NaviType!
    private var vc: UIViewController?
    private var backButtonClosure: (() -> Void)?
    private var menuButtonClosure: (() -> Void)?

    // MARK: - UI Components
    
    private let centerTitleLabel = UILabel()
    private let backButton = UIButton()
    private let mindSetBIImageView = UIImageView()
    
    private let logoLabel = UILabel().then {
        $0.text = "to Me"
    }
    
    private let missionButton = UIButton()
    private let mypageButton = UIButton()
    
    // MARK: - initialization
    
    init(_ vc: UIViewController, type: NaviType) {
        super.init(frame: .zero)
        self.vc = vc
        self.setUI(type)
        self.setLayout(type)
        self.setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CustomNavigationBar {
    private func setAddTarget() {
        self.backButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
        self.missionButton.addTarget(self, action: #selector(missionButtonDidTap), for: .touchUpInside)
    }
    
    @discardableResult
    func setUserName(_ name: String) -> Self {
        self.centerTitleLabel.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let attributedText = NSAttributedString(
            string: "\(name)님,\n어서오세요!",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.title1,
                NSAttributedString.Key.foregroundColor: UIColor.font1
            ]
        )
        
        self.centerTitleLabel.attributedText = attributedText
        return self
    }
    
    @discardableResult
    func setTitle(_ title: String) -> Self {
        self.centerTitleLabel.font = .title2
        self.centerTitleLabel.text = title
        return self
    }
    
    @discardableResult
    func resetBackButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.backButtonClosure = closure
        self.backButton.removeTarget(self, action: nil, for: .touchUpInside)
        if closure != nil {
            self.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        } else {
            self.setAddTarget()
        }
        return self
    }
}

// MARK: - @objc Function

extension CustomNavigationBar {
    @objc private func popToPreviousVC() {
        self.vc?.navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonDidTap() {
        self.backButtonClosure?()
    }
    
    @objc private func missionButtonDidTap() {
        let missionVC = CustomPopUpVC(type: .todaysMission,
                                      title: "오늘의 미션",
                                      subTitle: "티오의 성장까지",
                                      level: 300,
                                      levelName: nil)
        missionVC.modalPresentationStyle = .overFullScreen
        vc?.present(missionVC, animated: false)
    }
}

// MARK: - UI & Layout

extension CustomNavigationBar {
    private func setBackgroundUI() {
        self.backgroundColor = .back1
        self.layer.cornerRadius = 15
    }
    
    private func setTitleUI() {
        logoLabel.font = .logo
        logoLabel.textColor = .font1
        logoLabel.isHidden = false
        
        centerTitleLabel.textColor = .font1
        centerTitleLabel.isHidden = false
    }
    
    private func setHomeUI() {
        logoLabel.font = .logo
        logoLabel.textColor = .font1
        logoLabel.isHidden = false
        
        centerTitleLabel.font = .title1
        centerTitleLabel.textColor = .font1
        centerTitleLabel.textAlignment = .left
        centerTitleLabel.isHidden = false
        
        missionButton.setImage(ImageLiterals.homeBtnMission, for: .normal)
        mypageButton.setImage(ImageLiterals.homeBtnMypage, for: .normal)
    }
    
    private func setUI(_ type: NaviType) {
        self.naviType = type
        
        switch type {
        case .backButton:
            backButton.isHidden = false
            backButton.setImage(ImageLiterals.introIcCheck, for: .normal)
        case .backButtonWithTitle:
            setTitleUI()
            backButton.setImage(ImageLiterals.introIcCheck, for: .normal)
        case .buttonsWithTitle:
            setTitleUI()
            backButton.setImage(ImageLiterals.introIcCheck, for: .normal)
        case .onlyBI:
            mindSetBIImageView.image = ImageLiterals.introIcCheck
            
        case .onlyTitle:
            setBackgroundUI()
            centerTitleLabel.font = .body1
            setTitleUI()
        case .home:
            setBackgroundUI()
            setHomeUI()
        case .singleTitle:
            setBackgroundUI()
            setHomeUI()
        case .withoutBackground:
            centerTitleLabel.font = .body1
            setTitleUI()
        }
    }
    
    private func setLayout(_ type: NaviType) {
        switch type {
        case .backButton:
            setBackButtonLayout()
        case .backButtonWithTitle:
            setBackButtonWithTitleLayout()
        case .buttonsWithTitle:
            setButtonsWithTitleLayout()
        case .onlyBI:
            setOnlyBILayout()
        case .onlyTitle:
            setOnlyTitleLayout()
        case .home:
            setHomeLayout()
            
            mypageButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(54)
            }
            
            missionButton.snp.makeConstraints { make in
                make.bottom.equalTo(mypageButton.snp.bottom)
            }
        case .singleTitle:
            setHomeLayout()
            
            mypageButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(17)
            }
            
            missionButton.snp.makeConstraints { make in
                make.bottom.equalTo(mypageButton.snp.bottom)
            }
        case .withoutBackground:
            setHomeLayout()
        }
    }
    
    private func setBackButtonLayout() {
        self.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(22)
            make.width.equalTo(11)
        }
    }
    
    private func setBackButtonWithTitleLayout() {
        self.addSubviews(backButton, centerTitleLabel)
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(22)
            make.width.equalTo(11)
        }
        
        centerTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func setButtonsWithTitleLayout() {
        self.addSubviews(backButton, mindSetBIImageView, centerTitleLabel)
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(22)
            make.width.equalTo(11)
        }
        
        mindSetBIImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(11)
            make.height.equalTo(31)
            make.width.equalTo(43)
        }
        
        centerTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func setOnlyBILayout() {
        self.addSubview(mindSetBIImageView)
        
        mindSetBIImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(11)
            make.height.equalTo(31)
            make.width.equalTo(43)
        }
    }
    
    private func setOnlyTitleLayout() {
        self.addSubviews(logoLabel, centerTitleLabel)
        
        centerTitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(27)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(76)
            make.leading.equalTo(centerTitleLabel.snp.leading)
        }
    }
    
    private func setHomeLayout() {
        self.addSubviews(logoLabel, centerTitleLabel, missionButton, mypageButton)
        
        centerTitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(27)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(76)
            make.leading.equalTo(centerTitleLabel.snp.leading)
        }
        
        mypageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(27)
            make.width.height.equalTo(32)
        }
        
        missionButton.snp.makeConstraints { make in
            make.trailing.equalTo(mypageButton.snp.leading).offset(-16)
            make.width.height.equalTo(32)
        }
    }
}
