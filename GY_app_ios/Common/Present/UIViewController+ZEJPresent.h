//
//  UIViewController+ZEJPresent.h
//  DingDingPay
//
//  Created by zhaoenjia on 2019/10/17.
//  Copyright © 2019 WY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZEJPresent)
- (void)zej_presentViewController:(UIViewController *)vcToPresent vcTransitionDelegate: (id<UIViewControllerTransitioningDelegate>)vcTransitionDelegate completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
