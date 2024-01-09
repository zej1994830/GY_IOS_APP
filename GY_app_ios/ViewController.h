//
//  ViewController.h
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController
- (void)startLocalServer;
//获取ip地址
- (NSString *)deviceIPAdress;
@end

NS_ASSUME_NONNULL_END
