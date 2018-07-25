//
//  AlipayObject.h
//  jinhe
//
//  Created by 可能科技 on 2018/7/21.
//  Copyright © 2018年 rockontrol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultDic)(NSDictionary *resultDic);
typedef void(^PayResult)(BOOL success, NSString *result, NSString *errorMsg);

@interface AlipayObject : NSObject

//跳转支付宝钱包进行支付，处理支付结果
@property (nonatomic, copy) ResultDic payOrderCB;
//跳转支付宝钱包进行支付，处理支付结果
@property (nonatomic, copy) ResultDic processOrdPR;
// 授权跳转支付宝钱包进行支付，处理支付结果
@property (nonatomic, copy) ResultDic processAuthCB;
//支付回调之后的结果
@property (nonatomic, copy) PayResult payResult;

+ (instancetype)getInstancetype;


/**
 清理数据
 */
- (void)clean;

/**
 初始化操作

 @param appScheme 
 */
- (void)initByAppScheme:(NSString *)appScheme;


/**
 测试是否是aliPay

 @param url
 @return 
 */
- (BOOL)testUrlHostBy:(NSURL *)url;


/**
 发起支付

 @param signString
 @param payOrderCB
 */
- (void)toPay:(NSString *)signString
   payOrderCB:(ResultDic)payOrderCB;

@end











