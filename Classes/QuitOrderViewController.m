//
//  QuitOrderViewController.m
//  TheStoreApp
//
//  Created by yuan jun on 13-3-11.
//
//

#import "QuitOrderViewController.h"
#import "TheStoreAppAppDelegate.h"
#import "QuitOrderPicsVC.h"
#import "QuitOrderWayVC.h"
#import "QuitOrderReasonVC.h"
//@implementation UINavigationBar(CustomBackground)
//
//- (UIImage *)barBackground
//{
//    if (self.tag >= 10000) {
//		return nil;
//	}
//	else {
//        return [UIImage imageNamed:@"title_bg.png"];
//	}
//}
//
//- (void)didMoveToSuperview
//{
//    //iOS5 only
//    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//		[self setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
//    }
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    [[self barBackground] drawInRect:rect];
//}
//
//@end

@interface QuitOrderViewController ()

@end

@implementation QuitOrderViewController
@synthesize  isGroup;
-(void)dealloc{
    OTS_SAFE_RELEASE(selectedIMGArray);
    [table release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView* nav=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    nav.userInteractionEnabled=YES;
    nav.image=[UIImage imageNamed:@"title_bg.png"];
    [self.view addSubview:nav];
    [nav release];
    CGFloat height=0;
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 0, 61, 44);
    height+=44;
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];

    [nav addSubview:back];
    UILabel* tit=[[UILabel alloc] initWithFrame:CGRectMake(61, 0, 320-122, 44)];
    tit.text=@"申请退换货";
    tit.textAlignment=NSTextAlignmentCenter;
    tit.textColor=[UIColor whiteColor];
    tit.font=[UIFont boldSystemFontOfSize:20];
    tit.shadowOffset=CGSizeMake(1, -1);
    tit.backgroundColor=[UIColor clearColor];
    [nav addSubview:tit];
    [tit release];
    
    UIButton* submit=[UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame=CGRectMake(320-61, 0, 61, 44);
    [submit addTarget:self action:@selector(submitQuitOrder) forControlEvents:UIControlEventTouchUpInside];
    [submit setImage:[UIImage imageNamed:@"title_submit.png"] forState:UIControlStateNormal];
    [submit setImage:[UIImage imageNamed:@"title_submit_sel.png"] forState:UIControlStateHighlighted];
    [nav addSubview:submit];
    
    
    self.view.backgroundColor=[UIColor colorWithRed:(240.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width,self.view.frame.size.height-height) style:UITableViewStyleGrouped];
    table.delegate=self;
    table.dataSource=self;
    table.backgroundView=nil;
    table.backgroundColor=[UIColor clearColor];
    [self.view addSubview:table];
    UIView* head;
    if (isGroup) {
        head=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 92)];
        UILabel* lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 36)];
        lab.text=@"您正在提交订单XXXXXXXXEXX的退货申请";
        lab.backgroundColor=[UIColor clearColor];

        [head addSubview:lab];
        [lab release];
        UIImageView* iconImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 36, 50, 50)];
        iconImg.image=[UIImage imageNamed:@""];
        [head addSubview:iconImg];
        [iconImg release];
        UILabel* productName=[[UILabel alloc] initWithFrame:CGRectMake(60, 36, 200, 25)];
        productName.text=@"商品名称商品名称商品名称商品名称商品名称";
        [head addSubview:productName];
        [productName release];
        UILabel* price=[[UILabel alloc] initWithFrame:CGRectMake(60, 65, 100, 25)];
        price.text=@"¥9999.99";
        [head addSubview:price];
        [price release];
    }else{
        head=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
        UILabel* lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 36)];
        lab.backgroundColor=[UIColor clearColor];
        lab.text=@"您正在提交订单XXXXXXXXEXX的退货申请";
        lab.font=[UIFont systemFontOfSize:15];
        [head addSubview:lab];
        [lab release];
    }
    table.tableHeaderView=head;
    [head release];
    
    UIView* foot=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIButton* comit=[UIButton buttonWithType:UIButtonTypeCustom];
    [comit setBackgroundImage:[UIImage imageNamed:@"CameraSubmit.png"] forState:UIControlStateNormal];
    [comit addTarget:self action:@selector(submitQuitOrder) forControlEvents:UIControlEventTouchUpInside];
    comit.frame=CGRectMake(93, 10, 135, 40);
    [foot addSubview:comit];
    table.tableFooterView=foot;
    [foot release];
}
-(void)backClick{
    [self popSelfAnimated:YES];
}
-(void)submitQuitOrder{
    
}
#pragma mark table delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (table==tableView) {
        if (isGroup) {
            return 3;
        }else{
            return 4;
        }
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (table==tableView){
        if (isGroup) {
            return 1;
        }else{
            if (section==0) {
                return 1;
            }else{
                return 1;
            }
        }
    }else{
        return selectedIMGArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (table==tableView) {
        if (isGroup) {
            if (indexPath.section==1) {
                return 62;
            }
        }
        return 44;
    }
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==table) {
        static  NSString* ident=@"cell";
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ident];
        if (cell==nil) {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if (isGroup) {
            switch (indexPath.section) {
                case 0:
                    cell.textLabel.text=@"退换货原因";
                    break;
                case 1:
                    cell.textLabel.text=@"上传照片";
                    break;
                case 2:
                    cell.textLabel.text=@"退换货方式";
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.section) {
                case 0:
                    cell.textLabel.text=@"退换货商品";
                    break;
                case 1:
                    cell.textLabel.text=@"退换货原因";
                    break;
                case 2:
                    cell.textLabel.text=@"上传照片";
                    break;
                case 3:
                    cell.textLabel.text=@"退换货方式";
                    break;
                default:
                    break;
            }
            
        }
        return cell;
    }else{
        static  NSString* ident=@"thumbcell";
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ident];
        if (cell==nil) {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIView* rotateView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44 , 44)];
        [rotateView setBackgroundColor:[UIColor whiteColor]];
        rotateView.transform=CGAffineTransformMakeRotation(M_PI * 90 / 180);
        rotateView.center=CGPointMake(40, 22);
        [cell.contentView addSubview:rotateView];
        [rotateView release];
        
        UIImageView* imv=[[UIImageView alloc] initWithImage:[selectedIMGArray objectAtIndex:indexPath.row]];
        [imv setFrame:CGRectMake(2, 2, 40, 40)];
        [imv setClipsToBounds:YES];
        [imv setContentMode:UIViewContentModeScaleAspectFill];
        
        [imv.layer setBorderColor:[UIColor whiteColor].CGColor];
        [imv.layer setBorderWidth:2.0f];
        
        [rotateView addSubview:imv];
        [imv release];
        
        UIButton*   btn_delete=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn_delete setFrame:CGRectMake(0, 0, 22, 22)];
        [btn_delete setImage:[UIImage imageNamed:@"cameraImageDelete.png"] forState:UIControlStateNormal];
        [btn_delete setCenter:CGPointMake(42, 2)];
        [btn_delete addTarget:self action:@selector(deletePicHandler:) forControlEvents:UIControlEventTouchUpInside];
        [btn_delete setTag:indexPath.row];
        
        [rotateView addSubview:btn_delete];

        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (table==tableView) {
        if (isGroup) {
            if (indexPath.section==1) {
                [self goPhoto];
            }else if (indexPath.section==0){
                [self goQuitReason];
            }else if (indexPath.section==2){
                [self goQuitWay];
            }
        }else{
            if (indexPath.section==2) {
                [self goPhoto];
            }else if (indexPath.section==3){
                [self goQuitWay];
            }else if (indexPath.section==1){
                [self goQuitReason];
            }else if(indexPath.section==0){
                [self goQuitProductList];
            }
        }
    }
}

-(void)goQuitProductList{
    
}
-(void)goQuitReason{
    QuitOrderReasonVC* reason=[[QuitOrderReasonVC alloc] init];
    [self pushVC:reason animated:YES fullScreen:YES];
    [reason release];
}
-(void)goQuitWay{
    QuitOrderWayVC*way=[[QuitOrderWayVC alloc] init];
    [self pushVC:way animated:YES fullScreen:YES];
    [way release];
}
-(void)goPhoto{
    UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选取照片", nil];
    [sheet showInView:self.view];
    [sheet release];
}
#pragma mark get/show the UIView we want

//Find the view we want in camera structure.
-(UIView *)findView:(UIView *)view withName:(NSString *)name{
	
	Class cl = [view class];
	NSString *desc = [cl description];
	if ([desc compare:name] == NSOrderedSame)
		return view;
	
	for (NSUInteger i = 0; i < [view.subviews count]; i++)
	{
		UIView *subView = [view.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;
}

-(void)showCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraPicker=[[UIImagePickerController alloc] init];
            cameraPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            cameraPicker.delegate = self;
            [SharedDelegate.tabBarController presentModalViewController:cameraPicker animated:YES];
            [cameraPicker release];
    }
}



-(void)showPhotoAblums{
        imagePicker=[[UIImagePickerController alloc] init] ;
        imagePicker.delegate=self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
//        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imagePicker.view.frame = CGRectMake(0, 0, 320, 480);
        [SharedDelegate.tabBarController presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([[[viewController class] description] isEqualToString:@"PLUISavedPhotosAlbumViewController"]||[[[viewController class] description] isEqualToString:@"PLUIAlbumViewController"]) {
        [self customPhotosAlbum:viewController];
    }
    if ([[[viewController class] description] isEqualToString:@"PLUILibraryViewController"]) {
        [self customPhotosLib:viewController];
    }
    if ([[[viewController class] description] isEqualToString:@"PLUICameraViewController"]) {
        [self customCamera:viewController];
    }
}

-(void)customPhotosLib:(UIViewController*)viewController{
    viewController.navigationController.navigationBar.hidden=YES;
    
    UIImageView* nav=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    nav.userInteractionEnabled=YES;
    nav.image=[UIImage imageNamed:@"title_bg.png"];
    [viewController.view addSubview:nav];
    [nav release];
    //    CGFloat height=0;
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 0, 61, 44);
    //    height+=44;
    [back setImage:[UIImage imageNamed:@"cameraPhotoLib.png"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"cameraPhotoLib_sel.png"] forState:UIControlStateHighlighted];
    
    [back addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:back];
    //    UIBarButtonItem*libItm=[[UIBarButtonItem alloc] initWithCustomView:back];
    //    viewController.navigationItem.leftBarButtonItem=libItm;
    //
    //    [libItm release];
    
    //    viewController.navigationItem.title=@"相机胶卷";
    UILabel* tit=[[UILabel alloc] initWithFrame:CGRectMake(61, 0, 320-122, 44)];
    tit.text=@"相机胶卷";
    tit.textAlignment=NSTextAlignmentCenter;
    tit.textColor=[UIColor whiteColor];
    tit.font=[UIFont boldSystemFontOfSize:20];
    tit.shadowOffset=CGSizeMake(1, -1);
    tit.backgroundColor=[UIColor clearColor];
    [nav addSubview:tit];
    [tit release];
    
    UIButton* submit=[UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame=CGRectMake(320-61, 0, 61, 44);
    [submit addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    [submit setImage:[UIImage imageNamed:@"title_left_cancel.png"] forState:UIControlStateNormal];
    [submit setImage:[UIImage imageNamed:@"title_left_cancel_sel.png"] forState:UIControlStateHighlighted];
    [nav addSubview:submit];
    
    UITableView* PLHighlightingTableView=(UITableView*)[viewController.view.subviews objectAtIndex:0];
    [PLHighlightingTableView setFrame:CGRectMake(0, 44, 320, PLHighlightingTableView.frame.size.height-44)];

}
    
-(void)customPhotosAlbum:(UIViewController*)viewController{
//    viewController.navigationController.navigationBar.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg.png"]];
    viewController.navigationController.navigationBar.hidden=YES;
    
    UIImageView* nav=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    nav.userInteractionEnabled=YES;
    nav.image=[UIImage imageNamed:@"title_bg.png"];
    [viewController.view addSubview:nav];
    [nav release];
//    CGFloat height=0;
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 0, 61, 44);
//    height+=44;
    [back setImage:[UIImage imageNamed:@"cameraPhotoLib.png"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"cameraPhotoLib_sel.png"] forState:UIControlStateHighlighted];

    [back addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:back];
//    UIBarButtonItem*libItm=[[UIBarButtonItem alloc] initWithCustomView:back];
//    viewController.navigationItem.leftBarButtonItem=libItm;
//
//    [libItm release];

//    viewController.navigationItem.title=@"相机胶卷";
    UILabel* tit=[[UILabel alloc] initWithFrame:CGRectMake(61, 0, 320-122, 44)];
    tit.text=@"相机胶卷";
    tit.textAlignment=NSTextAlignmentCenter;
    tit.textColor=[UIColor whiteColor];
    tit.font=[UIFont boldSystemFontOfSize:20];
    tit.shadowOffset=CGSizeMake(1, -1);
    tit.backgroundColor=[UIColor clearColor];
    [nav addSubview:tit];
    [tit release];

    UIButton* submit=[UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame=CGRectMake(320-61, 0, 61, 44);
    [submit addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    [submit setImage:[UIImage imageNamed:@"title_left_cancel.png"] forState:UIControlStateNormal];
    [submit setImage:[UIImage imageNamed:@"title_left_cancel_sel.png"] forState:UIControlStateHighlighted];
    [nav addSubview:submit];
//    UIBarButtonItem*cancelItm=[[UIBarButtonItem alloc] initWithCustomView:submit];
//    viewController.navigationItem.rightBarButtonItem=cancelItm;
//    [cancelItm release];
    
    UITableView* PLHighlightingTableView=(UITableView*)[viewController.view.subviews objectAtIndex:0];
    DebugLog(@"%@",viewController.view.subviews);
    [PLHighlightingTableView setFrame:CGRectMake(0, 44, 320, PLHighlightingTableView.frame.size.height-80-44)];
    UIView*selectedPan=[[UIView alloc] initWithFrame:CGRectMake(0, 480-80, 320, 80)];

    [viewController.view addSubview:selectedPan];
    [selectedPan release];
    
    tbv=[[UITableView alloc] initWithFrame:CGRectMake(0, 50, 80, 240) style:UITableViewStylePlain];
    tbv.backgroundColor=[UIColor redColor];
    tbv.transform=CGAffineTransformMakeRotation(M_PI * -90 / 180);
    tbv.center=CGPointMake(120, 80/2);

    [tbv setShowsVerticalScrollIndicator:NO];
    [tbv setPagingEnabled:YES];
    
    tbv.dataSource=self;
    tbv.delegate=self;
    
    //[tbv setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    [tbv setBackgroundColor:[UIColor clearColor]];
    
    
    [tbv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [selectedPan addSubview:tbv];
    [tbv release];
    
    albumDone=[UIButton buttonWithType:UIButtonTypeCustom];
    [albumDone addTarget:self action:@selector(selectImages:) forControlEvents:UIControlEventTouchUpInside];
    [albumDone setImage:[UIImage imageNamed:@"cameraSelDone.png"] forState:UIControlStateNormal];
    [albumDone setImage:[UIImage imageNamed:@"cameraSelDone_blue.png"] forState:UIControlStateSelected];
    albumDone.frame=CGRectMake(248, 20, 65, 40);
    [selectedPan addSubview:albumDone];
}
-(void)customCamera:(UIViewController*)viewController{
    UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
//拍照View的bar背景
    UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
	UIImageView *bottomBarImageForCamera=[bottomBar.subviews objectAtIndex:1];
    UIImage *imageForBottomBar=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"cameraBottomBar.png"]];
	bottomBarImageForCamera.image=imageForBottomBar;
	[imageForBottomBar release];
    
    DebugLog(@"%@",bottomBar.subviews);
//拍照view的返回按钮
    UIButton *cancelBottomBarButton=(UIButton*)[bottomBarImageForCamera.subviews objectAtIndex:1];
//    [cancelBottomBarButton setBackgroundImage:[UIImage imageNamed:@"CameraCancel.png"] forState:UIControlStateNormal];
//    [cancelBottomBarButton setTitle:@"" forState:UIControlStateNormal];
    
    [cancelBottomBarButton removeFromSuperview];
    UIButton* CancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [CancelBtn addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    CancelBtn.frame=CGRectMake(6, 8.5, 33, 34);
    [CancelBtn setImage:[UIImage imageNamed:@"CameraCancel.png"] forState:UIControlStateNormal];
    [bottomBarImageForCamera addSubview:CancelBtn];

    DebugLog(@"%@",bottomBarImageForCamera.subviews);
//  拍照按钮
//    UIButton * PLCameraButton=(UIButton*)[bottomBarImageForCamera.subviews objectAtIndex:0];
//    [PLCameraButton removeFromSuperview];
//    [PLCameraButton setBackgroundImage:[UIImage imageNamed:@"CameraDone.png"] forState:UIControlStateNormal];
//    UIButton* cameraBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    cameraBtn.frame=CGRectMake(143, 8.5, 77, 34);
//    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"CameraDone.png"] forState:UIControlStateSelected];
//    [cameraBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomBarImageForCamera addSubview:cameraBtn];
//  增加一个到图库的按钮
    UIButton* PhotoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    PhotoBtn.frame=CGRectMake(320-40, 8.5, 33, 34);
    [PhotoBtn addTarget:self action:@selector(showPhotoAblums) forControlEvents:UIControlEventTouchUpInside];
    [PhotoBtn setImage:[UIImage imageNamed:@"CameraPhotoAlbums.png"] forState:UIControlStateNormal];
    [bottomBarImageForCamera addSubview:PhotoBtn];
}
-(void)takePhoto:(UIButton*)photoBtn{
    if (!photoBtn.selected) {
        photoBtn.selected=YES;
    }else{
        [self takePhotoDone];
        [self cancelCamera];
    }
}
-(void)takePhotoDone{
    
}
-(void)cancelCamera{
    [SharedDelegate.tabBarController dismissModalViewControllerAnimated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //imagePicker.videoMaximumDuration = 300.0f;

    if (buttonIndex==0) {
        [self showCamera];
    }else if(buttonIndex==1){
        [self showPhotoAblums];
    }
    
}
-(void)deletePicHandler:(UIButton*)btn
{
    [selectedIMGArray removeObjectAtIndex:btn.tag];
    [self updatePhotoAlubms];
}
-(void)selectImages:(UIButton*)sender{
    if (sender.selected) {
        QuitOrderPicsVC* picsVC=[[QuitOrderPicsVC alloc] init];
        [picsVC addPics:selectedIMGArray];
        [self pushVC:picsVC animated:YES fullScreen:YES];
        [picsVC release];
        [SharedDelegate.tabBarController dismissModalViewControllerAnimated:YES];
    }
}

-(void)updatePhotoAlubms{
    [tbv reloadData];
    if (selectedIMGArray.count>0) {
        albumDone.selected=YES;
    }else{
        albumDone.selected=NO;
    }
}
#pragma mark delegate imagepicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (picker.sourceType!=UIImagePickerControllerSourceTypeCamera) {
        if (selectedIMGArray==nil) {
            selectedIMGArray=[[NSMutableArray alloc] init];
        }
        //超过5张就不行了
        if (selectedIMGArray.count<=5) {
            UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
            [selectedIMGArray addObject:image];
            [self updatePhotoAlubms];
        }else{
            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"照片选择达到上限" message:@"至多只能选择5张照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else{
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        if(!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
        QuitOrderPicsVC* picsVC=[[QuitOrderPicsVC alloc] init];
        [picsVC addPic:img];
        [self pushVC:picsVC animated:YES fullScreen:YES];
        [picsVC release];
        [SharedDelegate.tabBarController dismissModalViewControllerAnimated:YES];

//        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:img];
//        
//        [tempImageView release];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
