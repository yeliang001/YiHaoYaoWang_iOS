//
//  HomePageModelBCell.m
//  TheStoreApp
//
//  Created by yuan jun on 13-1-15.
//
//

#import "HomePageModelBCell.h"
#import "SDImageView+SDWebCache.h"
@implementation HomePageModelBCell
@synthesize adText,advPicUrl;
-(void)dealloc{
    [adText release];
    [advPicUrl release];
    [advLab release];
    [advImg release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImageView* bgImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 188)];
        bgImg.image=[UIImage imageNamed:@"modelBCellBG.png"];
        [self.contentView addSubview:bgImg];
        advImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 290, 140)];
        [bgImg addSubview:advImg];

        advLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 145, 270, 35)];
        advLab.backgroundColor=[UIColor clearColor];
        advLab.font=[UIFont systemFontOfSize:16];
        advLab.textColor=[UIColor blackColor];
        [bgImg addSubview:advLab];
        
        UIImageView* arrow=[[UIImageView alloc] initWithFrame:CGRectMake(300-13-5, 155, 9, 13)];
        arrow.image=[UIImage imageNamed:@"cell_arrow_right.png"];
        [bgImg addSubview:arrow];
        [arrow release];
        [bgImg release];
    }
    return self;
}
-(void)reloadCell{
    [advImg setImageWithURL:[NSURL URLWithString:advPicUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"240x160-holder.png"]];
    advLab.text=adText;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
