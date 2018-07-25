//
//  ApplePayObject.h
//  jinhe
//
//  Created by 可能科技 on 2018/7/22.
//  Copyright © 2018年 rockontrol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ApplePayObjectResult)(NSString* errorDescription, NSString* otherInfo);

@interface ApplePayObject : NSObject

@property (nonatomic, copy) ApplePayObjectResult applePayObjectResultCancel;
@property (nonatomic, copy) ApplePayObjectResult applePayObjectResultSuccess;
@property (nonatomic, copy) ApplePayObjectResult applePayObjectResultFail;

+ (instancetype)getInstancetype;

/**
 初始化

 @param payModel -
 @param mechantID -
 */
- (void)initByPayModel:(NSString *)payModel
             mechantID:(NSString *)mechantID;

/**
 发起支付

 @param sign -
 @param viewController -
 */
- (void)startPay:(NSString *)sign
              vc:(UIViewController *)viewController;

@end
















