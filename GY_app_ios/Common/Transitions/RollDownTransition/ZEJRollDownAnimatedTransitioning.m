//
//  ZEJRollDownAnimatedTransitioning.m
//  rlrw-user
//
//  Created by zhaoenjia on 2019/5/5.
//  Copyright © 2019年 rlrw. All rights reserved.
//

#import "ZEJRollDownAnimatedTransitioning.h"

@interface ZEJRollDownAnimatedTransitioning ()

@end


@implementation ZEJRollDownAnimatedTransitioning

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
        
        CGRect targetFrame = _controllerFrame;
        CGRect initFrame  = targetFrame;
        initFrame.size.height = 0;
        
        toView.layer.anchorPoint = CGPointMake(0.5, 0);
        toView.frame = initFrame;
        [UIView animateWithDuration:duration animations:^{
            toView.frame = targetFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
    if (fromVc.isBeingDismissed) {

        
        CGRect initFrame  = _controllerFrame;
    
        CGRect targetFrame = initFrame;
        targetFrame.size.height = 0;
        
        
        
        fromView.layer.anchorPoint = CGPointMake(0.5, 0);
        fromView.frame = initFrame;
        [UIView animateWithDuration:duration animations:^{
            fromView.frame = targetFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
    
}

@end
