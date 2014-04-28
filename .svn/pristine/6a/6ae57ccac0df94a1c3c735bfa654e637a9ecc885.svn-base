//
//  OTSAdModelAView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define TABLEVIEW_MARGIN    14

#import "OTSAdModelAView.h"
#import "AdvertisingPromotionVO.h"
#import "OTSUtility.h"
#import "HotPointNewVO.h"
#import "DataController.h"
#import "NSString+MD5Addition.h"
#import "OTSImageView.h"
#import "SDImageView+SDWebCache.h"
@implementation OTSAdModelAView

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate tag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_Delegate=delegate;
        [self setTag:tag];
        //table view
        m_TableView=[[UITableView alloc] initWithFrame:CGRectMake(TABLEVIEW_MARGIN, 0, frame.size.width-TABLEVIEW_MARGIN*2, 50) style:UITableViewStylePlain];
        [m_TableView.layer setBorderWidth:1.0];
        [m_TableView.layer setBorderColor:[[UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1.0] CGColor]];
        [m_TableView setDelegate:self];
        [m_TableView setDataSource:self];
        [m_TableView setScrollsToTop:NO];
        [m_TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:m_TableView];
        [m_TableView setHidden:YES];
        //image view
        m_ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 50)];
        [self addSubview:m_ImageView];
        [m_ImageView setHidden:YES];
        
        [self reloadModelAView];
    }
    return self;
}

-(void)reloadModelAView
{
    if ([m_Delegate respondsToSelector:@selector(adModelAViewData:)]) {
        if (m_AdVO!=nil) {
            [m_AdVO release];
        }
        m_AdVO=[[m_Delegate adModelAViewData:self] retain];
    } else {
        return;
    }
    //table view
    CGFloat yValue=0.0;
    int adCount=[[m_AdVO hotPointNewVOList] count];
    if (adCount<=0) {
        return;
    }
    CGFloat height=211.0+50.0*(adCount-1);
    [m_TableView setFrame:CGRectMake(TABLEVIEW_MARGIN, yValue, self.frame.size.width-TABLEVIEW_MARGIN*2, height)];
    [m_TableView reloadData];
    [m_TableView setHidden:NO];
    yValue+=height;
    //image view
    if ([[m_AdVO advertisingType] intValue]==LEFT_TYPE) {//左模块
        [m_ImageView setFrame:CGRectMake(0, yValue, 320, LEFT_TYPE_IMAGE_HEIGHT)];
        [m_ImageView setImage:[UIImage imageNamed:@"tempB_end.png"]];
        [m_ImageView setHidden:NO];
    } else if ([[m_AdVO advertisingType] intValue]==RIGHT_TYPE) {
        [m_ImageView setFrame:CGRectMake(0, yValue, 320, RIGHT_TYPE_IMAGE_HEIGHT)];
        [m_ImageView setImage:[UIImage imageNamed:@"tempA_end.png"]];
        [m_ImageView setHidden:NO];
    } else {
        [m_ImageView setHidden:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//关键字按钮
-(void)keyWordClicked:(id)sender
{
    if ([m_Delegate respondsToSelector:@selector(adModelAView:keyWordBtnClicked:)]) {
        [m_Delegate adModelAView:self keyWordBtnClicked:sender];
    }
}

//大图
-(void)bigImageClicked:(id)sender
{
    if ([m_Delegate respondsToSelector:@selector(adModelAView:bigImageBtnClicked:)]) {
        [m_Delegate adModelAView:self bigImageBtnClicked:sender];
    }
}

#pragma mark tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    if ([indexPath row]==0) {
    } else {
        if ([m_Delegate respondsToSelector:@selector(adModelAView:didSelectRowAtIndexPath:)]) {
            [m_Delegate adModelAView:self didSelectRowAtIndexPath:indexPath];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[m_AdVO hotPointNewVOList] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0]];
    if ([indexPath row]==0) {
        UIImage *bgImage = nil;
        NSMutableArray *keywordImgArray = nil;
        CGFloat keywordX = 0.f;
        CGFloat bigImgX;
        if ([[m_AdVO advertisingType] intValue]==LEFT_TYPE) {//左类型
            bgImage=[UIImage imageNamed:@"tempB.png"];
            keywordImgArray=[[NSMutableArray alloc] initWithObjects:@"tempB_First.png", @"tempB_Second.png", @"tempB_Third.png", @"tempB_Fourth.png", nil];
            keywordX=190.0;
            bigImgX=14.0;
        } else if ([[m_AdVO advertisingType] intValue]==RIGHT_TYPE) {//右类型
            bgImage=[UIImage imageNamed:@"tempA.png"];
            keywordImgArray=[[NSMutableArray alloc] initWithObjects:@"tempA_First.png", @"tempA_Second.png", @"tempA_Third.png", @"tempA_Fourth.png", nil];
            keywordX=14.0;
            bigImgX=103.0;
        }
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 268, 179)];
        [imageView setImage:bgImage];
        [cell addSubview:imageView];
        [imageView release];
        //关键字
        CGFloat yValue=22.0;
        int i;
        //为了保险起见，还是写死为四条关键字,原来为[[m_AdVO keywordList] count]
        for (i=0; i<4; i++) {
            NSString *keyword= [OTSUtility safeObjectAtIndex:i inArray:[m_AdVO keywordList]];
            UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(keywordX, yValue, 89, 44)];
            [button setTitle:keyword forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
            NSString *imageName=[OTSUtility safeObjectAtIndex:i inArray:keywordImgArray];
            [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(keyWordClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            [button release];
            yValue+=44.0;
        }
        
        //大图
        HotPointNewVO *hotPointVO=[OTSUtility safeObjectAtIndex:0 inArray:[m_AdVO hotPointNewVOList]];
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 176, 176)];
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(bigImgX, 22, 176, 176)];
        [img setImageWithURL:[NSURL URLWithString:[hotPointVO logoPicUrl]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"defaultimg85.png"]];
        img.userInteractionEnabled=YES;

        [button addTarget:self action:@selector(bigImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [img addSubview:button];
        [cell addSubview:img];
        [button release];
        [img release];

        [keywordImgArray release];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
    } else {
        HotPointNewVO *hotPointVO=[OTSUtility safeObjectAtIndex:[indexPath row] inArray:[m_AdVO hotPointNewVOList]];
        //小图
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 30, 30)];
//        NSString *fileName=[[hotPointVO logoPicUrl] stringFromMD5];
        [imageView setImageWithURL:[NSURL URLWithString:[hotPointVO logoPicUrl]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"defaultimg55.png"]];
//        NSData *data=[DataController applicationDataFromFile:fileName];
//        UIImage *image;
//        if (data!=nil) {
//            image=[UIImage imageWithData:data];
//        } else {
//            NSData *netData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[hotPointVO logoPicUrl]]];
//            if (netData!=nil) {
//                image=[UIImage imageWithData:netData];
//                [DataController writeApplicationData:netData name:fileName];
//            } else {
//                image=[UIImage imageNamed:@"defaultimg55.png"];
//            }
//        }
//        [imageView setImage:image];
        [cell addSubview:imageView];
        [imageView release];
        //名称
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 230, 50)];
        [label setText:[hotPointVO title]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //虚线
    CGFloat yValue;
    if ([indexPath row]==0) {
        yValue=211.0;
    } else {
        yValue=50.0;
    }
    UIImageView *line=[[UIImageView alloc] initWithFrame:CGRectMake(1, yValue-1, 290, 1)];
    [line setImage:[UIImage imageNamed:@"dot_line.png"]];
    [cell addSubview:line];
    [line release];
    
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row]==0) {
        return 211.0;
    } else {
        return 50.0;
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_TableView);
    OTS_SAFE_RELEASE(m_ImageView);
    OTS_SAFE_RELEASE(m_AdVO);
    [super dealloc];
}

@end
