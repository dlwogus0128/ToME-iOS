//
//  MissionDetailVC.swift
//  Ajou-Lifeteer-iOS
//
//  Created by 몽이 누나 on 11/6/23.
//

import UIKit

import SnapKit
import Then

final class MissionDetailVC: UIViewController {
    
    // MARK: - Properties

    private var photoManager: ToMEPhotoManager?
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .singleTitle).setTitle("미션")
    
    /// top 부분, 미션 수행 개수를 적어서 넣어주기
    private lazy var currentMissionCompleteView = CurrentMissionCompleteView(numberOfCompleteMission: 1)
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.disabled2.cgColor
    }
    
    private let missionImageView = UIImageView().then {
        $0.layer.cornerRadius = 5
    }
    
    private let missionTypeLabel = UILabel().then {
        $0.font = .body2
        $0.textColor = .font3
    }
    
    private let horizontalDevidedView = UIView()
    
    private let missionTitleLabel = UILabel().then {
        $0.font = .newBody2
        $0.textColor = .font1
    }
    
    private lazy var startMissionButton = CustomButton(title: "미션 수행하러 가기", type: .fillWithBlueAndImage)
                                                        .setImage(image: ImageLiterals.gallaryBtnImageFill)
    
    private lazy var backButton = CustomButton(title: "다른 미션 보러가기", type: .fillWithGreyAndImage)
                                                        .setImage(image: ImageLiterals.backBtnImage)

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideTabBar(wantsToHide: true)
        setUI()
        setLayout()
        setAddTarget()
        // PhotoManager 초기화
        photoManager = ToMEPhotoManager(vc: self)
    }
}

// MARK: - @objc Function

extension MissionDetailVC {
    @objc private func popToPreviousVC() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func startMissionButtonDidTap() {
        pushToPhotoAlertController()
        // crop이 끝난 사진을 missionImageView의 image로 설정
        photoManager?.didFinishCropping = { croppedImage in
            self.missionImageView.image = croppedImage
            
        }
    }
}

// MARK: - Methods

extension MissionDetailVC {
    func setData(missionType: Int, missionTitle: String) {
        if missionType == 0 {
            missionTypeLabel.text = "찰칵 미션"
            missionImageView.image = ImageLiterals.missionImgPhotoRectangle
        } else if missionType == 1 {
            missionTypeLabel.text = "데시벨 미션"
            missionImageView.image = ImageLiterals.missionImgDecibel
        } else {
            missionTypeLabel.text = "텍스트 미션"
            missionImageView.image = ImageLiterals.missionImgText
        }
        
        missionTitleLabel.text = missionTitle
    }
    
    func setAddTarget() {
        self.startMissionButton.addTarget(self, action: #selector(startMissionButtonDidTap), for: .touchUpInside)
        self.backButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
    }
    
    func pushToPhotoAlertController() {
        let photoAlertController = UIAlertController(title: "사진 업로드", message: nil, preferredStyle: .actionSheet)
        // 카메라 권한 확인 및 카메라 열기
        let photoAction = UIAlertAction(title: "사진 선택하기", style: .default, handler: {(_: UIAlertAction!) in
            self.photoManager?.requestAlbumAuthorization()
        })
        let cameraAction = UIAlertAction(title: "카메라로 촬영하기", style: .default, handler: {(_: UIAlertAction!) in
            self.photoManager?.requestCameraAuthorization()
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [ photoAction, cameraAction, cancelAction ].forEach { photoAlertController.addAction($0) }
        present(photoAlertController, animated: true, completion: nil)
    }
}

// MARK: - UI & Layout

extension MissionDetailVC {
    private func setUI() {
        view.backgroundColor = .systemGray
        self.containerView.backgroundColor = .disabled2.withAlphaComponent(0.6)
        self.horizontalDevidedView.backgroundColor = .font3
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, currentMissionCompleteView, containerView)
        
        naviBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(140)
        }
        
        currentMissionCompleteView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        setContainerViewLayout()
        
        view.addSubviews(startMissionButton, backButton)
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(27)
            make.height.equalTo(53)
        }
        
        startMissionButton.snp.makeConstraints { make in
            make.bottom.equalTo(backButton.snp.top).offset(-10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(27)
            make.height.equalTo(53)
        }
    }
    
    private func setContainerViewLayout() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(170)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(27)
        }
        
        containerView.addSubviews(missionImageView, missionTypeLabel, horizontalDevidedView, missionTitleLabel)
        
        missionImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.trailing.equalToSuperview().inset(21)
            make.height.equalTo(missionImageView.snp.width).multipliedBy(0.7)
        }
        
        missionTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(missionImageView.snp.leading)
            make.top.equalTo(missionImageView.snp.bottom).offset(14)
        }
        
        horizontalDevidedView.snp.makeConstraints { make in
            make.top.equalTo(missionTypeLabel.snp.bottom).offset(8)
            make.leading.equalTo(missionImageView.snp.leading)
            make.width.equalTo(97)
            make.height.equalTo(0.5)
        }
        
        missionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalDevidedView.snp.bottom).offset(10)
            make.leading.equalTo(missionImageView.snp.leading)
        }
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalTo(missionTitleLabel.snp.bottom).offset(20)
        }
    }
}
