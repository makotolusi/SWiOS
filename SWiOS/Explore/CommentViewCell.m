//
//  CommentViewCell.m
//  SWiOS
//
//  Created by 陆思 on 15/11/21.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import "CommentViewCell.h"
#import "UILabel+Extension.h"
@implementation CommentViewCell


- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)layoutSubviews{
    
    YCAsyncImageView* img=[[YCAsyncImageView alloc] initWithFrame:CGRectMake(5,5, 30, 30)];
    img.layer.cornerRadius=15.0;
    [img setUrl:self.commentM.userHeadPortraitUrl];
    // Initialization code
    _commentLabel=[[UILabel alloc] init];
    self.commentLabel.numberOfLines = 100;
    _commentLabel.font=[UIFont systemFontOfSize:12];
    self.commentLabel.text=self.commentM.comments;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:_commentLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    _commentLabelSize = [self.commentM.comments boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    _commentLabel.frame=CGRectMake(_username.frame.origin.x, _username.frame.origin.y+25, SCREEN_WIDTH-img.frame.size.width-30, _commentLabelSize.height);
    self.username.text=self.commentM.userName;
//    self.headImage.backgroundColor=[UIColor darkGrayColor];
    
//    UIImageView* img=[[UIImageView alloc] initWithFrame:CGRectMake(10,10, 40, 40)];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7xjop8.com1.z0.glb.clouddn.com/test/018601.jpg?e=1448277840&token=qgiltCsc4CE2SZsRcbDocNcXuY556nowi3SyV-CB:7PDae4AursGwYeLYnnqM_99iI7M="]];
//    img.image=[UIImage imageWithData:data];
    
//    [self.imgUrl setUrl:@"http://7xjop8.com1.z0.glb.clouddn.com/test/018601.jpg?e=1448277840&token=qgiltCsc4CE2SZsRcbDocNcXuY556nowi3SyV-CB:7PDae4AursGwYeLYnnqM_99iI7M="];
//    self.imgUrl=img;
    [self addSubview:img];
    [self addSubview:_commentLabel];
//    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, 100);
}


-(void)commentHeight:(NSString*)fullDescAndTagStr{
    

}
@end
