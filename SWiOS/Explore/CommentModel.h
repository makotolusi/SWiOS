//
//  CommentModel.h
//  SWiOS
//
//  Created by 陆思 on 15/11/21.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "JSONModel.h"
#import "YCAsyncImageView.h"
@interface CommentModel : JSONModel
@property(nonatomic,copy) NSString<Optional>* comments;
@property(nonatomic,copy) NSString<Optional>* userName;
@property(nonatomic,assign) int userId;
@property(nonatomic,copy) NSString<Optional>* userHeadPortraitUrl;
@property(nonatomic,copy) NSString<Optional>* productCode;
@property(nonatomic,strong) NSString<Optional>* entertime;
@end
