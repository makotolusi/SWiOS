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
#import "MobClick.h"
int kMaxCellCount=2;
@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PWLoadMoreTableFooterDelegate>

@end
static int inputViewHeight=40;
static int sendWidth=50;
static int gap=5;
@implementation CommentViewController
{
    int cellCount;
    int page;
}
-(void)viewDidAppear:(BOOL)animated{
     self.view.backgroundColor=[UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=[[NSMutableArray alloc] init];
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _tableView.backgroundColor=[UIColor blueColor];
    page=1;
    [self getData:^(){
        [self _loadView];
    }];
}
-(void)initView{

}
-(void)getData:(void (^)())handle{
    [CommentRequest listComment:self.productCode page:page next:^(NSDictionary* items){
        
        NSMutableArray *arr=items[@"data"];
        NSString* totalCount=items[@"totalCount"];
        NSString* pageCount=items[@"pageCount"];
        kMaxCellCount=totalCount.intValue;
        for (NSDictionary* dic in arr) {
            CommentModel *comment=[[CommentModel alloc] init];
            [comment initWithDictionary:dic error:nil];
            [_data addObject:comment];
        }
        cellCount=cellCount+[arr count];
        handle();
    }];
}

-(void)_loadView{
    _tableView.contentInset = UIEdgeInsetsMake(64.f, 0.f, 49.f, 0.f);
    //config the load more view
    if (_loadMoreFooterView == nil) {
        
        PWLoadMoreTableFooterView *view = [[PWLoadMoreTableFooterView alloc] init];
        view.delegate = self;
        _loadMoreFooterView = view;
        
    }
    _tableView.tableFooterView = _loadMoreFooterView;
    
    //*****IMPORTANT*****
    //you need to do this when you first load your data
    //need to check whether the data has all loaded
    //Get the data first time
    [self check];
    //tell the load more view: I have load the data.
    [self doneLoadingTableViewData];
    //*****IMPORTANT*****
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    //    _tableView.rowHeight = 100;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [_tableView registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:nil] forCellReuseIdentifier:@"commentCellIdentifier"];
    
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
    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [MobClick event:@"commentExploreProduct" attributes:@{@"productCode" : self.productCode,@"userId":[NSString stringWithFormat:@"%d",comment2.userId] }];
    [CommentRequest addComment:comment2 next:^(void){
    _textView.text=@"";
        [self refreshTable];
        [self getData:^(){
           
             [self check];
            //*****IMPORTANT*****
            //you need to do this when you first load your data
            //need to check whether the data has all loaded
            //Get the data first time
            [self check];
            //tell the load more view: I have load the data.
            [self doneLoadingTableViewData];
            //*****IMPORTANT*****
            [_tableView reloadData];
           
        }];
    }];
}

-(void)refreshTable{
    kMaxCellCount=0;
    page=1;
    cellCount=0;
    [_data removeAllObjects];
  
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
    return _commentLabelSize.height+45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
    CommentViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"lusi"];
    if (cell == nil) {
        cell = [[CommentViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.commentM=_data[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//        cell.commentLabelSize.frame=CGRectMake(cell.comment.frame.origin.x, cell.comment.frame.origin.y, cell.commentLabelSize.width, cell.commentLabelSize.height);
//    cell.textLabel.text= @"abc";
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)check {
    //data source should call this when it can load more
    //when all items loaded, set this to YES;
    if (cellCount >= kMaxCellCount) {               // kMaxCellCount is only demo purpose
        _allLoaded = YES;
    } else
        _allLoaded = NO;
}

- (void)doneLoadingTableViewData {
    //  model should call this when its done loading
    [_loadMoreFooterView pwLoadMoreTableDataSourceDidFinishedLoading];
    [_tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)demoOnly {
    _datasourceIsLoading = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)refresh {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _datasourceIsLoading = YES;
//    cellCount = 1;
//    [_tableView reloadData];
    [self refreshTable];
    [self getData:^(){
        [self check];
        [_tableView reloadData];
        [self performSelector:@selector(demoOnly) withObject:nil afterDelay:0.0];
    }];
    [_loadMoreFooterView resetLoadMore];
    
//    //demo Only, fake it's still loading
//    [self performSelector:@selector(demoOnly) withObject:nil afterDelay:5.0];
}

#pragma mark -
#pragma mark PWLoadMoreTableFooterDelegate Methods

- (void)pwLoadMore {
    //just make sure when loading more, DO NOT try to refresh your data
    //Especially when you do your work asynchronously
    //Unless you are pretty sure what you are doing
    //When you are refreshing your data, you will not be able to load more if you have pwLoadMoreTableDataSourceIsLoading and config it right
    //disable the navigationItem is only demo purpose
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _datasourceIsLoading = YES;
//    ++cellCount;
    ++page;
    [self getData:^(){
                [self check];
                [_tableView reloadData];
        _datasourceIsLoading = NO;
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
            }];
    
}


- (BOOL)pwLoadMoreTableDataSourceIsLoading {
    return _datasourceIsLoading;
}
- (BOOL)pwLoadMoreTableDataSourceAllLoaded {
    return _allLoaded;
}

@end
