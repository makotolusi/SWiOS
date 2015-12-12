//
//  SWExploreFlatCell2ValueObject.m
//  SWiOS
//
//  Created by 陆思 on 15/11/20.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "SWExploreFlatCell2ValueObject.h"


@implementation SWExploreFlatCell2ValueObject


//addr = "\U94f6\U5ea7";
//currency = "\U65e5\U5143";
//description = "\U771f\U597d ";
//entertime = "2015-06-14 20:18:43";
//experience = "\U723d";
//id = 1;
//name = "\U9762\U819c ";
//picUrl1 = "http://cache.k.sohu.com/img8/wb/smccloud/2015/02/16/142410224028093694.JPEG";
//picUrl2 = "http://cache.k.sohu.com/img8/wb/smccloud/2015/02/16/142410223365920642.JPEG";
//piece = 1;
//pieceCategory = 1;
//price = 1;
//productCode = M000001;
//quantity = 0;
//systemName = M;
//total = 0;
//username = li;
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.itemName = dic[@"name"];
            self.desc = dic[@"description"];
            self.bigImageURL = dic[@"picUrl1"];
            self.productCode = dic[@"productCode"];
            self.rushQuantity=dic[@"rushQuantity"];
            NSNumber* number=dic[@"zanCount"];
             self.zans=number.longValue;
            NSNumber* isZ=dic[@"isZan"];
            self.isZan=isZ.intValue;
             NSNumber* isF=dic[@"isFavor"];
             self.isFavor=isF.intValue;
        }
    }
    
    return self;
}

@end
