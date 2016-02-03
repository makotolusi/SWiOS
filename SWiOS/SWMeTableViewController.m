//
//  SWMeTableViewController.m
//  SWUITableView
//
//  Created by 李乐 on 15/9/7.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import "SWMeTableViewController.h"
#import "UILabel+Extension.h"
#import "HttpHelper.h"
#import "MyOrderController.h"
#import "NSString+Extension.h"
#import "AddressViewController.h"
#import "DatabaseManager.h"
#import "AddressListViewController.h"
#import "UILabel+Extension.h"
#import "GenderViewController.h"
#import "YCAsyncImageView.h"
#import "UIAlertView+Extension.h"
#import "RegisterViewController.h"
#import "LoadingView.h"
#import "FavorViewController.h"
#import "ShoppingCartLocalDataManager.h"
#import "MobClick.h"
#import "EmptyCell.h"
//NSString * const killShark = @"柠檬鲨别捣乱";
NSString * const kME = @"头像";
NSString * const kMoney = @"钱包";
NSString * const kName=@"名字";
NSString * const kGender=@"性别";
NSString * const kAddress=@"我的地址";
NSString * const kLogOut=@"退出";
NSString * const kOrder = @"我的订单";
NSString * const kFavor = @"我的收藏";
NSString * const clearCache=@"清除缓存";
NSString * const kSelfPhoto = @"selfPhoto.jpg";

#define HEAD_RES_BIG 500
#define HEAD_RES_SMALL 60
@interface SWMeTableViewController ()<GenderDelegate> {
    NSMutableArray* groups;
    UITableViewCell* hiddenCell;
    YCAsyncImageView* meUIImageView;
    YCAsyncImageView* bigImageView;
    UILabel* meTextLabel;
     UILabel* meGenderLabel;
     UILabel* meAddressLabel;
    FileUploadHelper* fileUploadHelper;
    NSString* imageFilePath;
    NSString* rawImageFilePath;

//    UINavigationController* navController;
}
@property (nonatomic, strong) YALSunnyRefreshControl* sunnyRefreshControl;
@property (assign,nonatomic) int gender;
@property (copy,nonatomic) NSString *headUrl;
@property (copy,nonatomic) NSString *smallHeadUrl;
@property (copy,nonatomic) NSString *address;

@property (nonatomic,strong) ShoppingCartModel *cartModel;
@end

@implementation SWMeTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initData];
    [self setupRefreshControl];
    [self.navigationItem.backBarButtonItem setTitle:@""];

}
- ( void ) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- ( void ) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefreshControl
{

//    self.sunnyRefreshControl = [YALSunnyRefreshControl attachToScrollView:self.tableView
//                                                                   target:self
//                                                            refreshAction:@selector(sunnyControlDidStartAnimation)];
}

-(void)sunnyControlDidStartAnimation{
    // start loading something
    hiddenCell.hidden = NO;
}

-(IBAction)endAnimationHandle{
    
//    [self.sunnyRefreshControl endRefreshing];
    
}

-(void)_initData{
//    [HttpHelper sendGetRequest:@"CommerceUserServices/getUserInfo"
//                    parameters: @{}
//                       success:^(id response) {
//                           NSDictionary* result=[response jsonString2Dictionary];
//                           BOOL success=[result valueForKey:@"success"];
//                           if(success){
//                               NSDictionary *dic=[result[@"data"] jsonString2Dictionary];
    _cartModel=[ShoppingCartModel sharedInstance];
                               _username=_cartModel.registerModel.username;
                               _gender=_cartModel.registerModel.gender.intValue;
                               _headUrl=_cartModel.registerModel.imgUrl;
                                _smallHeadUrl=_cartModel.registerModel.smallImgUrl;
                               _address=_cartModel.registerModel.addr;
                               [self _init];
//                           }
//                       }fail:^{
//                           NSLog(@"网络异常，取数据异常");
//                       } parentView:self.view];

}
-(void)_init{
    ShoppingCartModel *_cartModel=[ShoppingCartModel sharedInstance];
    _cartModel.route=@"SWMeTableViewController";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
//    // present the cropper view controller
//    VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
//    imgCropperVC.delegate = self;
//    [self presentViewController:imgCropperVC animated:YES completion:^{
//        // TO DO
//    }];
    
    //    [self.view addSubview:self.tableView];

    SWMe* s1 = [[SWMe alloc] initWithDescribe:kME andImgUrl:@"head"];
    SWMe* s12 = [[SWMe alloc] initWithDescribe:kName andImgUrl:@"name"];
    SWMe* s13 = [[SWMe alloc] initWithDescribe:kGender andImgUrl:@"gender"];
    SWMe* s14 = [[SWMe alloc] initWithDescribe:kAddress andImgUrl:@"map"];
    SWMe* s15 = [[SWMe alloc] initWithDescribe:@"我的订单" andImgUrl:@"dingdan"];
    SWMe* s16 = [[SWMe alloc] initWithDescribe:kFavor andImgUrl:@"sc"];
    
    
//    SWMe* s21 = [[SWMe alloc] initWithDescribe:kMoney andImgUrl:@""];

    SWMe* s31 = [[SWMe alloc] initWithDescribe:clearCache andImgUrl:@"cache"];
//    SWMe* s32 = [[SWMe alloc] initWithDescribe:killShark andImgUrl:@"shark.png"];
    
    SWMe* s41 = [[SWMe alloc] initWithDescribe:kLogOut andImgUrl:@""];
    NSArray* array = [NSArray arrayWithObjects:s1,s12,s13,s14,s15,s16,s31,s41, nil];

//    NSArray* array2 = [NSArray arrayWithObjects:s21, nil];


//    NSArray* array3 = [NSArray arrayWithObjects:s31, nil];
    
//     NSArray* array4 = [NSArray arrayWithObjects:s41,nil];
    groups = [[NSMutableArray alloc] init];
    [groups addObject:array];
//    [groups addObject:array2];
//    [groups addObject:array3];
//    [groups addObject:array4];
//    _rootController = [[UINavigationController alloc]init];
//    [self.view.window addSubview:_rootController.view];
//    navController = [[UINavigationController alloc]initWithRootViewController:self];
    // clean selfphoto
//    [self existsFileSelfPhoto:selfPhoto delFlg:YES];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *array = groups[section];
    return [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"reuseIdentifier";

    EmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[EmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SWMe* s = [groups[[indexPath section]] objectAtIndex:[indexPath row]];

    //    cell.detailTextLabel.text = @"detail";
    cell.textLabel.text = s.describe;
    [cell.textLabel smallLabel];
    cell.imageView.image=[UIImage imageNamed:s.imgUrl];
//    if (![s.describe isEqual:killShark]&&![s.describe isEqual:kLogOut]) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }

    if ([s.describe isEqual:kME]) {
        
        meUIImageView=[[YCAsyncImageView alloc] init];
        if (StringIsNullOrEmpty(_smallHeadUrl)) {
            meUIImageView.image=[UIImage imageNamed:@"sun"];
        }else
            [meUIImageView setUrl:_smallHeadUrl];
//        meUIImageView.hidden = YES;
        meUIImageView.frame=CGRectMake(SCREEN_WIDTH-100, cell.frame.size.height/2-10, HEAD_RES_SMALL, HEAD_RES_SMALL);
        bigImageView=[[YCAsyncImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 10, HEAD_RES_BIG, HEAD_RES_BIG)];
        [bigImageView setUrl:_headUrl];
        UILabel *headLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 40, 100, 10)];
        [headLabel smallLabel];
        [cell addSubview:headLabel];
//        if ([self existsFileSelfPhoto:kSelfPhoto delFlg:NO]) {
//            meUIImageView.image = [UIImage imageNamed:rawImageFilePath];
            [ImageHelper makeRoundCorners:meUIImageView];
//        }
        [meUIImageView setUserInteractionEnabled:YES];
        [cell addSubview:meUIImageView];
        [cell.textLabel setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageClicked:)];
        [meUIImageView addGestureRecognizer:singleTap];
        
        
    }
    
    if ([s.describe isEqual:kName]) {
        meTextLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, cell.frame.size.height/2-10, 100, 20)];
        [meTextLabel smallLabel];
        [meTextLabel setUserInteractionEnabled:YES];
        meTextLabel.text=StringIsNullOrEmpty(_username)?@"柠檬鲨":_username;
        UITapGestureRecognizer* singleTapTextLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTextLabelClicked:)];
        [cell  addGestureRecognizer:singleTapTextLabel];
        [cell addSubview:meTextLabel];
    }
    if ([s.describe isEqual:kGender]) {
        meGenderLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, cell.frame.size.height/2-10, 60, 20)];
        [meGenderLabel smallLabel];
        [meGenderLabel setUserInteractionEnabled:YES];
        meGenderLabel.text=_gender==0?@"男":@"女";
        [cell addSubview:meGenderLabel];
    }

//    if (!self.sunnyRefreshControl.forbidContentInsetChanges) {
//        if ([s.describe isEqual:killShark]) {
//            cell.hidden = YES;
//            hiddenCell = cell;
//        }
//    }
     if ([s.describe isEqual:kLogOut]) {
         UILabel *logoutLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, cell.frame.size.height/2-10, 200, 20)];
         logoutLabel.textAlignment=NSTextAlignmentCenter;
         [logoutLabel smallLabel];
//         logoutLabel.textColor=[UIColor blackColor];
         logoutLabel.text=cell.textLabel.text;
         cell.textLabel.text=@"";
         [cell addSubview:logoutLabel];
     }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    SWMe* s = [groups[[indexPath section]] objectAtIndex:[indexPath row]];
    if ([s.describe isEqual:kME]) {
        return HEAD_RES_SMALL+20;
    }
    return SCREEN_HEIGHT*0.07;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SWMe* s = [groups[[indexPath section]] objectAtIndex:[indexPath row]];

    if ([s.describe isEqual:kME]) {
        //
        [self takePictureClick];
    }
//    if ([s.describe isEqual:killShark]) {
//
//        [self endAnimationHandle];
//        hiddenCell.hidden = YES;
//    }
    if ([s.describe isEqual:kMoney]) {

        SWMoneyNavigationController* uiNavigationController = [[SWMoneyNavigationController alloc] initWithNibName:@"SWMoneyNavigationController" bundle:nil];

        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"撤退"
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:nil];
        self.navigationItem.backBarButtonItem = cancelButton;
        [self.navigationController pushViewController:uiNavigationController animated:YES];
    }
    if ([s.describe isEqual:kOrder]) {
        MyOrderController* uiNavigationController = [[MyOrderController alloc] init];
        uiNavigationController.prePage=@"SWMeTableViewController";
        uiNavigationController.navigationItem.titleView = [UILabel navTitleLabel:kOrder];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:nil];
        self.navigationItem.backBarButtonItem = cancelButton;
        [self.navigationController pushViewController:uiNavigationController animated:YES];
    }
    
    if ([s.describe isEqual:kFavor]) {
        FavorViewController* uiNavigationController = [[FavorViewController alloc] init];
        uiNavigationController.navigationItem.titleView = [UILabel navTitleLabel:kFavor];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:nil];
        self.navigationItem.backBarButtonItem = cancelButton;
        [self.navigationController pushViewController:uiNavigationController animated:YES];
    }
    if ([s.describe isEqual:kAddress]) {
        DatabaseManager *db=[DatabaseManager sharedDatabaseManager];
        NSArray *array=db.getAllAddress;
        if (array.count>0&&_cartModel.addressModel.name!=nil) {
            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
            self.navigationItem.backBarButtonItem = cancelButton;
            AddressListViewController *av=[[AddressListViewController  alloc] init];
            int row=0;
            if (_cartModel.addressModel) {
                row=_cartModel.addressModel.index;
            }
            NSIndexPath* index=[NSIndexPath indexPathForRow:row inSection:0];
            av.lastPath=index;

            [self.navigationController pushViewController:av animated:YES];
        }else{
            self.navigationItem.title=@"收货人信息";
            //back button style
            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
            self.navigationItem.backBarButtonItem = cancelButton;
            AddressViewController *av=[[AddressViewController  alloc] init];
            [self.navigationController pushViewController:av animated:YES];
        }
    }
    if ([s.describe isEqual:kGender]) {
        self.navigationItem.title=@"修改性别";
        GenderViewController *av=[[GenderViewController  alloc] init];
        av.defautPath=_gender;
        av.delegate=self;
        [self.navigationController pushViewController:av animated:YES];
    }
    if ([s.describe isEqual:clearCache]) {
        [LoadingView initWithFrame:CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2 , 50, 50) parentView:self.view];
        [YCAsyncImageView removeCache];
        //彻底清除缓存第一种方法
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        
        NSString *str = [NSString stringWithFormat:@"缓存已清除%.1fM", [self folderSizeAtPath:path]];
        NSLog(@"%@",str);
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        for (NSString *p in files) {
            NSError *error;
//            NSLog(@"%@",p);
            NSString *Path = [path stringByAppendingPathComponent:p];
            NSRange queMarkIdx = [p rangeOfString:@"Preferences"];
            if (queMarkIdx.location != NSNotFound) {
                continue;
            }
            
                if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
                }
        }
        [LoadingView stopAnimating:self.view];
        [UIAlertView showMessage:str];
    }
    
    if ([s.describe isEqual:kLogOut]) {
    UIAlertView *button=[[UIAlertView alloc] initWithTitle:@"您确认要退出登录？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [button show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        RegisterViewController * mvc = [[RegisterViewController alloc]init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:USER_LOGIN_PHONE_NUM];
        [ShoppingCartModel clearUserCartAll];
        [self presentViewController:mvc animated:YES completion:nil];
        [ShoppingCartLocalDataManager dropAllTables];
        //um uid
        [MobClick profileSignOff];
    }
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
    
    //遍历文件夹获得文件夹大小，返回多少M
    - (float )folderSizeAtPath:(NSString*)folderPath{
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:folderPath]) return 0;
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
        NSString* fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize/(1024.0*1024.0);
    }

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{

    NSInteger section = [indexPath section];
    NSArray* array = groups[section];
    NSUInteger row = [indexPath row];
    SWMe* s = [array objectAtIndex:row];
    if ([s.describe isEqual:kME]) {
        //
        [self takePictureClick];
    }
}

-(void)onImageClicked:(UITapGestureRecognizer *)gesture{
//    meUIImageView.frame=CGRectMake(0, 0, 200, 200)
//    [self.view addSubview:meUIImageView];
    
    [ImageHelper showImage:bigImageView];
}
-(void)onTextLabelClicked:(UITapGestureRecognizer *)gesture {

    [self input:kName url:@"updateUserName"];
}

-(void)onGenderLabelClicked:(UITapGestureRecognizer *)gesture {
    
    [self input:kGender url:@""];
}

-(void)input:(NSString*)ktype url:(NSString*)url {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"柠檬鲨要你留下你的%@哦" ,ktype] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction* action) {
                                                       NSLog(@"取消");
                                                   }];
    [alertController addAction:action];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // 用户名
            NSString *userNameStr = [alertController.textFields[0] text];
            if ([userNameStr length]>10) {
                [UIAlertView showMessage:@"用户名过长"];
                return;
            }
            if ([userNameStr length] != 0) {
                [meTextLabel setText:userNameStr];
            }
            
            NSLog(@"userName is: %@ ", userNameStr);
            [HttpHelper sendPostRequest:[@"CommerceUserServices/" stringByAppendingString:url]
                            parameters: @{@"username":userNameStr}
                               success:^(id response) {
                                   NSDictionary* result=[response jsonString2Dictionary];
                                   BOOL success=[result valueForKey:@"success"];
                                   if(success){
                                       
                                   }
                               }fail:^{
                                   NSLog(@"网络异常，取数据异常");
                               } parentView:nil];
            
        }];
        action;
    })];
    
    if (alertController.preferredStyle == UIAlertControllerStyleAlert) {
        // 添加用户名输入框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField* textField) {
            // 给输入框设置一些信息
            textField.placeholder = [NSString stringWithFormat:@"请输入%@" ,ktype];
            textField.textAlignment = NSTextAlignmentCenter;
        }];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark － Delegate
-(void)failed:(QNResponseInfo *)info{
    
    NSLog(@" --->> error: %@  ", info.error);
    
}
-(void)sucessed{
    
    [fileUploadHelper uploadFileToQiniuByPutFile];
    
}

-(void) imgReloadAfterUpload:(NSString*)bigImg smallImg:(NSString*)smallImg{
    self.smallHeadUrl=smallImg;
    [meUIImageView setUrl:smallImg];
    self.headUrl=bigImg;
    [bigImageView setUrl:bigImg];
//    [self.tableView reloadData];
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
//        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
//        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)existsFileSelfPhoto:(NSString *)fileName delFlg:(BOOL)flg{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    imageFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSString * raw = @"raw";
    raw = [raw stringByAppendingString:fileName];
    rawImageFilePath = [documentsDirectory stringByAppendingPathComponent:raw];
    BOOL success = [fileManager fileExistsAtPath:imageFilePath];
    if (success) {
        if (flg) {
            NSError *error;
            [fileManager removeItemAtPath:imageFilePath error:&error];
        }
        return YES;
    }
    return NO;
}


- (void)saveImage:(UIImage *)image {
//    meUIImageView.image = image;
//    [ImageHelper makeRoundCorners:meUIImageView];
    

    [self existsFileSelfPhoto:kSelfPhoto delFlg:YES];
    
    UIImage *smallImage = [ImageHelper thumbnailWithImageWithoutScale:image size:CGSizeMake(HEAD_RES_BIG, HEAD_RES_BIG)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:rawImageFilePath atomically:YES];
    
    
    // upload to qiniu
    fileUploadHelper = [[FileUploadHelper alloc]init];
    fileUploadHelper.delegate = self;
    fileUploadHelper.imageFilePath = imageFilePath;
    [fileUploadHelper makeUpToken];
    
}






//从相册获取图片
-(void)takePictureClick{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    [actionSheet showInView:self.view];
}

#pragma UIActionSheet Delegate
- (void)extracted_method:(NSInteger) sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = [%ld]", buttonIndex);
    switch (buttonIndex) {
    case 0: {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //照相机
            [self extracted_method:UIImagePickerControllerSourceTypeCamera];
        }
    } break;
    case 1: {

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            //本地相簿
            [self extracted_method:UIImagePickerControllerSourceTypePhotoLibrary];
        }

    } break;
    default:
        break;
    }
}

- (void)updateGenderView:(NSString*)gender{
    meGenderLabel.text=gender;
    _gender=[gender isEqual:@"男"]?0:1;
}
@end
