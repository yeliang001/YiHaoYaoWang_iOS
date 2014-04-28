//
//  OTSProductCommentTopViewV2.m
//  TheStoreApp
//
//  Created by towne on 13-3-25.
//
//
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "OTSProductCommentTopViewV2.h"

@implementation OTSProductCommentTopViewV2

- (id)initWithFrame:(CGRect)frame fromProduct:(ProductVO *)productVO
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf9f9f9);
        // Initialization code
        float gRate=[productVO.rating.goodRating floatValue];
        float mRate=[productVO.rating.middleRating floatValue];
        float bRate=[productVO.rating.badRating floatValue];
        
        if(productVO.rating.top5Experience==nil){
            gRate=0.0;
            mRate=0.0;
            bRate=0.0;
        }
        gResultRate=gRate/(gRate+mRate+bRate)*100;
        mResultRate=mRate/(gRate+mRate+bRate)*100;
        bResultRate=bRate/(gRate+mRate+bRate)*100;
        resultRate=gResultRate;
        
        
        gRLabel = [[UILabel alloc]initWithFrame:CGRectMake(22,50,80,20)];//标签字：“好评”或“中评”或“差评”
        if((gRate==0 && mRate==0 && bRate==0) || productVO.rating.top5Experience==nil){
            gRLabel.text=@"暂无评价";
            [gRLabel setBackgroundColor:[UIColor clearColor]];
        }
        else{
            if(mResultRate>gResultRate && mResultRate>bResultRate){
                resultRate=mResultRate;
                gRLabel.text=@"中评";
            }
            else if(bResultRate>gResultRate && bResultRate>mResultRate){
                resultRate=bResultRate;
                gRLabel.text=@"差评";
            }
            else{
                gRLabel.text=@"好评";
            }
        }
        gRLabel.font=[UIFont systemFontOfSize:16.0];
        gRLabel.backgroundColor = [UIColor clearColor];
        gRLabel.textColor= UIColorFromRGB(0xdc0000);
        [self addSubview:gRLabel];
        [gRLabel release];
        
        gRPercentValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(16,20,80,30)];//评价率的值
        gRPercentValueLabel.font=[UIFont systemFontOfSize:24.0];
        gRPercentValueLabel.backgroundColor = [UIColor clearColor];
        gRPercentValueLabel.textColor=UIColorFromRGB(0xdc0000);
        if(resultRate>=99.95 && productVO.rating.top5Experience!=nil){
            gRPercentValueLabel.text=@"100%";
        }
        else if(resultRate<=0.04 || productVO.rating.top5Experience==nil){
            gRPercentValueLabel.text=@" 0%";
        }
        else{
            gRPercentValueLabel.text=[NSString stringWithFormat:@"%.1f%%",resultRate];
        }
        if(gRate==0 && mRate==0 && bRate==0){
            gRPercentValueLabel.text=@" 0%";
        }
        [self addSubview:gRPercentValueLabel];
        [gRPercentValueLabel release];
        
        UILabel * slashView=[[UILabel alloc]initWithFrame:CGRectMake(110,88,1,81)];//中间的一杠
        slashView.backgroundColor=[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.7];
        [self addSubview:slashView];
        [slashView release];
        
        UIImageView * viewGRate = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_Histogram@2x.png"]];
        
        UILabel *tagGrate = [[UILabel alloc]initWithFrame:CGRectMake(100,85-50*gRate-20,40,20)];
        tagGrate.text = [NSString stringWithFormat:@"%.1f%%",gResultRate];
        tagGrate.font = [UIFont systemFontOfSize:12.0];
        tagGrate.textColor = UIColorFromRGB(0x999999);
        tagGrate.backgroundColor = [UIColor clearColor];
        tagGrate.textAlignment = UITextAlignmentCenter;
        [self addSubview:tagGrate];
        [tagGrate release];
        
        [viewGRate setFrame:CGRectMake(100, 85-50*gRate, 40, 50*gRate)];
        [self addSubview:viewGRate];
        [viewGRate release];
        
        UIImageView * viewMRate = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_Histogram@2x.png"]];
        
        UILabel *tagMrate = [[UILabel alloc]initWithFrame:CGRectMake(180,85-50*mRate-20,40,20)];
        tagMrate.text = [NSString stringWithFormat:@"%.1f%%",mResultRate];
        tagMrate.font = [UIFont systemFontOfSize:12.0];
        tagMrate.textColor = UIColorFromRGB(0x999999);
        tagMrate.backgroundColor = [UIColor clearColor];
        tagMrate.textAlignment = UITextAlignmentCenter;
        [self addSubview:tagMrate];
        [tagMrate release];
        
        [viewMRate setFrame:CGRectMake(180, 85-50*mRate, 40, 50*mRate)];
        [self addSubview:viewMRate];
        [viewMRate release];
        
        UIImageView * viewBRate = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_Histogram@2x.png"]];
        
        UILabel *tagBrate = [[UILabel alloc]initWithFrame:CGRectMake(260,85-50*bRate-20,40,20)];
        tagBrate.text = [NSString stringWithFormat:@"%.1f%%",bResultRate];
        tagBrate.font = [UIFont systemFontOfSize:12.0];
        tagBrate.textColor = UIColorFromRGB(0x999999);
        tagBrate.backgroundColor = [UIColor clearColor];
        tagBrate.textAlignment = UITextAlignmentCenter;
        [self addSubview:tagBrate];
        [tagBrate release];
        
        [viewBRate setFrame:CGRectMake(260, 85-50*bRate, 40, 50*bRate)];
        [self addSubview:viewBRate];
        [viewBRate release];
        
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma mark  OTSProductCommentDelegate
-(void)iCommentRefreshgRPercentValueLabel:(NSNumber *)index;
{
    NSLog(@"refresh XXXXXX %d",[index integerValue]);
    if ([index integerValue] == 0) {
        gRPercentValueLabel.text = [NSString stringWithFormat:@"%.1f%%",resultRate];
        gRLabel.text = @"好评";
        
    }
    if ([index integerValue] == 1) {
        gRPercentValueLabel.text = [NSString stringWithFormat:@"%.1f%%",gResultRate];
        gRLabel.text = @"好评";
    }
    if ([index integerValue] == 2) {
        gRPercentValueLabel.text = [NSString stringWithFormat:@"%.1f%%",mResultRate];
        gRLabel.text = @"中评";
    }
    if ([index integerValue] == 3) {
        gRPercentValueLabel.text = [NSString stringWithFormat:@"%.1f%%",bResultRate];
        gRLabel.text = @"差评";
    }
}

@end
