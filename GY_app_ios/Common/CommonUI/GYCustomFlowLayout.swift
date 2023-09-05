//
//  GYCustomFlowLayout.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/4.
//

import UIKit

class GYCustomFlowLayout: UICollectionViewFlowLayout {
    
    
    /// 这个布局包含两个样式,一个是标准的collectionview的样式,另外一个样式类似瀑布流,会根据标签的长度自适应
    var isWaterfallsFlow: Bool = true
    
    var maxSpacing: CGFloat = 8
    // 准备布局信息
    override func prepare() {
        
    }
    
    
    ///返回collectionView的可见范围所有item对应的UICollectionViewLayoutAttributes对象的数组。collectionView的每个item都对应一个专门的UICollectionViewLayoutAttributes类型的对象来表示该item的一些属性，他不是一个视图，但包含了视图所有的属性，比如，frame transform 等
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributesArray = super.layoutAttributesForElements(in: rect)
        
        if !isWaterfallsFlow {
            return attributesArray
        }
        
        if attributesArray != nil {
            // 自适应大小标签
            

            // 只有一个cell
            for (index,attribute) in attributesArray!.enumerated() {
                
                if index > 0{
                    let current = attribute
                    let preAttributes = attributesArray![index - 1]
                    
                    if current.indexPath.section == preAttributes.indexPath.section && current.frame.origin.x != 0 {
                        
                        let maxSpacing: CGFloat = self.minimumInteritemSpacing
                        let preMaxX = preAttributes.frame.maxX
                        
                        // 判断是否超出最大宽度
                        if preMaxX + maxSpacing + current.frame.size.width <= self.collectionViewContentSize.width - sectionInset.right {
                            var frame = current.frame
                            frame.origin.x = preMaxX + maxSpacing
                            current.frame = frame
                        }else{
                            var frame = current.frame
                            frame.origin.x = sectionInset.left
                            frame.origin.y = preAttributes.frame.maxY + minimumLineSpacing
                            current.frame = frame
                        }
                    }
                }else if index == 0{
                    let current = attributesArray![0]
                    var frame = current.frame
                    frame.origin.x = sectionInset.left
                    current.frame = frame
                }
            }
            
//            self.collectionView!.snp.updateConstraints { (make) in
////                make.height.equalTo(1000)
//            }
            
            return attributesArray
            
        }
        
        return nil
    }
    
    
    /// 当前layout的布局发生变动时，是否重写加载该layout。默认返回的是NO
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
    }
}
