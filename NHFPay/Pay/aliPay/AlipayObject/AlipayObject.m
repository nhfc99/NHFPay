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
            
            //回调结果
            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
            NSString *result = resultDic[@"result"];
            
            //支付结果信息
            NSDictionary *results = @{@"9000":@"支付成功", @"8000":@"正在处理中，请稍后查看",  @"4000":@"订单支付失败", @"5000":@"重复请求", @"6001":@"用户中途取消", @"6002":@"网络连接出错", @"6004":@"支付结果未知"};
            NSString *keyString = [NSString stringWithFormat:@"%ld", resultStatus];
            NSString *msg = results[keyString];
            if (msg == nil) {
                msg = @"支付失败";
            }
            
            if (self->_payResult) {
                if (resultStatus == 9000) {
                    self->_payResult(true, msg, msg);
                } else {
                    self->_payResult(false, msg, msg);
                }
            }
            
            //此处为用户展示的
            if (self->_alipayObjectResult) {
                if (resultStatus == 9000) {
                    self->_alipayObjectResult(true, resultStatus, msg, result);
                } else {
                    self->_alipayObjectResult(false, resultStatus, msg, result);
                }
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

- (void)toPay:(NSString *)signString
   payOrderCB:(ResultDic)payOrderCB {
    _payOrderCB = payOrderCB;
    if (signString != nil) {
        [[AlipaySDK defaultService] payOrder:signString fromScheme:_appScheme callback:^(NSDictionary *resultDic) {}];
    }
}

@end
