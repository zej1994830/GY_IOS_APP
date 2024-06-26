//
//  TESTViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/1/2.
//

import UIKit
import WebKit
import SceneKit
//import SceneKit.ModelIO
import ModelIO

class TESTViewController: GYViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: APP.WIDTH, height: APP.WIDTH))
//        if let url = URL(string: "http://192.168.102.2:8080/index.html") {
//                    // 创建 URLRequest 对象
//                    let request = URLRequest(url: url)
//
//                    // 加载网页
//                    webView.load(request)
//                }
//        self.view.addSubview(webView)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            webView.scrollView.setContentOffset(CGPoint(x: 200, y: 0), animated: true)
//        }
//        let qrImage = createQRCodeImage(content: "http://36.129.131.242:1880/invoice/invoice.html")
//            let imageView = UIImageView(image: qrImage)
//        self.view.addSubview(imageView)
//        imageView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(APP.WIDTH)
//            make.height.equalTo(APP.WIDTH)
//        }
        
        let view = SBRadarCharts(frame: CGRect(x: 0, y: 300, width: APP.WIDTH, height: APP.WIDTH))
        view.backgroundColor = .white
        self.view.addSubview(view)
    }
    
    
}


func createQRCodeImage(content: String) -> UIImage? {
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
        return nil
    }
    let data = content.data(using: .utf8)
    filter.setValue(data, forKey: "inputMessage")
    guard let ciImage = filter.outputImage else {
        return nil
    }
    return UIImage(ciImage: ciImage)
}

func generateQRCode(text: String) -> String? {
    guard let data = text.data(using: .utf8) else {
        return nil
    }
    
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
        return nil
    }
    
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("H", forKey: "inputCorrectionLevel")
    
    guard let qrCodeImage = filter.outputImage else {
        return nil
    }
    
    let context = CIContext()
    guard let cgImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) else {
        return nil
    }
    
    let uiImage = UIImage(cgImage: cgImage)
    guard let imageData = uiImage.pngData() else {
        return nil
    }
    
    let base64String = imageData.base64EncodedString()
    return base64String
}
