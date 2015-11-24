//
//  CommentViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/11/20.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentViewCell.h"
#import "YCAsyncImageView.h"
#import "NSString+Extension.h"
#import "ShoppingCartModel.h"
#import "CommentRequest.h"
@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end
static int inputViewHeight=40;
static int sendWidth=50;
static int gap=5;
@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommentRequest listComment:self.productCode next:^(NSMutableArray* items){
        _data=[[NSMutableArray alloc] initWithArray:items];
        [self _loadView];
    }];

}

-(void)_loadView{
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.contentInset = UIEdgeInsetsMake(64.f, 0.f, 49.f, 0.f);
    //    _tableView.rowHeight = 100;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:nil] forCellReuseIdentifier:@"commentCellIdentifier"];
    
    //text field
    
    _inputView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, inputViewHeight)];
    _inputView.backgroundColor=UIColorFromRGB(0xF5F5F5);
    
    [self registerForKeyboardNotifications];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(gap*2, gap, _inputView.frame.size.width-sendWidth-gap*4, inputViewHeight-gap*2)];
    [_textView becomeFirstResponder];
    _textView.layer.cornerRadius =5.0;
    
    UIButton* send=[[UIButton alloc] initWithFrame:CGRectMake(_textView.frame.size.width+gap*3, gap, sendWidth, inputViewHeight-gap*2)];
    send.backgroundColor=UIColorFromRGB(0x1abc9c);
    send.layer.cornerRadius=5.0;
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [send addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_inputView addSubview:send];
    [_inputView addSubview:_textView];
    [self.view addSubview:_inputView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_tableView addGestureRecognizer:tapGestureRecognizer];
}

- (void)sendAction:(UIButton*)sender {
    if (StringIsNullOrEmpty(_textView.text)) {
        return;
    }
    ShoppingCartModel* cart=[ShoppingCartModel sharedInstance];
    CommentModel* comment2=[[CommentModel alloc] init];
    comment2.comments=_textView.text;
    comment2.userName=cart.registerModel.username;
    comment2.userId=cart.registerModel.id;
    comment2.productCode=self.productCode;
    comment2.userHeadPortraitUrl=cart.registerModel.originalImgUrl;
    [sender setSelected:YES];

    [CommentRequest addComment:comment2 next:^(void){
    _textView.text=@"";
        
        [CommentRequest listComment:self.productCode next:^(NSMutableArray* items){
            _data=[[NSMutableArray alloc] initWithArray:items];
            [_tableView reloadData];
        }];
       
    }];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textView resignFirstResponder];
  
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:0
                     animations:^{
                           _inputView.frame=CGRectMake(0, SCREEN_HEIGHT-inputViewHeight, SCREEN_WIDTH, inputViewHeight);
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _inputView.frame=CGRectMake(0, SCREEN_HEIGHT-keyboardSize.height-inputViewHeight, SCREEN_WIDTH, inputViewHeight);
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 键盘收回事件，UITextField协议方法
 **/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data count];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel* str=_data[indexPath.row];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize _commentLabelSize = [str.comments boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    NSLog(@"%f",_commentLabelSize.height);
    return _commentLabelSize.height+35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"commentCellIdentifier" forIndexPath:indexPath ];
    cell.commentM=_data[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//        cell.commentLabelSize.frame=CGRectMake(cell.comment.frame.origin.x, cell.comment.frame.origin.y, cell.commentLabelSize.width, cell.commentLabelSize.height);
//    cell.textLabel.text= @"abc";
}

@end
