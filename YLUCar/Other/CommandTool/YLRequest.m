//
//  YLRequest.m
//  YLGoodCard
//
//  Created by lm on 2018/11/13.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLRequest.h"

@implementation YLRequest

+ (void)reachabilityStatus {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"自带网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [manager startMonitoring];
}


+ (void)GET:(NSString *)URL parameters:(id)parameters success:(DMHTTPRequestSuccess)success failed:(DMHTTPRequestFailed)failed {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *secutiPolicy = [AFSecurityPolicy defaultPolicy];
    secutiPolicy.allowInvalidCertificates = YES;
    secutiPolicy.validatesDomainName = NO;
    manager.securityPolicy = secutiPolicy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (success) {
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(error);
        }
    }];
}

@end
