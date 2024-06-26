//
//  CommonCache.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/18.
//

import UIKit
import PINCache

class CommonCache: NSObject {
    
    static let share = CommonCache()
    
    let userDataCache: PINCache = {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let cache = PINCache.shared()
        let cache = PINCache.init(name: "UserData", rootPath: path)
        return cache
    }()
    
    var apiDataCache: PINCache {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        //        let cache = PINCache.shared()
                let cache = PINCache.init(name: "apiData", rootPath: path)
        return cache
    }
    
    var settingDataCache: PINCache {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //        let cache = PINCache.shared()
                let cache = PINCache.init(name: "setting", rootPath: path)
        return cache
    }
    
    class func getCacheData<T>(cache: PINCache = CommonCache.share.userDataCache, _ cacheKey: String = "") -> T? where T : GYCodingObject {
        
        var tempCacheKey = cacheKey
        if tempCacheKey.isEmpty {
            tempCacheKey = NSStringFromClass(self.classForCoder())
        }
        
        guard let data = cache.object(forKey: tempCacheKey) as? T else{
            return nil
        }
        
        return data
    }
    
    /// 缓存数据
    class func cacheData(_ data: NSCoding, key: String) {
        CommonCache.share.userDataCache.setObject(data, forKey: key)
        CommonCache.share.userDataCache.memoryCache.removeAllObjectsOnEnteringBackground = false
    }
}
