//
//  UIViewController+ZEJPresent.m
//  DingDingPay
//
//  Created by zhaoenjia on 2019/10/17.
//  Copyright © 2019 WY. All rights reserved.
//

#import "UIViewController+ZEJPresent.h"
#import <objc/runtime.h>

@implementation UIViewController (ZEJPresent)
- (void)zej_presentViewController:(UIViewController *)vcToPresent vcTransitionDelegate: (id<UIViewControllerTransitioningDelegate>)vcTransitionDelegate completion:(void (^ __nullable)(void))completion {
    objc_setAssociatedObject(self, "zej_vcTransitionDelegate", vcTransitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    vcToPresent.modalPresentationStyle = UIModalPresentationCustom;
    vcToPresent.transitioningDelegate = vcTransitionDelegate;
    [self presentViewController:vcToPresent animated:YES completion:completion];
}
@end
