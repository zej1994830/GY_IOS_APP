//
//  SBRadarCharts.h
//  Tools
//
//  Created by 赵恩家 on 2024/5/9.
//  Copyright © 2024 zej. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GY_app_ios-Swift.h"
NS_ASSUME_NONNULL_BEGIN


@interface SBRadarCharts : UIView

/** 中心点图片 */
@property (nonatomic,strong) UIImage *img;
/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *values;
/** 数据元素的名称 */
@property (nonatomic,strong) NSMutableArray *titles;
/** 圆半径 */
@property (nonatomic,assign) CGFloat radius;
/** 中心点图片半径边框的宽度 */
@property (nonatomic,assign) CGFloat imgBoderWidth;
/** 中心点图片的宽度 */
@property (nonatomic,assign) CGFloat imgWidth;
/** 小白点 */
@property (nonatomic,assign) CGFloat dioWdith;
/** 小白点边框的宽度  */
@property (nonatomic,assign) CGFloat dioBoderWdith;

/** label的宽度 */
@property (nonatomic,assign) CGFloat labelWidth;
/** label的宽度 */
@property (nonatomic,assign) CGFloat labelHeight;

/** label2的宽度 */
@property (nonatomic,assign) CGFloat labelWidth2;
/** label2的宽度 */
@property (nonatomic,assign) CGFloat labelHeight2;

/** 图层的颜色 */
@property (nonatomic,strong) UIColor *themColor;
/** 圆环的颜色 */
@property (nonatomic,strong) UIColor *cirlColor;
/** 圆环之间的间距 */
@property (nonatomic,assign) CGFloat cirlMargin;

/** 小图层减少大图层值得比例 百分比 proportion*radius*/
@property (nonatomic,assign) CGFloat proportion;

@property (nonatomic,copy) NSDictionary *dataDic;


typedef void (^ButtonClickBlock)(NSInteger value);
@property (nonatomic, copy) ButtonClickBlock block;
@property (nonatomic, copy) ButtonClickBlock block2;

-(void) showDirectionalcoordinates: (CGFloat )offsetAngle :(CGFloat )offsetAngle2;
#pragma mark 计算圆圈上点在IOS系统中的坐标
-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius;
@end

NS_ASSUME_NONNULL_END
