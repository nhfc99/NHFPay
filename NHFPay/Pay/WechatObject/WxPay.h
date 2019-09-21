//
//  WxPay.h
//  WorryFreeDecoration
//
//  Created by 牛宏飞 on 16/5/31.
//  Copyright © 2016年 牛宏飞. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface WxPay : NSObject

@property (nonatomic, copy) NSString * appid;
@property (nonatomic, copy) NSString * noncestr;
@property (nonatomic, copy) NSString * packages;
@property (nonatomic, copy) NSString * partnerid;
@property (nonatomic, copy) NSString * prepayid;
@property (nonatomic, copy) NSString * timestamp;
@property (nonatomic, copy) NSString * sign;
@property (nonatomic, copy) NSString * retcode;
@property (nonatomic, copy) NSString * retmsg;

@end
