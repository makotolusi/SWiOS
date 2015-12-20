//
//  SWExplorePieceCell.m
//  SWiOS
//
//  Created by YuchenZhang on 7/26/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWExplorePieceCell.h"
#import "CommentViewController.h"
#import "UILabel+Extension.h"
#import "ZanRequest.h"
#import "ShoppingCartModel.h"
#import "SWExploreFlatCell2ValueObject.h"
#import "UIWindow+Extension.h"
const CGFloat kSWPieceCellHeight = 120;


@interface SWExplorePieceView : UIView

@property (nonatomic, strong) YCAsyncImageView *bigImageView;

@property (nonatomic, strong) YCAsyncImageView *tinyImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *priceLabel;


@property (nonatomic, weak) SWExploreFlatCellValueObject *refVO;

- (void)updateUIWithVO:(SWExploreFlatCellValueObject *)vo;

@end

@implementation SWExplorePieceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    
    CGFloat imageWidth = [self properImageHeight];
    self.bigImageView = [[YCAsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageWidth, self.frame.size.width, self.frame.size.height - imageWidth)];
    
    self.titleLabel.text = @"fuck";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self addSubview:_bigImageView];
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews
{
    CGFloat midX = (int)self.frame.size.width >> 1;
    // center alignment
    self.bigImageView.center = CGPointMake(midX,
                                           self.bigImageView.center.y);
    
    self.titleLabel.center = CGPointMake(midX,
                                         self.frame.size.height - ((int)self.titleLabel.frame.size.height >> 1));
}

- (CGFloat)properImageHeight
{
    CGFloat properHeight = 0;
    
    properHeight = roundf(self.frame.size.height * 0.9);
    
    return properHeight;
}

- (void)updateUIWithVO:(SWExploreFlatCellValueObject *)vo
{

    
    [_bigImageView setUrl:vo.imageUrl];
    
    _titleLabel.text = vo.title;
    
    return;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (self.bigImageView.image) {
            return ;
        }
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:vo.imageUrl]];
        
        if (imageData == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
           self.bigImageView.image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        });
    });
}


@end



@interface SWExplorePieceCell ()

@property (nonatomic, strong) SWExplorePieceView *leftPieceView;

@property (nonatomic, strong) SWExplorePieceView *rightPieceView;

@property (nonatomic, weak) SWExploreFlatCellValueObject *refVO;

@end


static CGFloat kSWHorizontalPadding = 10;
static CGFloat kSWItemCountPerRow = 2;

@implementation SWExplorePieceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kSWPieceCellHeight);
        [self _initialize];
    }
    
    return self;
}

- (void)_initialize
{
    
    CGFloat pieceWidth = roundf((SCREEN_WIDTH - kSWHorizontalPadding * (kSWItemCountPerRow + 1)) /kSWItemCountPerRow);
    
    self.leftPieceView = [[SWExplorePieceView alloc] initWithFrame:CGRectMake(kSWHorizontalPadding, 0, pieceWidth, kSWPieceCellHeight)];
    _leftPieceView.hidden = YES;
    
    self.rightPieceView = [[SWExplorePieceView alloc] initWithFrame:CGRectMake(_leftPieceView.frame.size.width + kSWHorizontalPadding * 2, 0, pieceWidth, kSWPieceCellHeight)];
    
    _rightPieceView.hidden = YES;
    
    [self.contentView addSubview:_leftPieceView];
    
    [self.contentView addSubview:_rightPieceView];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUIWithVOs:(NSArray *)items
{
    
    _leftPieceView.hidden = NO;
    _rightPieceView.hidden = items.count < 2;
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [_leftPieceView updateUIWithVO:obj];
        } else {
            [_rightPieceView updateUIWithVO:obj];
        }
    }];
}


@end



const CGFloat kSWPieceCellRbHeight = 559;

@interface SWExplorePieceCell2 ()


@end
/// 抄袭小红书的样式
@implementation SWExplorePieceCell2


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellVO:(SWExploreFlatCell2ValueObject*) cellVO
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.cellVo=cellVO;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kSWPieceCellRbHeight);
        [self _initialize];
    }
    
    return self;
}

- (void)_initialize
{
    CGFloat offsetY = 0;
    CGFloat leftPadding = 10;
    const CGFloat headerHeight = 62;
    const CGFloat bigImageHeight = 375;
    const CGFloat descHeight = 75;
    const CGFloat bottomToolbarHeight = 37;
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  offsetY,
                                                                  SCREEN_WIDTH, headerHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _leftUpSideContryImageView = [[YCAsyncImageView alloc] initWithFrame:CGRectMake(leftPadding, (headerHeight - 40) / 2, 40, 40)];
//    [_leftUpSideContryImageView setUrl:@"http://img.xiaohongshu.com/avatar/555c3ed9b4c4d635bd3e66e9.jpg@120w_120h_92q_1e_1c_1x.jpg?wm=80&hm=80&q=92"];
    _leftUpSideContryImageView.clipsToBounds = YES;
    _leftUpSideContryImageView.layer.cornerRadius = 40 / 2;
    [headerView addSubview:_leftUpSideContryImageView];
    
    CGFloat labelWidth = headerView.frame.size.width - (_leftUpSideContryImageView.frame.origin.x + _leftUpSideContryImageView.frame.size.width) * 2;
    _itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, labelWidth, headerHeight)];
    _itemNameLabel.textColor = [UIColor blackColor];
    _itemNameLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [headerView addSubview:_itemNameLabel];
    
    
    [self.contentView addSubview:headerView];
    
    
    
    offsetY += headerHeight;
    
    UIView *hdImageView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, SCREEN_WIDTH)];
    _bigImageView = [[YCAsyncImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _bigImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageTapped:)];
    [_bigImageView addGestureRecognizer:tap];
    
    [hdImageView addSubview:_bigImageView];
    
    [self.contentView addSubview:hdImageView];
    
    offsetY += bigImageHeight;
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, descHeight + bottomToolbarHeight)];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, 0, SCREEN_WIDTH - leftPadding * 2, descHeight)];
    
    _descLabel.text = @"韩国爱茉莉color lasting tint持久炫彩唇彩 真正的唇膏狂魔绝不会单单喜欢一种唇膏类型，julia最近的心头好是高保湿透明感强的唇彩及唇膏哦[嘿嘿]如果你对亚光、丝绒、唇漆、染唇液等等巨巨巨干的产品都无法接受，那么就试试julia推荐的这款唇彩吧[酷] 1.价格便宜";
    _descLabel.numberOfLines = 3;
    _descLabel.font = [UIFont systemFontOfSize:14.0f];
    [bottomView addSubview:_descLabel];
    
    
    UIView *bottomToolbarView = [self genBottomToolbarWithY:descHeight height:bottomToolbarHeight];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.bounds = CGRectMake(0, 0, _descLabel.bounds.size.width, 0.5f);
    gl.position = CGPointMake(bottomToolbarView.frame.size.width / 2, 0.5f);
    gl.startPoint = CGPointMake(0.0f, 0.5f);
    gl.endPoint = CGPointMake(1.0f, .5f);
    gl.colors = @[(id)[UIColor whiteColor].CGColor,
                  (id)UIColorFromRGB(0xacacac).CGColor,
                  (id)[UIColor whiteColor].CGColor];
    [bottomToolbarView.layer addSublayer:gl];
    
    
    [bottomView addSubview:bottomToolbarView];
    
    [self.contentView addSubview:bottomView];
    
    
}

-(void)layoutSubviews{
    
}
- (UIView *)genBottomToolbarWithY:(CGFloat)y height:(CGFloat)height
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, height)];
    
    NSArray *buttonTitles = @[@"评论",
                              @"次赞",
                              @"收藏"];
    
    
    NSUInteger btnCount = buttonTitles.count;
    int btnWidth = SCREEN_WIDTH / btnCount;
    
    [buttonTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(idx * btnWidth, 0, btnWidth, height);
        [b setTitle:obj forState:UIControlStateNormal];
        [b setTitleColor:UIColorFromRGB(0xacacac) forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [b addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = idx;
        [view addSubview:b];
        if (idx==0) {
            UIImageView* pinglun32=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinglun32"]];
            pinglun32.frame=CGRectMake(b.titleLabel.frame.origin.x-40, b.titleLabel.frame.origin.y-10,20, 20);
            [b addSubview:pinglun32];
        }
        if (idx==1) {
            UIImageView* zan16red=[[UIImageView alloc] initWithImage:[UIImage imageNamed:self.cellVo.isZan==YES?@"zan64red":@"zan-kong"]];
            zan16red.tag=1001;
            zan16red.frame=CGRectMake(b.titleLabel.frame.origin.x-50, b.titleLabel.frame.origin.y-10,20, 20);
            [b setTitle:[NSString stringWithFormat:@"%ld次赞", _cellVo.zans] forState:UIControlStateNormal];
            [b addSubview:zan16red];
        }
        if (idx==2) {
            UIImageView* favorImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:self.cellVo.isFavor==YES?@"yishoucang64":@"shoucang64"]];
            favorImage.tag=1002;
            favorImage.frame=CGRectMake(b.titleLabel.frame.origin.x-50, b.titleLabel.frame.origin.y-10,20, 20);
            [b setTitle:obj forState:UIControlStateNormal];
            [b addSubview:favorImage];
        }
    }];
    
    
    
    return view;
}

- (void)updateUIWithVO:(SWExploreFlatCell2ValueObject *)cellVO
{
    _cellVo=cellVO;
    [_bigImageView setUrl:cellVO.bigImageURL];
    [_leftUpSideContryImageView setUrl:cellVO.leftUpSideContryImagURL];
    _itemNameLabel.text = cellVO.itemName;
    _descLabel.text = cellVO.desc;
      UIImageView* favor=[self viewWithTag:1002];
    favor.image=[UIImage imageNamed:self.cellVo.isFavor==YES?@"yishoucang64":@"shoucang64"];
    
    UIImageView* zan16red=[self viewWithTag:1001];
    zan16red.image=[UIImage imageNamed:self.cellVo.isZan==YES?@"zan64red":@"zan-kong"];
    
    UIButton *b=[self viewWithTag:1];
    NSString* newTitle=[NSString stringWithFormat:@"%ld次赞",_cellVo.zans] ;
    [b setTitle:newTitle forState:UIControlStateNormal];
}

- (void)buttonClicked:(UIButton *)btn
{
    
    // tag idx indicates order:
//    NSArray *buttonTitles = @[@"评论",
//                              @"赞",
//                              @"收藏"]
    
    ShoppingCartModel* cart=[ShoppingCartModel sharedInstance];
    kSWExploreCellClickType type = kSWExploreCellClickTypeBigImage;
    switch (btn.tag) {
        case 0:
        {
            type = kSWExploreCellClickTypeCommnet;
//            UIViewController* u= [[UIViewController alloc] init];
////            CommentViewController *thumbViewController = [[CommentViewController alloc] init];
////
////            thumbViewController.productCode=_cellVo.productCode;
////            //vo
////            thumbViewController.navigationItem.titleView = [UILabel navTitleLabel:@"评论"];
////            //back button style
////            UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
////                                             initWithTitle:@""
////                                             style:UIBarButtonItemStylePlain
////                                             target:self
////                                             action:nil];
////            self.vc.navigationItem.backBarButtonItem = cancelButton;
//            [UIWindow showTabBar:NO];
//            [self.vc.navigationController pushViewController:u animated:YES];
        }
            break;
        case 1:
        {
            type = kSWExploreCellClickTypeLike;
            [ZanRequest addZan:self.cellVo.productCode userId:[NSString stringWithFormat:@"%d",cart.registerModel.id] next:^(){
                UIImageView* zan16red=[self viewWithTag:1001];
                zan16red.image=[UIImage imageNamed:@"zan64red"];
                UIButton *b=[self viewWithTag:btn.tag];
                _cellVo.zans++;
                NSString* newTitle=[NSString stringWithFormat:@"%ld次赞",_cellVo.zans] ;
                [b setTitle:newTitle forState:UIControlStateNormal];
                _cellVo.isZan=YES;
            }];
        }
            break;
        case 2:
        {
            type = kSWExploreCellClickTypeFavourite;
            [ZanRequest addFavor:self.cellVo.productCode userId:[NSString stringWithFormat:@"%d",cart.registerModel.id] next:^(){
                UIImageView* favor=[self viewWithTag:1002];
                favor.image=[UIImage imageNamed:@"yishoucang64"];
                self.cellVo.isFavor=YES;
            }];
        }
            break;
            
        default:
            break;
    }
    
    if (self.cellClickedBlock) {
        self.cellClickedBlock(type, self);
    }
}

- (void)bigImageTapped:(UITapGestureRecognizer *)tap
{
    if (self.cellClickedBlock) {
        self.cellClickedBlock(kSWExploreCellClickTypeBigImage, self);
    }
}

@end










