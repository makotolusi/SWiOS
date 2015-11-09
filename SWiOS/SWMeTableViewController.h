//
//  SWMeTableViewController.h
//  SWUITableView
//
//  Created by 李乐 on 15/9/7.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FileUploadHelper.h"
#import "YALSunnyRefreshControl.h"
#import "SWMe.h"
#import "QiniuSDK.h"
#import "ImageHelper.h"
#import "SWMoneyNavigationController.h"

@interface SWMeTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,FileUploadHelperDelegate>

@property (strong,nonatomic) UITableViewCell * tableViewCell;


@property (copy,nonatomic) NSString* username;


@end
