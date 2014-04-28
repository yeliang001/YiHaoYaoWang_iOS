//
//  OTSProductCommentViewTableCell.m
//  TheStoreApp
//
//  Created by towne on 13-3-25.
//
//
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "OTSProductCommentTableCellV2.h"

@implementation OTSProductCommentTableCellV2
@synthesize commentScoreLbl;
//@synthesize lineImgColumView;
@synthesize contentLabel;
@synthesize commentDateLbl;
@synthesize commentUserLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        //评分
        self.commentScoreLbl=[[[UILabel alloc]initWithFrame:
                               CGRectMake(10,14,37,14)]autorelease];
        commentScoreLbl.text=@"评分:";
        commentScoreLbl.textColor = [UIColor grayColor];
        commentScoreLbl.font=[UIFont systemFontOfSize:13.0];
        [commentScoreLbl setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:commentScoreLbl];
        
        
        //评论内容
        self.contentLabel=[[[UILabel alloc] init] autorelease];
        contentLabel.font=[UIFont systemFontOfSize:13.0];
        contentLabel.lineBreakMode=UILineBreakModeWordWrap;
        contentLabel.numberOfLines=0;
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:contentLabel];
        
        //评论用户及日期
        
        //虚线
//        lineImgColumView=[[[UIImageView alloc]initWithFrame:
//                           CGRectMake(10,216+contentLabel.frame.size.height+16,300,1)] autorelease];
//        lineImgColumView.image = [UIImage imageNamed:@"dottedline.png"];
//        [self.contentView addSubview:lineImgColumView];
        
        
        //显示评论的用户名label
        self.commentUserLbl=[[[UILabel alloc]initWithFrame:
                              CGRectMake(10,65,100,18)] autorelease];
        commentUserLbl.font=[UIFont systemFontOfSize:13.0];
        commentUserLbl.textColor = [UIColor grayColor];
        [commentUserLbl setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:commentUserLbl];
        
        //显示评论日期label
        self.commentDateLbl =[[UILabel alloc]initWithFrame:
                              CGRectMake(60,64,68,18)];
        commentDateLbl.font=[UIFont systemFontOfSize:13.0];
        commentDateLbl.textColor = [UIColor grayColor];
        [commentDateLbl setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:commentDateLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    // Initialization code
    
}

- (void)updateWithProductExperienceVO:(ProductExperienceVO *)experienceVO
{
    experienceVO  = [[ProductExperienceVO alloc] init];
    experienceVO.ratingLog = [NSNumber numberWithInt:4];
    experienceVO.content = @"可以从500兆赫兹到10千兆赫之间的电视台、广播电台和手机基站获取各种无线电波信号。";
    experienceVO.userName = @"汤琦";
    experienceVO.createtime = [[NSDate alloc]init];
    //评论五角星的星级个数
    int iStarNum=[experienceVO.ratingLog intValue];
    for(int i=0;i<5;i++){
        UIImageView * starImgView=[[UIImageView alloc]initWithFrame:
                                   CGRectMake(48+18*i,10,17,17)];			//五角星
        if(i<iStarNum){
            starImgView.image = [UIImage imageNamed:@"comment_Yellow@2x.png"];
        }
        else{
            starImgView.image = [UIImage imageNamed:@"comment_Gray@2x.png"];
        }
        [self.contentView addSubview:starImgView];
        [starImgView release];
    }
    
    //总结内容标签
    contentLabel.text=experienceVO.content;
    CGSize contentLblSize = [experienceVO.content sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    if (contentLblSize.width > 236 )  {
        int labelRowCount = ceil(contentLblSize.width/236.0);
        //至少是2
        [contentLabel setFrame:CGRectMake(10,26,300,15*labelRowCount)];
    } else {
        [contentLabel setFrame:CGRectMake(10,26,300,15)];
    }
    
    //评论用户名字符串
    NSString * userNameStr;
    if(experienceVO.userName==nil){
        userNameStr=@"";
    }
    else if([experienceVO.userName rangeOfString:@"@"].length!=0){
        userNameStr=[NSString stringWithString:[experienceVO.userName
                                                substringToIndex:[experienceVO.userName rangeOfString:@"@"].location]];
    }
    else{
        userNameStr=[NSString stringWithString:experienceVO.userName];
    }
    if([userNameStr length]>16){
        userNameStr=[userNameStr substringToIndex:15];
    }
    commentUserLbl.text = userNameStr;
    
    NSString * dateStr=[[NSString alloc]initWithString:[[experienceVO.createtime description] substringToIndex:[[experienceVO.createtime description] rangeOfString:@" "].location]];
    commentDateLbl.text  =dateStr;
}

- (void)dealloc
{
    OTS_SAFE_RELEASE(commentScoreLbl);
//    OTS_SAFE_RELEASE(lineImgColumView);
    OTS_SAFE_RELEASE(contentLabel);
    OTS_SAFE_RELEASE(commentUserLbl);
    OTS_SAFE_RELEASE(commentDateLbl);
    
    [super dealloc];
}

@end
