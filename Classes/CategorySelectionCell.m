//
//  CategorySelectionCell.m
//  TheStoreApp
//
//  Created by jun yuan on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CategorySelectionCell.h"

@implementation CategorySelectionCell
@synthesize  cateNameLab;
@synthesize cateproduct;
-(void)dealloc{
    OTS_SAFE_RELEASE(cateNameLab);
    OTS_SAFE_RELEASE(cateproduct);
    OTS_SAFE_RELEASE(arrowImg);
    OTS_SAFE_RELEASE(nextCateImg);
    OTS_SAFE_RELEASE(upback);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        arrowImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
        arrowImg.image=[UIImage imageNamed:@"cate_selection_arrow.png"];
        [self.contentView addSubview:arrowImg];
        
        nextCateImg =[[UIImageView alloc] initWithFrame:CGRectMake(290, 13, 9, 13)];
        nextCateImg.image = [UIImage imageNamed:@"cell_arrow_right.png"];
        [self.contentView addSubview:nextCateImg];
        
        cateNameLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 40)];
        cateNameLab.backgroundColor=[UIColor clearColor];
        cateNameLab.textColor=[UIColor blackColor];
//        cateNameLab.font=[UIFont boldSystemFontOfSize:16];
//        cateNameLab.font = [UIFont systemFontOfSize:14.0];
        cateNameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [self.contentView addSubview:cateNameLab];
        
//        CGSize titleSize = [cateNameLab.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:CGSizeMake(MAXFLOAT, 0)];

        cateproduct = [[UILabel alloc] init];
//        cateproduct.frame = CGRectMake(30+titleSize.width, 0, 100, 40);
        cateproduct.textColor = [UIColor grayColor];
        cateproduct.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:cateproduct];
        
//        [cell.cateNameLab.layer setPosition:CGPointMake(190, 20)];
        upback =[[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 17, 13)];
        upback.image=[UIImage imageNamed:@"upbackarrow@2x.png"];
        [self.contentView addSubview:upback];
        
        self.backgroundColor=[UIColor whiteColor];
        self.contentView.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
-(void)setShowArrow:(BOOL)_showArrow{
    if (_showArrow) {
        arrowImg.hidden=NO;
    }else {
        arrowImg.hidden=YES;
    }
}

-(void)setShowUpBack:(BOOL)_upback{
    if (_upback) {
        upback.hidden=NO;
        [self.cateNameLab.layer setPosition:CGPointMake(195, 20)];
    }
    else{
        upback.hidden=YES;
        [self.cateNameLab.layer setPosition:CGPointMake(175, 20)];
    }
}


-(void)setShowNextCate:(BOOL)_showNextCate{
    
    nextCateImg.hidden = !_showNextCate;
}

-(void)setShowCatePro:(BOOL)_catepro
{
    if (_catepro) {
        cateproduct.hidden = NO;
    }
    else
    {
        cateproduct.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
