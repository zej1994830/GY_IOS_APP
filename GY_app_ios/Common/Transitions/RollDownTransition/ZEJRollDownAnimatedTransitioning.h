//
//  ZEJRollDownAnimatedTransitioning.h
//  rlrw-user
//
//  Created by zhaoenjia on 2019/5/5.
//  Copyright © 2019年 rlrw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZEJRollDownAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
@property(nonatomic,assign)CGRect controllerFrame;

@end

NS_ASSUME_NONNULL_END
