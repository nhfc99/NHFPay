//
//  AlipayObject.m
//  jinhe
//
//  Created by 可能科技 on 2018/7/21.
//  Copyright © 2018年 rockontrol. All rights reserved.
//

#import "AlipayObject.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AlipayObject ()

@property (nonatomic, copy) NSString *appScheme;

@end

@implementation AlipayObject

static AlipayObject *object = nil;
+ (instancetype)getInstancetype
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        object = [[AlipayObject alloc] init];
    });
    return object;
}

- (void)clean {
    _payOrderCB = nil;
    _processOrdPR = nil;
    _processAuthCB = nil;
}

- (void)initByAppScheme:(NSString *)appScheme {
    if (appScheme == nil) {
        _appScheme = @"";
    } else {
        _appScheme = appScheme;
    }
}

- (BOOL)testUrlHostBy:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if (self->_processOrdPR != nil) {
                self->_processOrdPR(resultDic);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            if (self->_processAuthCB != nil) {
                self->_processAuthCB(resultDic);
            }
        }];
        
        return true;
    } else {
        return false;
    }
}

//{
//    memo = "\U7528\U6237\U4e2d\U9014\U53d6\U6d88";
//    result = "";
//    resultStatus = 6001;
//}
- (void)toPay:(NSString *)signString
   payOrderCB:(ResultDic)payOrderCB {
    _payOrderCB = payOrderCB;
    if (signString != nil) {
        [[AlipaySDK defaultService] payOrder:signString fromScheme:_appScheme callback:^(NSDictionary *resultDic) {
            if (self->_payOrderCB != nil) {
                self->_payOrderCB(resultDic);
            }
            
            if (self->_payResult != nil) {
                NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
                NSString *memo = resultDic[@"memo"];
                NSString *result = resultDic[@"result"];
                if (resultStatus == 9000) {
                    self->_payResult(true, result, memo);
                } else {
                    self->_payResult(false, result, memo);
                }
            }
        }];
    }
}

@end














