//
//  WechatObject.h
//  jinhe
//
//  Created by 可能科技 on 2018/7/23.
//  Copyright © 2018年 rockontrol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WxPay.h"

typedef void(^WechatObjectResult)(BOOL success, NSString *errorMsg);

@interface WechatObject : NSObject

@property (nonatomic, copy) WechatObjectResult wechatObjectResult;
@property (nonatomic, copy) WechatObjectResult payResult;

+ (instancetype)getInstancetype;

- (void)initRegisterApp:(NSString *)appid;

- (void)handleOpenURL:(NSURL *)url;

- (void)startPay:(WxPay *)wxPay
       payResult:(WechatObjectResult)payResult;

@end

















