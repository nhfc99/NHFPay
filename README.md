# NHFPay
<h2>介绍</h2>
<p>NHFPay对常用支付方式（银联、微信、支付宝、Apple Pay）的一个封装</p>
<h2>安装</h2>
<ul>
<li>pod 'NHFPay'</li>
<li>手动下载然后将文件夹拖至工程中即可</li>
</ul>

<h2>使用方法</h2>

1.先进行初始化操作，位置放于自己经常放项目启动初始化的地方，比如APPDelegate.m中

    //初始化支付
    [[AlipayObject getInstancetype] initByAppScheme:kAliAppScheme];
    
    //银联初始化
    [[UnionPayPaymentObject getInstancetype] initFromScheme:FromScheme payModel:PayModel];
    
    //Apple Pay初始化
    [[ApplePayObject getInstancetype] initByPayModel:PayModel mechantID:MechantID];
    
    //微信初始化
    [[WechatObject getInstancetype] initRegisterApp:WXAPPID];

2.回调处理

     - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{}
     
     - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{}
     
     - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{}

在AppDelegate.m中添加以上三个回调，将一下代码放于其中：

    [[UnionPayPaymentObject getInstancetype] handlePaymentResult:url];
    
    [[AlipayObject getInstancetype] testUrlHostBy:url];
    
    [[WechatObject getInstancetype] handleOpenURL:url];

3.使用方法举一个例子

     //Apple Pay message为后台返给端上的
     - (void)applePayBy:(NSString *)message {
         [[ApplePayObject getInstancetype] startPay:[message stringTrim] vc:strongSelf];
         
         UIViewController *viewController = GetCurrentVC;
         //成功
         [ApplePayObject getInstancetype].applePayObjectResultSuccess = ^(NSString *errorDescription, NSString *otherInfo) {

          };
    
          //失败
         [ApplePayObject getInstancetype].applePayObjectResultFail = ^(NSString *errorDescription, NSString *otherInfo) {

         };
    
         //取消
         [ApplePayObject getInstancetype].applePayObjectResultCancel = ^(NSString *errorDescription, NSString *otherInfo) {

         };
     }
	其他方式类似，请查看源码









