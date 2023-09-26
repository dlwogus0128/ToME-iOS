//
//  TalkingDetailVC.swift
//  Ajou-Lifeteer-iOS
//
//  Created by 몽이 누나 on 2023/09/24.
//

import UIKit

import SnapKit
import Then

final class TalkingDetailVC: UIViewController {
    
    // MARK: - Properties

    var checkQuestionButtonState: Bool = true
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .singleTitle).setTitle("To. Me")
    
    private let questionButton = UIButton(type: .custom).then {
        $0.setImage(ImageLiterals.talkingBtnQuestion, for: .normal)
    }
    
    private let questionExplainView = UIView().then {
        $0.layer.cornerRadius = 5
    }
    
    private let questionExplainLabel = UILabel().then {
        $0.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attributedText = NSAttributedString(
            string: "심리상담가 티오는 당신의 일상이 궁금해요.\n티오에게 오늘 있었던 일을 얘기해 주세요.\n티오는 chat GPT ~~를 ~~하고 있습니다.",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.body2,
                NSAttributedString.Key.foregroundColor: UIColor.font2
            ]
        )
        $0.attributedText = attributedText
    }
    
    private let talkingMessageVC = TalkingMessageVC()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }
}

// MARK: - @objc Function

extension TalkingDetailVC {
    @objc private func questionButtonDidTap() {
        questionButtonState()
    }
}

// MARK: - Methods

extension TalkingDetailVC {
    private func setAddTarget() {
        self.questionButton.addTarget(self, action: #selector(questionButtonDidTap), for: .touchUpInside)
    }
    
    private func setDelegate() {
        
    }
    
    private func questionButtonState() {
        if checkQuestionButtonState {
            showQuestionView()
            checkQuestionButtonState.toggle()
        } else {
            hideQuestionView()
            checkQuestionButtonState.toggle()
        }
    }
}

// MARK: - UI & Layout

extension TalkingDetailVC {
    private func setUI() {
        view.backgroundColor = .systemGray3
        questionExplainView.backgroundColor = .sub2
    }
    
    private func setLayout() {
        view.addSubviews(naviBar)
        
        self.addChild(talkingMessageVC)
        view.addSubview(talkingMessageVC.view)
        
        naviBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(142)
        }
        
        talkingMessageVC.view.addSubviews(questionButton, questionExplainView)
        
        talkingMessageVC.view.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).inset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().inset(92)
        }
        
        questionButton.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.height.equalTo(70)
        }
        
        questionExplainView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(10)
            make.leading.equalTo(questionButton.snp.trailing)
            make.height.equalTo(76)
            make.width.equalTo(273)
        }
        
        questionExplainView.addSubview(questionExplainLabel)
        
        questionExplainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        hideQuestionView()
    }
    
    private func showQuestionView() {
        questionExplainView.isHidden = false
        questionExplainLabel.isHidden = false
    }

    private func hideQuestionView() {
        questionExplainView.isHidden = true
        questionExplainLabel.isHidden = true
    }
}