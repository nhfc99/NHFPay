//
//  UnionPayPaymentObject.h
//  jinhe
//
//  Created by 可能科技 on 2018/7/21.
//  Copyright © 2018年 rockontrol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UnionPayPaymentObjectDelegate

@optional
- (void)unionPayPaymentResultCheckBy:(NSString *)sign
                             request:(void(^)(BOOL result, NSString *errorMsg))request;

@end

typedef void(^UnionPayPaymentObjectResult)(NSString *code, NSDictionary *data, NSString *errorMsg);

@interface UnionPayPaymentObject : NSObject

@property (nonatomic, copy) UnionPayPaymentObjectResult unionPayPaymentObjectResultSuccess;

@property (nonatomic, copy) UnionPayPaymentObjectResult unionPayPaymentObjectResultFail;

@property (nonatomic, copy) UnionPayPaymentObjectResult unionPayPaymentObjectResultCancel;

+ (instancetype)getInstancetype;

- (void)initFromScheme:(NSString *)fromScheme
              payModel:(NSString *)payModel;

- (void)handlePaymentResult:(NSURL*)url;

- (void)startPay:(NSString *)data
              vc:(UIViewController *)vc
   checkDelegate:(id<UnionPayPaymentObjectDelegate>)checkDelegate;

@end














