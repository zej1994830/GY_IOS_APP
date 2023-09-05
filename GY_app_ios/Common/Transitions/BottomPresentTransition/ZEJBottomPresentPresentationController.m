//
//  ZEJBottomPresentPresentationController.m
//  ZEJNOW
//
//  Created by zhaoenjia on 2019/4/21.
//  Copyright © 2019年 zhaoenjia. All rights reserved.
//

#import "ZEJBottomPresentPresentationController.h"
#import "ZEJBottomPresentViewController.h"

@interface ZEJBottomPresentPresentationController()
@property(nonatomic,assign)CGFloat controllerHeight;
@property(nonatomic,weak)UIView * maskView;
@end

@implementation ZEJBottomPresentPresentationController


-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    
    if([presentedViewController respondsToSelector:@selector(controllerHeight)]){

        if([presentedViewController isKindOfClass:ZEJBottomPresentViewController.class]){
            _controllerHeight = [(ZEJBottomPresentViewController *)presentedViewController controllerHeight];
        }else {
            _controllerHeight = [UIScreen mainScreen].bounds.size.height;
        }
        
    }
    return [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
}


-(UIView *)maskView {
    if(!_maskView){
        UIView * maskView = [UIView new];
        maskView.frame = self.containerView.bounds;
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskClick)];
        [maskView addGestureRecognizer:tapGesture];
        [self.containerView addSubview:maskView];
        _maskView = maskView;
    }
    return _maskView;
}

-(void)presentationTransitionWillBegin {
    self.maskView.alpha = 0;
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
        [self.maskView removeFromSuperview];
    }
}

-(CGRect)frameOfPresentedViewInContainerView {
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    
    return  CGRectMake(0, sh - _controllerHeight, sw, _controllerHeight);
}

-(void)maskClick {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
