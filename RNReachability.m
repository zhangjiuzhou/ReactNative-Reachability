//
//  RNReachability.m
//  RNReachability
//
//  Created by 张九州 on 17/3/7.
//

#import "RNReachability.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface RNReachability ()

@property (nonatomic, assign) BOOL isObserving;

@end

@implementation RNReachability

RCT_EXPORT_MODULE()

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onStatusChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[
             @"onStatusChange"
             ];
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (void)startObserving {
    self.isObserving = YES;
}

- (void)stopObserving {
    self.isObserving = NO;
}

- (void)_onStatusChange {
    if (self.isObserving) {
        [self sendEventWithName:@"onStatusChange" body:[self _getStatus]];
    }
}

- (NSString *)_getStatus {
    return [self _status2String:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];
}

- (NSString *)_status2String:(AFNetworkReachabilityStatus)status {
    static NSDictionary *map;
    if (!map) {
        map = @{
                @(AFNetworkReachabilityStatusUnknown):@"unknown",
                @(AFNetworkReachabilityStatusNotReachable):@"notReachable",
                @(AFNetworkReachabilityStatusReachableViaWWAN):@"WWAN",
                @(AFNetworkReachabilityStatusReachableViaWiFi):@"wifi"
                };
    }
    return map[@(status)];
}

@end
