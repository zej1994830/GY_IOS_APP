//
//  ZEJSlidePresentTransitionDelegate.m
//  ZEJNOW
//
//  Created by zhaoenjia on 2019/4/21.
//  Copyright © 2019年 zhaoenjia. All rights reserved.
//

#import "ZEJSlidePresentTransitionDelegate.h"
#import "ZEJSlidePresentAnimatedTransitioning.h"

@implementation ZEJSlidePresentTransitionDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [ZEJSlidePresentAnimatedTransitioning new];
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
     return [ZEJSlidePresentAnimatedTransitioning new];
}

@end
