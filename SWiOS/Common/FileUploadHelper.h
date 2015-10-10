//
//  FileUploadHelper.h
//  SWUITableView
//
//  Created by 李乐 on 15/9/15.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
#import "HttpHelper.h"

@protocol FileUploadHelperDelegate;


@interface FileUploadHelper : NSObject


- (void)uploadFileToQiniuByPutFile;
-(NSString*)makeUpToken;
@property (nonatomic,weak  ) id<FileUploadHelperDelegate> delegate;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * imageFilePath;
@end

@protocol FileUploadHelperDelegate <NSObject>

@optional
-(void) sucessed;
-(void) failed:(QNResponseInfo *)info;

@end
