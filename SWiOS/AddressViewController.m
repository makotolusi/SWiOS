//
//  AddressViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/14.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressListViewController.h"
#import "EmptyCell.h"
#import "DatabaseManager.h"
#import "NSString+Extension.h"
#import "BalanceController.h"
#import "HttpHelper.h"
#import "UIAlertView+Extension.h"
#import "SWMeTableViewController.h"
#import "UILabel+Extension.h"
@interface AddressViewController ()
@property (retain, nonatomic) UITextField *areaText;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (copy, nonatomic) NSString *areaValue;
@property (strong, nonatomic) AddressModel *addressModel;

@end

@implementation AddressViewController

-(void)viewWillAppear:(BOOL)animated{
    self.pageName=@"AddressViewController";
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadTableView];
    _databaseManager=[DatabaseManager sharedDatabaseManager];
    _addressModel=[_databaseManager getAddressByID:_addressId ];
}

- (void)_loadTableView {
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.rowHeight=SCREEN_HEIGHT*0.07;
    //创建编辑按钮
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 40)];
    editButton.backgroundColor = [UIColor clearColor];
    [editButton setTitle:@"保存" forState:UIControlStateNormal];
    [editButton setTitleColor:UIColorFromRGB(0x1abc9c) forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    //创建edit按钮
    UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
     self.navigationItem.rightBarButtonItem=homeButtonItem;
    // 注册单元格（nib, code）
//    [_tableView registerNib:[UINib nibWithNibName:@"OrderPriceCell" bundle:nil] forCellReuseIdentifier:orderPriceCell];
//    [_tableView registerNib:[UINib nibWithNibName:@"OrderListCell" bundle:nil] forCellReuseIdentifier:orderListCell];
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturedDetected:)]; // 手势类型随你喜欢。
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"reuseIdentifier";
    EmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
//    AreaPickerView *pick=[[AreaPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.frame.size.height)];
    if (cell == nil) {
        cell = [[EmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    switch (indexPath.row) {
        case 0:
           
            [cell addSubview:[self input:@"收货人姓名" tag:11 text: _addressModel.name]];
            break;
        case 1:
            [cell addSubview:[self input:@"手机号码" tag:12 text: _addressModel.phone]];
            break;
        case 2:
            [cell addSubview:[self input:@"邮政编码" tag:13 text: _addressModel.code]];
            break;
        case 3:
            _areaText=[[UITextField alloc] initWithFrame:CGRectMake(5,0,cell.frame.size.width,cell.frame.size.height)];
            _areaText.delegate=self;
            _areaText.placeholder=@"省，市，区";
            _areaText.tag=14;
            _areaText.text= _addressModel.city;
            [_areaText setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
            [cell addSubview:_areaText];
            break;
        case 4:
//            [cell addSubview:[self textView:_addressModel.address]];
              [cell addSubview:[self input:@"详细地址" tag:15 text: _addressModel.address]];
            break;
        default:
            break;
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITextView*)textView:(NSString*)text{
    UITextView* textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    if (StringIsNullOrEmpty(text)) {
        _placeholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 20)];
        _placeholderLabel.textColor=[UIColor lightGrayColor];
        _placeholderLabel.font=[UIFont systemFontOfSize:15];
        _placeholderLabel.text=@"详细地址";
        
        [textView addSubview:_placeholderLabel];
    }
    textView.tag=15;
    textView.text=text;
    textView.font=[UIFont systemFontOfSize:15];
    textView.delegate=self;
    return textView;
}
-(UITextField*)input:(NSString*)placeholderText tag:(NSInteger) tag text:(NSString*)text {
    UITextField* input=[[UITextField alloc] initWithFrame:CGRectMake(5, 0, 200, _tableView.rowHeight)];
    input.placeholder=placeholderText;
    input.tag=tag;
    input.text=text;
    input.font=[UIFont systemFontOfSize:13];
    [input setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    return input;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        _placeholderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""])
    {
        _placeholderLabel.hidden = NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}

- (void)tapGesturedDetected:(UITapGestureRecognizer *)recognizer
{
    [_locatePicker removeFromSuperview];
    
    // do something
}

-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        self.areaText.text = areaValue;
    }
}
-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.areaText]) {
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        [self.locatePicker showInView:self.view];
    } else {
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
        [self.locatePicker showInView:self.view];
    }
    return NO;
}

- (void)viewDidUnload
{
    [self setAreaText:nil];
    [self cancelLocatePicker];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    } else{
        //        self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
}

- (void)save:(UIButton*)sender {
    AddressModel *add=[[AddressModel alloc] init];
    add.AddressModelID=_addressModel.AddressModelID;
    UITextField *nameTf=[self.view viewWithTag:11];
    NSString *name=nameTf.text;
    if(StringIsNullOrEmpty(name)){
        [UIAlertView showMessage:@"请输入收货人姓名"];
        return;
    }
    [add setValue:name forKey:@"name"];
    
    UITextField *phoneTf=[self.view viewWithTag:12];
    NSString *phone=phoneTf.text;
    if (StringIsNullOrEmpty(phone)) {
        [UIAlertView showMessage:@"请输入电话号码"];
        return;
    }
    [add setValue:phone forKey:@"phone"];
    
    UITextField *codeTf=[self.view viewWithTag:13];
    NSString *code=codeTf.text;
    if (StringIsNullOrEmpty(code)) {
        [UIAlertView showMessage:@"请输入邮政编码"];
        return;
    }
    [add setValue:code forKey:@"code"];
    
    UITextField *cityTf=[self.view viewWithTag:14];
    NSString *city=cityTf.text;
    if (StringIsNullOrEmpty(city)) {
        [UIAlertView showMessage:@"请选择区域信息"];
        return;
    }
    [add setValue:city forKey:@"city"];
    
    UITextView *addressTf=[self.view viewWithTag:15];
    NSString *address=addressTf.text;
    if (StringIsNullOrEmpty(address)) {
        [UIAlertView showMessage:@"请输入地址详细信息"];
        return;
    }
    [add setValue:address  forKey:@"address"];
    add.mts=[[NSDate date] timeIntervalSince1970];
    [_databaseManager insertAddress:add];

    ShoppingCartModel *cartModel=[ShoppingCartModel sharedInstance];
    cartModel.addressModel=add;
        NSString* addressInfo=[NSString stringWithFormat:@"%@;%@;%@;%@;%@;%ld",add.name,add.phone,add.code,add.city,add.address,0l];
    [HttpHelper sendPostRequest:@"CommerceUserServices/updateAddress"
                    parameters: @{@"address":addressInfo}
                       success:^(id response) {
                           NSDictionary* result=[response jsonString2Dictionary];
                           BOOL success=[result valueForKey:@"success"];
                           if(success){
                             //next
                               
                               NSArray *views=self.navigationController.viewControllers;
                               for (UIViewController *view in views) {
                                   if ([cartModel.route isEqual:@"BalanceController"]) {
                                       if ([view isKindOfClass:[BalanceController class]]) {
                                           BalanceController *alv=view;
                                           [self.navigationController popToViewController:alv animated:YES];
                                           [alv reloadTableView];
                                       }
                                   }
                                   if ([cartModel.route isEqual:@"SWMeTableViewController"]) {
                                       if ([view isKindOfClass:[SWMeTableViewController class]]) {
                                           SWMeTableViewController *alv=view;
                                           [self.navigationController popToViewController:alv animated:YES];
                                       }
                                   }
                               }
                               
                           }
                       }fail:^{
                           NSLog(@"网络异常，取数据异常");
                       } parentView:nil];
}


                    

@end
