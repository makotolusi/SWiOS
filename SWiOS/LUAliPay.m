//
//  LUAliPay.m
//  SWiOS
//
//  Created by 陆思 on 15/10/23.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "LUAliPay.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderModel.h"
#import "ShoppingCartModel.h"
#import "HttpHelper.h"
 static NSString* const RSA_PRIVATE_KEY= @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANbVm5W3Z6VbR2RrB/UIs3m2MudrHrOMUvs8l1P7+nHtK0MlFnAZK+06IG9LU9Nh/M29JC57UWetGYbJNXEwU6qKrKAoTV1xBERB3dy1oIlSOuftMPBQftLIR1iX63R1sbxRU/H6prMbkh+LBjL3IUm2p243YMBXh1DBpxeF1nJdAgMBAAECgYAQKgRJ0IHg5CxL9u2jVyNB3h6YYOvvcHhx5M4yCHyAg+rEY477ojk24S+9j/pfpjjCNh/5y1eFqHWKOatmt88jm3X5u2FwOpys1yYG02yzjk9T2SVZbgaWcQavDosw6+n/kjdoj21ziavdyqWZq39RQZNdHoxs+I/R4Lb92xdIVQJBAPVTAA0M80u4Y3kB7BlsarZLxrifkajm3eewNNQO4o/xLGQQRkEujH+UmFx/LeWGcijrytyf2JKBaEKB4O6tx0sCQQDgLvCpi7a4Rt7fcx81LIpwYdtaZ5laSgF2DSQ4c/xsr+x7kYFROHN9wQV3wtzuqm4DV+wlWuobRGSMmTeFStv3AkEA6UJ0J/SKWRMHsgU74qiNhqviVaWTsA9kK2oFsSQ+FDNyy+oVguCpwp0dicV7dGQzo+kfSEvMdvEIm0Q3BXrCpQJAQ4uhE1R3LzqbODQVeQ38gDPbxXdlayDVI959xUydB5pR5EFI91HM6lzX6ueZbYeIMhWxnuevlZubuAkKA200rQJBAJTUjrZQhIaa+GcdzriooabON2wL4MzrK5puVtnvY4HL1pz71pQpFU6nNRML6ixV9PNBSpeZi8y1n1qPuXhppmE=";

//public static final String RSA_PUBLIC_KEY = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDW1ZuVt2elW0dkawf1CLN5tjLn"
//+ "ax6zjFL7PJdT+/px7StDJRZwGSvtOiBvS1PTYfzNvSQue1FnrRmGyTVxMFOqiqyg"
//+ "KE1dcQREQd3ctaCJUjrn7TDwUH7SyEdYl+t0dbG8UVPx+qazG5IfiwYy9yFJtqdu" + "N2DAV4dQwacXhdZyXQIDAQAB";

@implementation LUAliPay


+(void)alipay :(void (^)(NSDictionary *resultDic))next{
    ShoppingCartModel *scm=[ShoppingCartModel sharedInstance];
    OrderModel *orderModel=scm.orderModel;
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088911581313804";
    NSString *seller = @"bairongwei@163.com";
    NSString *privateKey = RSA_PRIVATE_KEY;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO =orderModel.orderCode;//[self generateTradeNO];//orderModel.orderCode; //订单ID（由商家自行制定）
    order.productName = @"陆思测试一分钱支付"; //商品标题
    order.productDescription = @"一分钱支付"; //商品描述
    order.amount =[NSString stringWithFormat:@"%.2f",orderModel.totalPrice.floatValue]; //商品价格
    order.notifyURL = [[HttpHelper getUrl] stringByAppendingString:[NSString stringWithFormat:@"/addAlipayInfo"]]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            next(resultDic);
        }];
        
    }
}

+ (NSString *)generateTradeNO{
    static int kNumber = 16;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
