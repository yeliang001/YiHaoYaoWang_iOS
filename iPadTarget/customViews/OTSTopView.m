//
//  OTSTopView.m
//  TheStoreApp
//
//  Created by jiming huang on 12-10-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSTopView.h"
#import "OTSGpsHelper.h"
#import "ProvinceVO.h"
#import "DataHandler.h"

@implementation OTSTopView

-(id)initWithDefaultFrameWithFlag:(int)flag delegate:(id)delegate
{
    self=[self initWithFrame:CGRectMake(0, 0, 1024, 55)];
    if (self!=nil) {
        m_Flag=flag;
        m_Delegate=delegate;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bg.png"]]];
        
        //返回
        UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(16, 6, 50,43)];
        [backBtn setImage:[UIImage imageNamed:@"top_back1.png"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"top_back2.png"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        [backBtn release];
        
        //首页
        UIButton *homepageBtn=[[UIButton alloc] initWithFrame:CGRectMake(80, 6, 50,43)];
        [homepageBtn setImage:[UIImage imageNamed:@"top_main1.png"] forState:UIControlStateNormal];
        [homepageBtn setImage:[UIImage imageNamed:@"top_main2.png"] forState:UIControlStateHighlighted];
        [homepageBtn addTarget:self action:@selector(homepageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:homepageBtn];
        [homepageBtn release];
        
        //个人中心
        UIButton *userBtn=[[UIButton alloc] initWithFrame:CGRectMake(144, 6, 50,43)];
        [userBtn setImage:[UIImage imageNamed:@"top_user1.png"] forState:UIControlStateNormal];
        [userBtn setImage:[UIImage imageNamed:@"top_user2.png"] forState:UIControlStateHighlighted];
        [userBtn addTarget:self action:@selector(userBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:userBtn];
        [userBtn release];
        
        //购物车
        UIButton *cartBtn=[[UIButton alloc] initWithFrame:CGRectMake(208, 6, 50,43)];
        [cartBtn setImage:[UIImage imageNamed:@"top_cart1.png"] forState:UIControlStateNormal];
        [cartBtn setImage:[UIImage imageNamed:@"top_cart2.png"] forState:UIControlStateHighlighted];
        [cartBtn addTarget:self action:@selector(cartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cartBtn];
        [cartBtn release];
        
        //logo
        UIImageView *logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_logo.png"]];
        [logo setFrame:CGRectMake(frame.size.width/2-24, 3, 49, 47)];
        [self addSubview:logo];
        [logo release];
        
        //address
        UIImageView *addressImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_address.png"]];
        [addressImage setFrame:CGRectMake(frame.size.width/2+45,0, 150, 55)];
        [self addSubview:addressImage];
        [addressImage release];
        
        UILabel *addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+75, 30, 70.0, 20)];
        addressLabel.textColor=[UIColor whiteColor];  
        addressLabel.backgroundColor=[UIColor clearColor];
        addressLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        addressLabel.text=[OTSGpsHelper sharedInstance].provinceVO.provinceName;
        [self addSubview:addressLabel];
        [addressLabel release];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProvince:)];
        [addressLabel addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        //搜索
        m_SearchImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_textbg.png"]];
        m_SearchImageView.userInteractionEnabled=YES;
        [m_SearchImageView setFrame:CGRectMake(frame.size.width-236, 10, 210, 33)];
        [self addSubview:m_SearchImageView];
        
        UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(33, 5, 170, 23)];
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        textField.borderStyle=UITextBorderStyleNone;
        textField.placeholder=@"请输入关键词搜索";
        textField.returnKeyType=UIReturnKeySearch;
        textField.enablesReturnKeyAutomatically=YES;
        [textField addTarget:self action:@selector(searchExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [textField addTarget:self action:@selector(searchBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [textField addTarget:self action:@selector(searchChanged:) forControlEvents:UIControlEventEditingChanged];
        [m_SearchImageView addSubview: textField];
        [textField release];
        
        if ([DataHandler sharedDataHandler].keyWord) {
            textField.text=[DataHandler sharedDataHandler].keyWord;
        }
        
        UIButton *searchBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [searchBut setImage:[UIImage imageNamed:@"top_search.png"] forState:UIControlStateNormal];
        [searchBut setImage:[UIImage imageNamed:@"top_search.png"] forState:UIControlStateHighlighted];
        [searchBut setFrame:CGRectMake(10, 8, 18,18)];
        [m_SearchImageView addSubview:searchBut];
    }
    return self;
}

//搜索隐藏或显示
-(void)setSearchHidden:(BOOL)hidden
{
    [m_SearchImageView setHidden:hidden];
}

//返回
-(void)backBtnClicked:(id)sender
{
//    if ([m_Delegate isKindOfClass:[MyListViewController class]]) {
//        [SharedPadDelegate.navigationController popToRootViewControllerAnimated:YES];
//    } else {
//        CATransition *transition = [CATransition animation];
//        transition.duration = OTSP_TRANS_DURATION;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type =kCATransitionFade; //@"cube";
//        transition.subtype = kCATransitionFromRight;
//        transition.delegate = self;
//        [SharedPadDelegate.navigationController.view.layer addAnimation:transition forKey:nil];
//        [SharedPadDelegate.navigationController popViewControllerAnimated:NO];
//    }
}

//首页
-(void)homepageBtnClicked:(id)sender
{
    
}

//个人中心
-(void)userBtnClicked:(id)sender
{
    
}

//购物车
-(void)cartBtnClicked:(id)sender
{
    
}

-(void)searchBegin:(id)sender
{
    
}

-(void)searchExit:(id)sender
{
    
}

-(void)searchChanged:(id)sender
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    [super dealloc];
}

@end
