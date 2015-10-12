//
//  SWMeTableViewController.m
//  SWUITableView
//
//  Created by 李乐 on 15/9/7.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import "SWMeTableViewController.h"


NSString * const killShark = @"柠檬鲨别捣乱";
NSString * const kME = @"我";
NSString * const kMoney = @"钱包";
NSString * const kSelfPhoto = @"selfPhoto.jpg";

@interface SWMeTableViewController () {
    NSMutableArray* groups;
    UITableViewCell* hiddenCell;
    UIImageView* meUIImageView;
    UILabel* meTextLabel;
    FileUploadHelper* fileUploadHelper;
    NSString* imageFilePath;
    NSString* rawImageFilePath;
//    UINavigationController* navController;
}
@property (nonatomic, strong) YALSunnyRefreshControl* sunnyRefreshControl;
@end

@implementation SWMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _init];
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

    self.sunnyRefreshControl = [YALSunnyRefreshControl attachToScrollView:self.tableView
                                                                   target:self
                                                            refreshAction:@selector(sunnyControlDidStartAnimation)];
}

-(void)sunnyControlDidStartAnimation{
    // start loading something
    hiddenCell.hidden = NO;
}

-(IBAction)endAnimationHandle{
    
    [self.sunnyRefreshControl endRefreshing];
}

-(void)_init{

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //    [self.view addSubview:self.tableView];

    SWMe* s1 = [[SWMe alloc] initWithDescribe:kME andImgUrl:@"me.png"];

    NSArray* array = [NSArray arrayWithObjects:s1, nil];

    SWMe* s21 = [[SWMe alloc] initWithDescribe:kMoney andImgUrl:@"money.png"];

    NSArray* array2 = [NSArray arrayWithObjects:s21, nil];

    SWMe* s31 = [[SWMe alloc] initWithDescribe:@"设定" andImgUrl:@"setting.png"];
    SWMe* s32 = [[SWMe alloc] initWithDescribe:killShark andImgUrl:@"shark.png"];
    NSArray* array3 = [NSArray arrayWithObjects:s31, s32, nil];

    groups = [[NSMutableArray alloc] init];
    [groups addObject:array];
    [groups addObject:array2];
    [groups addObject:array3];

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

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }

    SWMe* s = [groups[[indexPath section]] objectAtIndex:[indexPath row]];

    //    cell.detailTextLabel.text = @"detail";
    cell.textLabel.text = s.describe;
    if (![s.describe isEqual:killShark]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    //    cell.backgroundColor = [UIColor orangeColor];
    cell.imageView.hidden = NO;
    cell.imageView.image = [UIImage imageNamed:s.imgUrl];

    if ([s.describe isEqual:kME]) {
        if ([self existsFileSelfPhoto:kSelfPhoto delFlg:NO]) {
            cell.imageView.image = [UIImage imageNamed:rawImageFilePath];
            [ImageHelper makeRoundCorners:cell.imageView];
        }
        [cell.imageView setUserInteractionEnabled:YES];
        [cell.textLabel setUserInteractionEnabled:YES];

        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageClicked:)];
        [cell.imageView addGestureRecognizer:singleTap];
        meUIImageView = cell.imageView;

        UITapGestureRecognizer* singleTapTextLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTextLabelClicked:)];
        [cell.textLabel addGestureRecognizer:singleTapTextLabel];
        meTextLabel = cell.textLabel;
    }

    if (!self.sunnyRefreshControl.forbidContentInsetChanges) {
        if ([s.describe isEqual:killShark]) {
            cell.hidden = YES;
            hiddenCell = cell;
        }
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    SWMe* s = [groups[[indexPath section]] objectAtIndex:[indexPath row]];
    if ([s.describe isEqual:kME]) {
        return 80.0f;
    }
    return 40.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SWMe* s = [groups[[indexPath section]] objectAtIndex:[indexPath row]];

    if ([s.describe isEqual:kME]) {
        //
        [self takePictureClick];
    }
    if ([s.describe isEqual:killShark]) {

        [self endAnimationHandle];
        hiddenCell.hidden = YES;
    }
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

    [ImageHelper showImage:meUIImageView];
}
-(void)onTextLabelClicked:(UITapGestureRecognizer *)gesture{

    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"" message:@"柠檬鲨要你留下你的小名哦" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* action = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction* action) {
                                                       NSLog(@"取消");
                                                   }];
    [alertController addAction:action];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"确定");
            
            // 用户名
            NSString *userNameStr = [alertController.textFields[0] text];
            if ([userNameStr length] != 0) {
                [meTextLabel setText:userNameStr];
            }
            
            NSLog(@"userName is: %@ ", userNameStr);
        }];
        action;
    })];

    if (alertController.preferredStyle == UIAlertControllerStyleAlert) {
        // 添加用户名输入框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField* textField) {
            // 给输入框设置一些信息
            textField.placeholder = @"请输入用户名";
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
    meUIImageView.image = image;
    [ImageHelper makeRoundCorners:meUIImageView];
    

    [self existsFileSelfPhoto:kSelfPhoto delFlg:YES];
    
    UIImage *smallImage = [ImageHelper thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
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


@end
