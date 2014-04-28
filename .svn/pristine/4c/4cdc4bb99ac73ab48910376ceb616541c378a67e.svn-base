//
//  Cate2Cell.m
//  yhd
//
//  Created by  on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Cate2Cell.h"
#import <QuartzCore/QuartzCore.h>
#import "DataHandler.h"
#define kCellButFontname   @"Helvetica"
#define kCellButFontsize  17
@implementation Cate2Cell
@synthesize cellDelegate,cate2,cate3Array,height;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
                      
        UIButton *cateBut=[UIButton buttonWithType:UIButtonTypeCustom];
        cateBut.layer.cornerRadius = 8;
        cateBut.layer.masksToBounds = YES;
        cateBut.titleLabel.lineBreakMode=UILineBreakModeTailTruncation;
         UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        cateBut.titleLabel.font=font;
        cateBut.tag=[cate2.nid intValue];
        cateBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cateBut setTitleColor:kBlackColor forState:UIControlStateNormal];
        [cateBut setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [cateBut setTitle:[@" " stringByAppendingFormat:@"%@",cate2.categoryName] forState:UIControlStateNormal];
        [cateBut setBackgroundImage:[UIImage imageNamed:@"cate_butbg.png"] forState:UIControlStateHighlighted];
        [cateBut addTarget:self action:@selector(cate2Click:) forControlEvents:UIControlEventTouchUpInside];
       
        CGSize size =[[@" " stringByAppendingFormat:@"%@",cate2.categoryName]  sizeWithFont:font constrainedToSize:CGSizeMake(130, 30)];
        [cateBut setFrame:CGRectMake(45, 32, size.width+2, 30.0)];//130
        [self addSubview:cateBut];
        
       
    }
    return self;
}
- (void)cate2Click:(id)sender{
    [cellDelegate openProductList:cate2 cate3:nil];
    [MobClick event:@"show_category"];
}
- (void)cate3Click:(UIButton *)sender{
    [cellDelegate openProductList:cate2 cate3:[cate3Array objectAtIndex:sender.tag]];
    [MobClick event:@"show_category"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
    cellDelegate=nil;
    [cate2 release];
    [cate3Array release];
    [super dealloc];
}

@end
