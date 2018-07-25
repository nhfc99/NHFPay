//
//  ApplePayObject.m
//  jinhe
//
//  Created by 可能科技 on 2018/7/22.
//  Copyright © 2018年 rockontrol. All rights reserved.
//

#import "ApplePayObject.h"
#import "UPAPayPlugin.h"

@interface ApplePayObject () <UPAPayPluginDelegate>

@property (nonatomic, copy) NSString *payModel;
@property (nonatomic, copy) NSString *mechantID;

@end

@implementation ApplePayObject

static ApplePayObject *object = nil;
+ (instancetype)getInstancetype {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        object = [[ApplePayObject alloc] init];
    });
    return object;
}

- (void)initByPayModel:(NSString *)payModel
             mechantID:(NSString *)mechantID {
    if (payModel == nil) {
        _payModel = @"";
    } else {
        _payModel = payModel;
    }
    
    if (mechantID == nil) {
        _mechantID = @"";
    } else {
        _mechantID = mechantID;
    }
}

- (void)startPay:(NSString *)sign
              vc:(UIViewController *)viewController {
    [UPAPayPlugin startPay:sign mode:_payModel viewController:viewController delegate:self andAPMechantID:_mechantID];
}

- (void)UPAPayPluginResult:(UPPayResult *)payResult {
    UPPaymentResultStatus paymentResultStatus = payResult.paymentResultStatus;
    switch (paymentResultStatus) {
        case UPPaymentResultStatusSuccess: {
            if (_applePayObjectResultSuccess != nil) {
                _applePayObjectResultSuccess(payResult.errorDescription, payResult.otherInfo);
            }
        }
            break;
            
        case UPPaymentResultStatusFailure: {
            if (_applePayObjectResultFail != nil) {
                _applePayObjectResultFail(payResult.errorDescription, payResult.otherInfo);
            }
        }
            break;
            
        case UPPaymentResultStatusCancel: {
            if (_applePayObjectResultCancel != nil) {
                _applePayObjectResultCancel(payResult.errorDescription, payResult.otherInfo);
            }
        }
            break;
            
        case UPPaymentResultStatusUnknownCancel: {
            if (_applePayObjectResultCancel != nil) {
                _applePayObjectResultCancel(payResult.errorDescription, payResult.otherInfo);
            }
        }
            break;
            
        default:
            break;
    }
}

@end















