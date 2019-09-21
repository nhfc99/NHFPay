//
//  WechatObject.m
//  jinhe
//
//  Created by 可能科技 on 2018/7/23.
//  Copyright © 2018年 rockontrol. All rights reserved.
//

#import "WechatObject.h"
@interface WechatObject () <WXApiDelegate>

@end

@implementation WechatObject

static WechatObject *object = nil;
+ (instancetype)getInstancetype
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        object = [[WechatObject alloc] init];
    });
    return object;
}

- (void)initRegisterApp:(NSString *)appid {
    [WXApi registerApp:appid];
}

- (void)handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
}

- (void)startPay:(WxPay *)wxPay
         payResult:(WechatObjectResult)payResult {
    _payResult = payResult;
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = wxPay.partnerid;
    request.prepayId= wxPay.prepayid;
    request.package = wxPay.packages;
    request.nonceStr= wxPay.noncestr;
    request.timeStamp= [wxPay.timestamp intValue];
    request.sign= wxPay.sign;
    [WXApi sendReq:request];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        BOOL result = false;
        NSString *errorMsg = @"";
        switch(resp.errCode){
            case WXSuccess:{
                result = true;
                errorMsg = @"";
            }
                break;
                
            case WXErrCodeCommon:{
                result = false;
                errorMsg = @"支付失败";
            }
                break;
                
            case WXErrCodeUserCancel:{
                result = false;
                errorMsg = @"取消支付";
            }
                break;
                
            case WXErrCodeSentFail:{
                result = false;
                errorMsg = @"支付发送失败";
            }
                break;
                
            case WXErrCodeAuthDeny:{
                result = false;
                errorMsg = @"授权失败";
            }
                break;
                
            case WXErrCodeUnsupport:{
                result = false;
                errorMsg = @"微信不支持";
            }
                break;
                
            default:{
                
            }
                break;
        }
        
        if (_wechatObjectResult != nil) {
            _wechatObjectResult(result, errorMsg);
        }
        
        if (_payResult != nil) {
            _payResult(result, errorMsg);
        }
    }
}

@end

















