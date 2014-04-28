//
//  QuitOrderPicsVC.m
//  TheStoreApp
//
//  Created by yuan jun on 13-4-12.
//
//

#import "QuitOrderPicsVC.h"
#import "TheStoreAppAppDelegate.h"
@interface QuitOrderPicsVC ()

@end

@implementation QuitOrderPicsVC
-(void)dealloc{
    [btnArray release];
    [picsArray release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        picsArray=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView* nav=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    nav.userInteractionEnabled=YES;
    nav.image=[UIImage imageNamed:@"title_bg.png"];
    [self.view addSubview:nav];
    [nav release];
    //    CGFloat height=0;
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 0, 61, 44);

    [back setTitle:@"取消" forState:UIControlStateNormal];
//    [back setImage:[UIImage imageNamed:@"cameraPhotoLib.png"] forState:UIControlStateNormal];
//    [back setImage:[UIImage imageNamed:@"cameraPhotoLib_sel.png"] forState:UIControlStateHighlighted];
    
    [back addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:back];
    //    UIBarButtonItem*libItm=[[UIBarButtonItem alloc] initWithCustomView:back];
    //    viewController.navigationItem.leftBarButtonItem=libItm;
    //
    //    [libItm release];
    
    UILabel* tit=[[UILabel alloc] initWithFrame:CGRectMake(61, 0, 320-122, 44)];
    tit.text=@"上传图片";
    tit.textAlignment=NSTextAlignmentCenter;
    tit.textColor=[UIColor whiteColor];
    tit.font=[UIFont boldSystemFontOfSize:20];
    tit.shadowOffset=CGSizeMake(1, -1);
    tit.backgroundColor=[UIColor clearColor];
    [nav addSubview:tit];
    [tit release];
    
    UIButton* submit=[UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame=CGRectMake(320-61, 0, 61, 44);
    [submit addTarget:self action:@selector(submitPics) forControlEvents:UIControlEventTouchUpInside];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
//    [submit setImage:[UIImage imageNamed:@"title_left_cancel.png"] forState:UIControlStateNormal];
//    [submit setImage:[UIImage imageNamed:@"title_left_cancel_sel.png"] forState:UIControlStateHighlighted];
    [nav addSubview:submit];

    UILabel* desLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 44, 300, 20)];
    desLab.text=@"已添加0张（至多可添加5张）";
    desLab.backgroundColor=[UIColor clearColor];
    [self.view addSubview:desLab];
    [desLab release];
    self.view.backgroundColor=[UIColor whiteColor];
    
    btnArray=[[NSMutableArray alloc] init];
    for (int i=0; i<5; i++) {
        UIButton* but=[UIButton buttonWithType:UIButtonTypeCustom];
        int y=i/2 ;
        but.tag=i;
//        but.showsTouchWhenHighlighted=NO;
        but.frame=CGRectMake(10+(i%2)*150, 44+20+10+y*150, 140, 140);
        [self.view addSubview:but];
        [btnArray addObject:but];
    }
    [self freshView];
}

-(void)freshView{
    for (int i=0; i<picsArray.count; i++) {
        UIImage* img=[picsArray objectAtIndex:i];
        UIButton* but=(UIButton*)[btnArray objectAtIndex:i];
        [but setBackgroundImage:img forState:UIControlStateNormal];
        [but addTarget:self action:@selector(clickPic:) forControlEvents:UIControlEventTouchUpInside];
    }
   UIButton* b=(UIButton*)[btnArray objectAtIndex:picsArray.count];
    [b setBackgroundImage:[UIImage imageNamed:@"CameraPicSel.png"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(addPicClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addPicClick{
    
}
-(void)clickPic{
    UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选取照片",@"查看大图",@"删除照片",nil];
    [sheet showFromTabBar:SharedDelegate.tabBarController.tabBar ];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

-(void)clickPic:(UIButton*)sender{
    
}
-(void)addPic:(UIImage*)image{
    [picsArray addObject:image];
}

-(void)addPics:(NSArray*)imgAr{
    [picsArray addObjectsFromArray:imgAr];
}
-(void)cancelClick{
    [self popSelfAnimated:YES];
}
-(void)submitPics{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
