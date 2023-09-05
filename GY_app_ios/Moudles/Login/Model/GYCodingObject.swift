//
//  GYCodingObject.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/21.
//

import UIKit

class GYCodingObject: NSObject,NSCoding {
    
    override init(){
        super.init()
    }
    
    func encode(with coder: NSCoder) {

        
    }
    
    required init?(coder: NSCoder) {
        super.init()
        
    }
    
    // 缓存
    func setCacheData(_ cacheKey: String = ""){
        
        var tempCacheKey = cacheKey
        if tempCacheKey.isEmpty {
            tempCacheKey = NSStringFromClass(self.classForCoder)
        }
        
        CommonCache.share.userDataCache.setObject(self, forKey: tempCacheKey)
    }
}
