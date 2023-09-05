//
//  ZEJRollDownTransitionDelegate.m
//  rlrw-user
//
//  Created by zhaoenjia on 2019/5/5.
//  Copyright © 2019年 rlrw. All rights reserved.
//

#import "ZEJRollDownTransitionDelegate.h"
#import "ZEJRollDownPresentationController.h"
#import "ZEJRollDownAnimatedTransitioning.h"

#import "ZEJRollDownViewController.h"

@implementation ZEJRollDownTransitionDelegate


-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    NSLog(@"3-presented:%@",NSStringFromClass(presented.class));
    ZEJRollDownPresentationController * presentationController = [[ZEJRollDownPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    
    if([presented isKindOfClass:ZEJRollDownViewController.class]){
        presentationController.controllerFrame = [(ZEJRollDownViewController *)presented controllerFrame];
        presentationController.maskFull = [(ZEJRollDownViewController *)presented maskFull];
    }else {
        presentationController.controllerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    }
    
    
    
    return  presentationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    NSLog(@"2-dismissed:%@",NSStringFromClass(dismissed.class));
    
    ZEJRollDownAnimatedTransitioning * animatedTransitioning = [ZEJRollDownAnimatedTransitioning new];
    if([dismissed isKindOfClass:ZEJRollDownViewController.class]){
        animatedTransitioning.controllerFrame = [(ZEJRollDownViewController *)dismissed controllerFrame];
    }else {
        animatedTransitioning.controllerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    
    return  animatedTransitioning;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    NSLog(@"1-presented:%@",NSStringFromClass(presented.class));
    ZEJRollDownAnimatedTransitioning * animatedTransitioning =  [ZEJRollDownAnimatedTransitioning new];
    
    if([presented isKindOfClass:ZEJRollDownViewController.class]){
        animatedTransitioning.controllerFrame = [(ZEJRollDownViewController *)presented controllerFrame];
    }else {
        animatedTransitioning.controllerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    
    return  animatedTransitioning;
}

@end
