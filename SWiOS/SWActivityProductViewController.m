//
//  SWActivityProductViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "SWActivityProductViewController.h"
#import "HttpHelper.h"
#import "ActivityProduct.h"
#import "ActivityProductCell.h"
#import "SWBuyBuyBuyViewController.h"
#import "JSBadgeView.h"
#import "ShoppingCartController.h"
#import "ShoppingCartModel.h"
#import "UILabel+Extension.h"
#import "DetailPageController.h"
#import "UIAlertView+Extension.h"
#import "ShoppingCartLocalDataManager.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MobClick.h"
#define kCCell_Img			1
#define kCCell_Button		4
static NSString *activityProductCellIdentifier = @"activityProductCellIdentifier";
@interface SWActivityProductViewController ()

@end

@implementation SWActivityProductViewController
-(void)viewWillAppear:(BOOL)animated{
    self.pageName=@"SWActivityProductViewController";
    [super viewDidAppear:animated];
   [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialize];
    
}

-(void)initialize{
       _cartModel=[ShoppingCartModel sharedInstance];
}

-(void)requestData{
    [HttpHelper sendGetRequest:[@"getActivityProcut/" stringByAppendingFormat:@"%@",_activity._id]
                    parameters: @{}
                       success:^(id response) {
                           NSData* data = [response dataUsingEncoding:NSUTF8StringEncoding];
                           //                           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                           NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                           NSLog(@"获取到的数据为dict：%@", _data);
                           // 构造数组(MRC:以下情况会出问题，ARC)
                           _data = [NSMutableArray array];
                           
                           // 设置数据模型
                           for (id content in result) {
                               ActivityProduct *model = [[ActivityProduct alloc] initWithDictionary:content error:nil];
                               model.id=nil;
                               if (model) {
                                    [_data addObject:model];
                               }
                           }
                           [self _loadContentView];
                       } fail:^{
                           NSLog(@"网络异常，取数据异常");
                       } parentView:self.view];

}

- (void)_loadContentView {
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.contentInset = UIEdgeInsetsMake(65.f, 0.f, 50.f, 0.f);
    NSLog(@"%f",_tableView.frame.origin.y);
    _tableView.rowHeight = SCREEN_HEIGHT/5;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityProductCell" bundle:nil] forCellReuseIdentifier:activityProductCellIdentifier];
    [self.view addSubview:_tableView];
    //shopping cart
    UIView  *barView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kSWTabBarViewHeight, SCREEN_WIDTH, kSWTabBarViewHeight)];
    barView.backgroundColor = UIColorFromRGB(0x1abc9c);
//    barView.center = CGPointMake(barView.frame.size.width / 2,SCREEN_HEIGHT - kSWTabBarViewHeight / 2);
    //cart home image view
    bottomImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    bottomImageView.image=[UIImage imageNamed:@"fish"];
    
    [barView addSubview:bottomImageView];
    //price label
    priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(bottomImageView.frame.size.width+20, barView.frame.size.height/2-15, 200, 30)];
    priceLabel.textColor=[UIColor whiteColor];
    priceLabel.text=[@"¥ " stringByAppendingFormat:@"%@",_cartModel.orderModel.totalPrice];
    priceLabel.font=[UIFont boldSystemFontOfSize:20];
    [barView addSubview:priceLabel];
    //buy label
    bottomLabel=[[UIButton alloc] initWithFrame:CGRectMake(barView.frame.size.width-80, barView.frame.size.height/2-15, 65, 30)];
    [bottomLabel setTitle:@"请选购" forState:UIControlStateNormal];
//    [bottomLabel setTitle:@"去结算" forState:UIControlStateSelected];
    bottomLabel.backgroundColor=UIColorFromRGB(0x1abc9c);
    bottomLabel.layer.masksToBounds=YES;
    bottomLabel.layer.cornerRadius=6;
    bottomLabel.layer.borderWidth=2;
    bottomLabel.layer.borderColor=[[UIColor whiteColor] CGColor];
    [bottomLabel addTarget:self action:@selector(bottomLabelClick) forControlEvents:UIControlEventTouchUpInside];
    if(_cartModel.arOfWatchesOfCart.count>0){
        [bottomLabel setTitle:@"去结算" forState:UIControlStateNormal];
    }else{
         [bottomLabel setTitle:@"请选购" forState:UIControlStateNormal];
    }
    [barView addSubview:bottomLabel];
    
    if(_cartModel.orderModel.totalCount>0){
        //badgeView
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:bottomImageView alignment:JSBadgeViewAlignmentBuyBuyBuy];
        badgeView.badgeText = [NSString stringWithFormat:@"%ld", (long) _cartModel.orderModel.totalCount];
    }
    [self.view addSubview:barView];
//    [self.view insertSubview:barView atIndex:[self.view.subviews count]];
//    [self.view bringSubviewToFront:barView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    ActivityProductCell *cell=[tableView dequeueReusableCellWithIdentifier:activityProductCellIdentifier forIndexPath:indexPath ];
    UIButton *btn = (UIButton*)[cell viewWithTag:kCCell_Button];
    [btn addTarget:self action:@selector(CartTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.activityProduct=_data[indexPath.row];
    btn.selected=[[_cartModel.productCode_buyCount allKeys] containsObject:cell.activityProduct.productCode];
    [btn setTitle:[NSString stringWithFormat:@"%li",(long)indexPath.row] forState:UIControlStateDisabled];
    NSString *key=[NSString stringWithFormat:@"%@_%@",cell.activityProduct.activityId,cell.activityProduct.productCode];
    if ([_cartModel.arOfWatchesOfCart containsObject:cell.activityProduct]) {
        btn.selected=YES;
    }else {
        btn.selected=NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 图片
    DetailPageController *thumbViewController = [[DetailPageController alloc] init];
    ActivityProduct *product=_data[indexPath.row];
    thumbViewController.product=product;
    //back button style
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [self.navigationController pushViewController:thumbViewController animated:YES];
    
    [MobClick event:@"clickActivityProduct" attributes:@{@"name" : product.productName, @"productCode" : product.productCode, @"price" : product.rushPrice}];
}

- (void)CartTapped:(UIButton*)sender {
     NSUInteger index = [[sender titleForState:UIControlStateDisabled] integerValue];
    ActivityProduct *model = _data[index];
    // create indexpath
    NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
    BOOL sta=YES;
    // perform action
    if(sender.selected) {
        // remove selected array
        sta=[ShoppingCartModel removeCartWithProduct:model];
        if (sta) {
            // update badge number
            [self reloadBadgeNumber];
        }
       
    } else {
        sta=[ShoppingCartModel add2CartWithProduct:model buyCount:1];
        if (sta) {
            // perform add to cart animation
            [self addToCartTapped:ip url:model.picUrl1];
            [MobClick event:@"addProduct2cart" attributes:@{@"name" : model.productName, @"productCode" : model.productCode, @"price" : model.rushPrice}];
        }
    }
    if (sta) {
        //badgeView
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:bottomImageView alignment:JSBadgeViewAlignmentBuyBuyBuy];
        badgeView.badgeText = [NSString stringWithFormat:@"%ld",(long)_cartModel.orderModel.totalCount];
        priceLabel.text=[@"¥ " stringByAppendingFormat:@"%@",_cartModel.orderModel.totalPrice];
        // reload specific row with animation
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationLeft];
        if(_cartModel.orderModel.totalCount>0){
            [bottomLabel setTitle:@"去结算" forState:UIControlStateNormal];
        }else{
            [bottomLabel setTitle:@"请选购" forState:UIControlStateNormal];
        }
    }
    

}

- (void)addToCartTapped:(NSIndexPath*)indexPath url:(NSString*)url {
    // grab the cell using indexpath
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    // grab the imageview using cell
    UIImageView *imgV = (UIImageView*)[cell viewWithTag:kCCell_Img];
    [imgV setImageWithURL:[NSURL URLWithString:url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    // get the exact location of image
    CGRect rect = [imgV.superview convertRect:imgV.frame fromView:nil];
    rect = CGRectMake(5, (rect.origin.y*-1)-10, imgV.frame.size.width, imgV.frame.size.height);
    NSLog(@"rect is %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    // create new duplicate image
    UIImageView *starView = [[UIImageView alloc] initWithImage:imgV.image];
    [starView setFrame:rect];
    starView.layer.cornerRadius=5;
    starView.layer.borderColor=[[UIColor blackColor]CGColor];
    starView.layer.borderWidth=1;
    [self.view addSubview:starView];
    
    // begin ---- apply position animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration=0.65;
    pathAnimation.delegate=self;
    
    // tab-bar right side item frame-point = end point
    CGPoint endPoint = CGPointMake(90+rect.size.width/2, 520+rect.size.height/2);
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, starView.frame.origin.x, starView.frame.origin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, starView.frame.origin.y, endPoint.x, starView.frame.origin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    // end ---- apply position animation
    
    // apply transform animation
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"transform"];
    [basic setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.25, 0.25, 0.25)]];
    [basic setAutoreverses:NO];
    [basic setDuration:0.65];
    
    [starView.layer addAnimation:pathAnimation forKey:@"curveAnimation"];
    [starView.layer addAnimation:basic forKey:@"transform"];
    
    [starView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.65];
    [self performSelector:@selector(reloadBadgeNumber) withObject:nil afterDelay:0.65];
}

// update the Badge number
- (void)reloadBadgeNumber {

    if(_cartModel.arOfWatchesOfCart.count) {
//        self.tabItemCart.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)self.arOfWatchesOfCart.count];
    } else {
//        self.tabItemCart.badgeValue=nil;
    }
}

-(void)bottomLabelClick
{
    ShoppingCartController *vc =[[ShoppingCartController alloc]init];
    vc.fromMain=NO;
    vc.navigationItem.titleView = [UILabel navTitleLabel:@"购物车"];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [self.navigationController pushViewController:vc animated:YES];
//    [_tableView reloadData];
}



@end
