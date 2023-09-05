//
//  ZEJRollDownPresentationController.m
//  rlrw-user
//
//  Created by zhaoenjia on 2019/5/5.
//  Copyright © 2019年 rlrw. All rights reserved.
//

#import "ZEJRollDownPresentationController.h"

@interface ZEJRollDownPresentationController()
@property(nonatomic,weak)UIView * maskView;
@property(nonatomic,weak)UIView * topMaskView;
@end

@implementation ZEJRollDownPresentationController

-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    return [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
}


-(UIView *)topMaskView {
    
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    //CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    if(!_topMaskView){
        UIView * topMaskView = [UIView new];
        topMaskView.frame = CGRectMake(0, 0, sw, _controllerFrame.origin.y);
        
        
        topMaskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskClick)];
        [topMaskView addGestureRecognizer:tapGesture];
        [self.containerView addSubview:topMaskView];
        _topMaskView = topMaskView;
    }
    return _topMaskView;
}

-(UIView *)maskView {
    
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    
    if(!_maskView){
        UIView * maskView = [UIView new];
        if (!self.maskFull) {
            maskView.frame = CGRectMake(0, _controllerFrame.origin.y, sw, sh-_controllerFrame.origin.y);
        }else {
            maskView.frame = CGRectMake(0, 0, sw, sh);
        }
        
        //NSLog(@"frame:%@",NSStringFromCGRect(maskView.frame));
        
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskClick)];
        [maskView addGestureRecognizer:tapGesture];
        [self.containerView addSubview:maskView];
        _maskView = maskView;
    }
    return _maskView;
}

-(void)presentationTransitionWillBegin {
    if (!self.maskFull) {
        self.topMaskView.alpha = 1;
    }
    
    self.maskView.alpha = 0.3;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1;
    }];
}

-(void)dismissalTransitionWillBegin {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
    }];
}

-(void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        if (!self.maskFull) {
            [self.maskView removeFromSuperview];
        }
        [self.topMaskView removeFromSuperview];
    }
}

//-(CGRect)frameOfPresentedViewInContainerView {
//    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
//    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
//    return  CGRectMake(0, _controllerTop, sw, sh-_controllerTop);
//}

-(void)maskClick {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
