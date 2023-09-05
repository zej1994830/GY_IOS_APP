//
//  ZEJRollDownViewController.m
//  rlrw-user
//
//  Created by zhaoenjia on 2019/5/5.
//  Copyright © 2019年 rlrw. All rights reserved.
//

#import "ZEJRollDownViewController.h"

@interface ZEJRollDownViewController ()

@end

@implementation ZEJRollDownViewController



-(CGRect)controllerFrame {
    if (CGRectEqualToRect(_controllerFrame, CGRectZero)) {
        return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
    return _controllerFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
