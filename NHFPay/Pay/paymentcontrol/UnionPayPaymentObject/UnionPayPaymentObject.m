//
//  UnionPayPaymentObject.m
//  jinhe
//
//  Created by 可能科技 on 2018/7/21.
//  Copyright © 2018年 rockontrol. All rights reserved.
//

#import "UnionPayPaymentObject.h"
#import "UPPaymentControl.h"

@interface UnionPayPaymentObject ()

@property (nonatomic, copy) NSString *fromScheme;
@property (nonatomic, copy) NSString *payModel;

@property (nonatomic, weak) id<UnionPayPaymentObjectDelegate> delegate;

@end

@implementation UnionPayPaymentObject

static UnionPayPaymentObject *object = nil;
+ (instancetype)getInstancetype {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        object = [[UnionPayPaymentObject alloc] init];
    });
    return object;
}

- (void)initFromScheme:(NSString *)fromScheme
              payModel:(NSString *)payModel {
    if (fromScheme == nil) {
        _fromScheme = @"";
    } else {
        _fromScheme = fromScheme;
    }
    
    if (payModel == nil) {
        _payModel = @"";
    } else {
        _payModel = payModel;
    }
}

- (void)handlePaymentResult:(NSURL*)url {
    __weak typeof(self) weakself = self;
    [[UPPaymentControl defaultControl]
     handlePaymentResult:url
     completeBlock:^(NSString *code, NSDictionary *data) {
         //结果code为成功时，先校验签名，校验成功后做后续处理
         if([code isEqualToString:@"success"]) {
             //判断签名数据是否存在
             if(data == nil){
                 //如果没有签名数据，建议商户app后台查询交易结果
                 return;
             }
             //数据从NSDictionary转换为NSString
             NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                options:0
                                                                  error:nil];
             NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
             if (self.delegate != nil) {
                 [self.delegate unionPayPaymentResultCheckBy:sign request:^(BOOL result, NSString *errorMsg) {
                     if (result) {
                         if (weakself.unionPayPaymentObjectResultSuccess != nil) {
                             weakself.unionPayPaymentObjectResultSuccess(code, data, nil);
                         }
                     } else {
                         if (weakself.unionPayPaymentObjectResultFail != nil) {
                             weakself.unionPayPaymentObjectResultFail(code, data, errorMsg);
                         }
                     }
                 }];
             } else {
                 if (weakself.unionPayPaymentObjectResultSuccess != nil) {
                     weakself.unionPayPaymentObjectResultSuccess(code, data, nil);
                 }
             }
         }
         else if([code isEqualToString:@"fail"]) {
             if (weakself.unionPayPaymentObjectResultFail != nil) {
                 weakself.unionPayPaymentObjectResultFail(code, data, nil);
             }
         }
         else if([code isEqualToString:@"cancel"]) {
             if (weakself.unionPayPaymentObjectResultCancel != nil) {
                 weakself.unionPayPaymentObjectResultCancel(code, data, nil);
             }
         }
     }];
}

- (void)startPay:(NSString *)data
              vc:(UIViewController *)vc
   checkDelegate:(id<UnionPayPaymentObjectDelegate>)checkDelegate {
    _delegate = checkDelegate;
    [[UPPaymentControl defaultControl] startPay:data fromScheme:self.fromScheme mode:self.payModel viewController:vc];
}

@end















