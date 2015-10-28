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
#import "UIAlertView+Extension.h"
@interface AddressViewController ()
@property (retain, nonatomic) UITextField *areaText;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (copy, nonatomic) NSString *areaValue;
@property (strong, nonatomic) AddressModel *addressModel;
@end

@implementation AddressViewController

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
    _tableView.rowHeight=40.f;
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
            [_areaText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
            [cell addSubview:_areaText];
            break;
        case 4:
            [cell addSubview:[self textView:_addressModel.address]];
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
        _placeholderLabel.font=[UIFont systemFontOfSize:13];
        _placeholderLabel.text=@"详细地址";
        
        [textView addSubview:_placeholderLabel];
    }
    textView.tag=15;
    textView.text=text;
    textView.delegate=self;
    return textView;
}
-(UITextField*)input:(NSString*)placeholderText tag:(NSInteger) tag text:(NSString*)text {
    UITextField* input=[[UITextField alloc] initWithFrame:CGRectMake(5, 0, 200, _tableView.rowHeight)];
    input.placeholder=placeholderText;
    input.tag=tag;
    input.text=text;
    [input setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    return input;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        _placeholderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        _placeholderLabel.hidden = NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
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
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        //        _locatePicker.frame=CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 100);
        [self.locatePicker showInView:self.view];
        //        [self.view addSubview:_locatePicker];
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
    UIAlertView *alert=[[UIAlertView alloc] init];
    AddressModel *add=[[AddressModel alloc] init];
    add.AddressModelID=_addressModel.AddressModelID;
    UITextField *nameTf=[self.view viewWithTag:11];
    NSString *name=nameTf.text;
    if(StringIsNullOrEmpty(name)){
        [alert showMessage:@"请输入收货人姓名"];
        return;
    }
    [add setValue:name forKey:@"name"];
    
    UITextField *phoneTf=[self.view viewWithTag:12];
    NSString *phone=phoneTf.text;
    if (StringIsNullOrEmpty(phone)) {
        [alert showMessage:@"请输入电话号码"];
    }
    [add setValue:phone forKey:@"phone"];
    
    UITextField *codeTf=[self.view viewWithTag:13];
    NSString *code=codeTf.text;
    if (StringIsNullOrEmpty(code)) {
        [alert showMessage:@"请输入邮政编码"];
    }
    [add setValue:code forKey:@"code"];
    
    UITextField *cityTf=[self.view viewWithTag:14];
    NSString *city=cityTf.text;
    if (StringIsNullOrEmpty(city)) {
        [alert showMessage:@"请选择区域信息"];
    }
    [add setValue:city forKey:@"city"];
    
    UITextView *addressTf=[self.view viewWithTag:15];
    NSString *address=addressTf.text;
    if (StringIsNullOrEmpty(address)) {
        [alert showMessage:@"请输入地址详细信息"];
    }
    [add setValue:address  forKey:@"address"];
    add.mts=[[NSDate date] timeIntervalSince1970];
    [_databaseManager insertAddress:add];

    ShoppingCartModel *cartModel=[ShoppingCartModel sharedInstance];
    cartModel.addressModel=add;
    NSArray *views=self.navigationController.viewControllers;
    for (UIViewController *view in views) {
        if ([view isKindOfClass:[AddressListViewController class]]) {
            AddressListViewController *alv=view;
            [self.navigationController popViewControllerAnimated:YES];
            [alv reloadTableView];
        }
    }
     [self.navigationController popViewControllerAnimated:YES];
}


                    

@end
