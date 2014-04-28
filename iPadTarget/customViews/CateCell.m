//
//  CateCell.m
//  yhd
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CateCell.h"
#import "DataHandler.h"
@implementation CateCell
@synthesize cateNameLabel,isEven,cellDelegate,cate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UIButton *cateBut=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [cateBut setBackgroundImage:[UIImage imageNamed:@"6.png"] forState:UIControlStateHighlighted];
        [cateBut addTarget:self action:@selector(cateClick:) forControlEvents:UIControlEventTouchUpInside];
        [cateBut addTarget:self action:@selector(cateClickHighlighted:) forControlEvents:UIControlEventTouchDown];
        [cateBut addTarget:self action:@selector(cateClickOut:) forControlEvents:UIControlEventTouchDragOutside];
        [cateBut setFrame:CGRectMake(0, 0, 236, 59.0)];//
        [self addSubview:cateBut];

        //类别名
        cateNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 10, 170.0, 39.0) ];
        cateNameLabel.textColor =kBlackColor; 
        //cateNameLabel.text=cate.categoryName;
        //cateNameLabel.font=[cateNameLabel.font fontWithSize:14.0];
        cateNameLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:cateNameLabel];
        [cateNameLabel release];
        
//        UIButton *cateBut=[UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [cateBut setBackgroundImage:[UIImage imageNamed:@"6.png"] forState:UIControlStateHighlighted];
//
//        [cateBut setFrame:CGRectMake(0, 0, 236, 59.0)];//
//        [self addSubview:cateBut];
//        [self sendSubviewToBack:cateBut];

    }
    return self;
}
- (void)cateClick:(id)sender{
    cateNameLabel.textColor =kBlackColor;
    [cellDelegate openCateView:cate];
}
- (void)cateClickHighlighted:(id)sender{
    cateNameLabel.textColor =[UIColor whiteColor];
    
}
- (void)cateClickOut:(id)sender{
    cateNameLabel.textColor =kBlackColor;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        cateNameLabel.textColor =[UIColor whiteColor];
//        self.contentView.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0];
//    }else {
//        cateNameLabel.textColor =[UIColor blackColor];
//        if (isEven) {
//            self.contentView.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
//        }else {
//            self.contentView.backgroundColor=[UIColor whiteColor];
//        }
//
//       
//    }
   
}
     - (void)dealloc
    {
        cellDelegate=nil;
#warning 重复使用分类，返回必现crash 暂时屏蔽，开发完成再来细查
 //       [cate release];
        
        [super dealloc];
    }

@end
