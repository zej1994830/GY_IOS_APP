//
//  ViewController.m
//  GCDWebservice_test
//
//  Created by ScarlettZhao on 2021/3/9.
//  Copyright © 2021 ScarlettZhao. All rights reserved.
//

#import "ViewController.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerURLEncodedFormRequest.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "TESTViewController.h"

@interface ViewController ()<GCDWebServerDelegate> {
  GCDWebServer* _localServer;
}

@property (nonatomic, strong) NSString *json;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self startLocalServer];
    
    
}

- (void)startLocalServer{
    _localServer = [[GCDWebServer alloc] init];
    _localServer.delegate = self;
    //设置监听
    
    
    __weak __typeof__(self) weakSelf = self;

    
// --------------get请求 用query------------------------------------------------------------------------
    [_localServer addHandlerForMethod:@"GET"
                            path:@"/"                        //接口名
                         requestClass:[GCDWebServerURLEncodedFormRequest class]
                         processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
        
                             GCDWebServerDataResponse *response;


        NSLog(@"客户端发来的请求参数 =====%@",request.query);
        //给label赋值
        weakSelf.json = [weakSelf dicToJsonStr:request.query];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


        });

                            //返回给客户端的值
                            response = [GCDWebServerDataResponse responseWithJSONObject:@{@"status":@"success"}];
                             //响应头设置，跨域请求需要设置，只允许设置的域名或者ip才能跨域访问本接口）
                             [response setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
                             
                             [response setValue:@"Content-Type" forAdditionalHeader:@"Access-Control-Allow-Headers"];
                             
                             return response;
                         }];
    
    
//----------------post------------------------------------------------------
    [_localServer addDefaultHandlerForMethod:@"POST"
                         requestClass:[GCDWebServerURLEncodedFormRequest class]
                         processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
        
                             GCDWebServerDataResponse *response;
                                    
        
                             //获取请求中的参数（body）
                             NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:[(GCDWebServerURLEncodedFormRequest*)request data] options:NSJSONReadingAllowFragments error:nil];
                             NSLog(@"请求参数 =====%@",json);

                            //json 转 string
                            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                                               options:NSJSONWritingPrettyPrinted
                                                                                 error:nil];
                            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];


        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    


        });
        
        

        
                            response = [GCDWebServerDataResponse responseWithJSONObject:@{@"status":@"success"}];
                             //响应头设置，跨域请求需要设置，只允许设置的域名或者ip才能跨域访问本接口）
                             [response setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
                             
                             [response setValue:@"Content-Type" forAdditionalHeader:@"Access-Control-Allow-Headers"];
                             
                             return response;
                         }];

    
    // 设置 index.html 的路径
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];

    // 添加处理 index.html 请求的处理程序
    [_localServer addGETHandlerForBasePath:@"/" directoryPath:[indexPath stringByDeletingLastPathComponent] indexFilename:[indexPath lastPathComponent] cacheAge:3600 allowRangeRequests:YES];

    
    //设置监听端口
    [_localServer startWithPort:8080 bonjourName:nil];
    NSLog(@"Visit %@ in your web browser", _localServer.serverURL);
    
    
    
    
}

- (void)webServerDidStart:(GCDWebServer *)server{
    NSLog(@"本地服务启动成功");
    NSLog(@"%@",[self deviceIPAdress]);
}






-(NSString *)dicToJsonStr:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//获取ip地址
- (NSString *)deviceIPAdress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
      // Loop through linked list of interfaces
      temp_addr = interfaces;
      while(temp_addr != NULL) {
        if(temp_addr->ifa_addr->sa_family == AF_INET) {
          // Check if interface is en0 which is the wifi connection on the iPhone
          if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
            // Get NSString from C String
            address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
          }
        }
        temp_addr = temp_addr->ifa_next;
      }
    }
     
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


@end
