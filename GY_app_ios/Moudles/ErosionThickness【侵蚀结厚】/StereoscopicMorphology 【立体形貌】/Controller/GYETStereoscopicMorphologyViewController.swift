//
//  GYETStereoscopicMorphologyViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/12/13.
//

import UIKit
import SceneKit

class GYETStereoscopicMorphologyViewController: GYViewController {

    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var modelLabel:UILabel = {
        let label = UILabel()
        label.text = "模型："
        return label
    }()
    
    private lazy var wholeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 整体", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(modelBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var crossBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 截面", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(crossBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var scaleLabel:UILabel = {
        let label = UILabel()
        label.text = "显示比例："
        return label
    }()
    
    private lazy var fiftyBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 50%", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(fiftyBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var hundredBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 100%", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(hundredBtnClick), for: .touchUpInside)
        btn.isSelected = true
        return btn
    }()
    
    private lazy var hundredfiftyBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 150%", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(hundredfiftyBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var viewLabel:UILabel = {
        let label = UILabel()
        label.text = "视图："
        return label
    }()
    
    private lazy var frontviewBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 正视图", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(frontviewBtnClick), for: .touchUpInside)
        btn.isSelected = true
        return btn
    }()
    
    private lazy var sideviewBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 侧视45%", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(sideviewBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var midView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var fbxView:SCNView = {
//        let filePath = Bundle.main.path(forResource: "CaiJiHe_LED", ofType: "fbx")
//        let view = SCNView()
//        view.backgroundColor = .white
//        view.autoenablesDefaultLighting = true
//        let scene = SCNScene(named: "CaiJiHe_LED.obj")
//
//        view.scene = scene
//
//        //额外光照
//        let ambientLightNode = SCNNode()
        //        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .ambient
//        ambientLightNode.light!.color = UIColor(white: 0.50, alpha: 1.0)
//
//        // Add ambient light to scene 光照
//        scene?.rootNode.addChildNode(ambientLightNode)
//
//        // Create directional light
//        let directionalLight = SCNNode()
//        directionalLight.light = SCNLight()
//        directionalLight.light!.type = .directional
//        directionalLight.light!.color = UIColor(white: 0.40, alpha: 1.0)
//        directionalLight.eulerAngles = SCNVector3(x: Float.pi, y: 0, z: 0)
//
//        // Add directional light
//        scene!.rootNode.addChildNode(directionalLight)
        

        // 创建一个场景
        let scene = SCNScene(named: "CaiJiHe_LED.obj")
        
        // 遍历场景中的节点
        for node in scene!.rootNode.childNodes {
            // 检查节点是否包含几何体
            if let geometry = node.geometry {
                // 创建一个材质对象
                let material = SCNMaterial()
                
                // 设置材质的漫反射颜色贴图（diffuse.contents）
                material.diffuse.contents = UIImage(named: "1281702515263.jpg")
                
                // 将材质应用到几何体上的所有表面
                geometry.materials = [material]
            }
        }

        // 创建一个视图来显示场景
        let view = SCNView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.scene = scene
        view.allowsCameraControl = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addLayout()
//        request()
    }
    
}

extension GYETStereoscopicMorphologyViewController {
    func setupViews() {
        self.title = "侵蚀立体形貌"
        
        self.view.addSubview(headView)
        headView.addSubview(modelLabel)
        headView.addSubview(wholeBtn)
        headView.addSubview(crossBtn)
        headView.addSubview(scaleLabel)
        headView.addSubview(fiftyBtn)
        headView.addSubview(hundredBtn)
        headView.addSubview(hundredfiftyBtn)
        headView.addSubview(viewLabel)
        headView.addSubview(frontviewBtn)
        headView.addSubview(sideviewBtn)
        self.view.addSubview(midView)
        midView.addSubview(fbxView)
    }
    
    func addLayout() {
        headView.snp.makeConstraints { make in
            make.top.equalTo(topHeight + 5)
            make.left.right.equalTo(0)
        }
        
        modelLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(17)
            make.height.equalTo(21)
        }
        
        wholeBtn.snp.makeConstraints { make in
            make.left.equalTo(modelLabel.snp.right).offset(35)
            make.centerY.equalTo(modelLabel)
            make.height.equalTo(20)
        }
        
        crossBtn.snp.makeConstraints { make in
            make.left.equalTo(wholeBtn.snp.right).offset(60)
            make.centerY.equalTo(modelLabel)
            make.height.equalTo(20)
        }
        
        scaleLabel.snp.makeConstraints { make in
            make.left.equalTo(modelLabel)
            make.top.equalTo(modelLabel.snp.bottom).offset(21)
            make.height.equalTo(21)
        }
        
        fiftyBtn.snp.makeConstraints { make in
            make.left.equalTo(wholeBtn)
            make.centerY.equalTo(scaleLabel)
            make.height.equalTo(20)
        }
        
        hundredBtn.snp.makeConstraints { make in
            make.left.equalTo(fiftyBtn.snp.right).offset(27)
            make.centerY.equalTo(scaleLabel)
            make.height.equalTo(20)
        }
        
        hundredfiftyBtn.snp.makeConstraints { make in
            make.left.equalTo(hundredBtn.snp.right).offset(27)
            make.centerY.equalTo(scaleLabel)
            make.height.equalTo(20)
        }
        
        viewLabel.snp.makeConstraints { make in
            make.left.equalTo(scaleLabel)
            make.top.equalTo(scaleLabel.snp.bottom).offset(21)
            make.height.equalTo(21)
        }
        
        frontviewBtn.snp.makeConstraints { make in
            make.left.equalTo(wholeBtn)
            make.centerY.equalTo(viewLabel)
            make.height.equalTo(20)
        }
        
        sideviewBtn.snp.makeConstraints { make in
            make.left.equalTo(crossBtn)
            make.centerY.equalTo(viewLabel)
            make.height.equalTo(20)
            make.bottom.equalTo(-15)
        }
        
        midView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        fbxView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.right.equalTo(0)
            make.height.equalTo(APP.WIDTH)
        }
        
    }
    
    @objc func modelBtnClick() {
        
    }
    
    @objc func crossBtnClick() {
        
    }
    
    @objc func fiftyBtnClick() {
        
    }
    
    @objc func hundredBtnClick() {
        
    }
    
    @objc func hundredfiftyBtnClick() {
        
    }
    
    @objc func frontviewBtnClick() {
        
    }
    
    @objc func sideviewBtnClick() {
        
    }
}

extension GYETStereoscopicMorphologyViewController {
    func request() {
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"obj_type":0] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getqsjhGraph3D, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            
        }
    }
}
