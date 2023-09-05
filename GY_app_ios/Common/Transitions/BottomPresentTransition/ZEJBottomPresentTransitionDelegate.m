//
//  ZEJBottomPresentTransitionDelegate.m
//  ZEJNOW
//
//  Created by zhaoenjia on 2019/4/21.
//  Copyright © 2019年 zhaoenjia. All rights reserved.
//

#import "ZEJBottomPresentTransitionDelegate.h"
#import "ZEJBottomPresentPresentationController.h"

@implementation ZEJBottomPresentTransitionDelegate

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    return [[ZEJBottomPresentPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end
