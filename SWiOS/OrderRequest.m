//
//  OrderRequest.m
//  SWiOS
//
//  Created by 陆思 on 15/10/21.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "OrderRequest.h"
#import "HttpHelper.h"
#import "OrderDetailModel.h"
#import "ShoppingCartModel.h"
#import "ActivityProduct.h"
#import "NSString+Extension.h"
#import "RegisterModel.h"
@implementation OrderRequest

+(ShoppingCartModel*)orderCheck:(void (^)())next{
    ShoppingCartModel *_shoppingCart=[ShoppingCartModel sharedInstance];
    NSMutableArray *orderDetails=[NSMutableArray array];
    NSArray *activityProducts=_shoppingCart.arOfWatchesOfCart;
    for (int i=0; i<activityProducts.count; i++) {
        ActivityProduct *ap=activityProducts[i];
        OrderDetailModel *orderDetail=[[OrderDetailModel alloc] init];
        [orderDetail setValue:ap.activityId forKey:@"activityId"];
        [orderDetail setValue:ap.productCode forKey:@"productCode"];
        [orderDetail setValue:[NSNumber numberWithInteger:ap.buyCount] forKey:@"count"];
        [orderDetail setValue:ap.rushPrice forKey:@"price"];
        [orderDetails addObject:[orderDetail toDictionary]];
    }
    [_shoppingCart.orderModel setValue:orderDetails forKey:@"orderDetails"];

    [_shoppingCart.orderModel setValue:@"%@" forKey:@"orderCode"];
    [_shoppingCart.orderModel setValue:[_shoppingCart.registerModel valueForKey:@"id"] forKey:@"receiverId"];
    [_shoppingCart.orderModel setValue:_shoppingCart.addressModel.name forKey:@"reviewerName"];
    [_shoppingCart.orderModel setValue:_shoppingCart.addressModel.phone forKey:@"receiverPhone"];
    [_shoppingCart.orderModel setValue:_shoppingCart.addressModel.address forKey:@"receiverInfo"];
    [_shoppingCart.orderModel setValue:@"ZHIFUBAO" forKey:@"payType"];
//    [_shoppingCart.orderModel setValue:@"%@" forKey:@"orderCode"];
//    [_shoppingCart.orderModel setValue:@"%@" forKey:@"orderCode"];
    NSDictionary* lu=[_shoppingCart.orderModel toDictionary];
//    [lu setValue:@"%@" forKey:@"orderCode"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:lu options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dict1 = @{@"content": jsonString};
    [HttpHelper sendPostRequest:@"SnapUpServices/snapup"
                     parameters: dict1
                        success:^(id response) {
                            NSDictionary* result=[response jsonString2Dictionary];
                            BOOL success=[result valueForKey:@"success"];
                            if(success){
                                NSDictionary* data=[result[@"data"] jsonString2Dictionary];
                                NSString* orderCode=data[@"orderCode"];
                                [_shoppingCart.orderModel setValue:orderCode forKey:@"orderCode"];
                                NSString* orderInfo=[NSString stringWithFormat:jsonString,orderCode ];
                                [self orderCofirm:orderInfo next:^{
                                     next();
                                }];
                            }
                            NSLog(@"获取到的数据为dict：%@", result);
                        } fail:^{
                            NSLog(@"fail");
                        }];
    return nil;
}

+(void)orderCofirm:(NSString*)orderInfo next:(void (^)())next{
    NSDictionary *dict1 = @{@"content": orderInfo};
     ShoppingCartModel *_shoppingCart=[ShoppingCartModel sharedInstance];
    [HttpHelper sendPostRequest:@"SnapUpServices/confirm"
                     parameters: dict1
                        success:^(id response) {
                            NSDictionary* result=[response jsonString2Dictionary];
                            BOOL success=[result valueForKey:@"success"];
                            if(success){
                                 _shoppingCart.orderInfoString=orderInfo;
                                next();
                            }
                            NSLog(@"获取到的数据为dict：%@", result);
                        } fail:^{
                            NSLog(@"fail");
                        }];

}

+(void)orderCancel:(UIView*)view next:(void (^)())next{
     ShoppingCartModel *_shoppingCart=[ShoppingCartModel sharedInstance];
    NSDictionary *dict1 = @{@"content":  _shoppingCart.orderInfoString};
    [HttpHelper sendPostRequest:@"SnapUpServices/cancel"
                     parameters: dict1
                        success:^(id response) {
                            NSDictionary* result=[response jsonString2Dictionary];
                            BOOL success=[result valueForKey:@"success"];
                            if(success){
                                next();
                            }
                            NSLog(@"获取到的数据为dict：%@", result);
                        } fail:^{
                            NSLog(@"fail");
                        } parentView:view];
    
}

@end
