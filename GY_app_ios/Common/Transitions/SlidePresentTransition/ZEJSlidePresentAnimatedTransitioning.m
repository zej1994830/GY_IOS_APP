//
//  ZEJSlidePresentAnimatedTransitioning.m
//  ZEJNOW
//
//  Created by zhaoenjia on 2019/4/21.
//  Copyright © 2019年 zhaoenjia. All rights reserved.
//

#import "ZEJSlidePresentAnimatedTransitioning.h"

@implementation ZEJSlidePresentAnimatedTransitioning

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView * containerView = transitionContext.containerView;
    
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * fromView = fromVc.view;
    UIView * toView = toVc.view;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (toVc.isBeingPresented) {
        [containerView addSubview:toView];
//        [containerView bringSubviewToFront:toView];
        CGRect targetFrame = containerView.bounds;
        CGRect initFrame  = targetFrame;
        initFrame.origin.x += initFrame.size.width;
        toView.frame = initFrame;
        [UIView animateWithDuration:duration animations:^{
            toView.frame = targetFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
    if (fromVc.isBeingDismissed) {
        CGRect targetFrame = containerView.bounds;
        targetFrame.origin.x += targetFrame.size.width;
        
        [UIView animateWithDuration:duration animations:^{
            fromView.frame = targetFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
    
}

@end
