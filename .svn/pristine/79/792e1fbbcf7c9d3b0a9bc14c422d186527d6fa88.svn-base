//
//  ViewController.h
//  yhd
//
//  Created by  on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "JSAnimatedImagesView.h"
#import "Cate2Cell.h"
#import "CateCell.h"
#import "LoginViewController.h"
//#import "ProvinceViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ImageScroll.h"


@class TopView,ImageScroll,ImagePageControl;

// CLASS_DESC:home page vc
@interface ViewController : BaseViewController
<JSAnimatedImagesViewDelegate
, UITableViewDataSource
, UITableViewDelegate
, Cate2CellDelegate
, CateCellDelegate
, UIPopoverControllerDelegate
, CLLocationManagerDelegate
, UIScrollViewDelegate
, LoginDelegate
, ImageScrollDelegate>
{
    IBOutlet JSAnimatedImagesView *animatedView;
    IBOutlet UITableView *cateTableView;
    IBOutlet UIButton *wuliuBut;
    IBOutlet UIButton *cuxiaoBut;
    IBOutlet UIButton *yaoyaoBut;
    IBOutlet UIButton *tuanBut;
    IBOutlet UIScrollView *adImageScrollView;
    NSInteger adImageScrollViewCount;
    TopView *topView;
    ImageScroll *imageScroll;
    ImageScroll *imageScroll2;
    ImagePageControl *myPageControl;
    //UIView *cateView;
    UIView *cateDetailView;
   
    NSMutableArray *images;
    NSMutableArray *hotImages;
    NSArray *listData;
    //NSMutableArray *categories;
    NSMutableDictionary *cate2Dic;
    NSNumber *selectedCateid;
    CategoryVO* rootCate1;
    CategoryVO* rootCate2;
    CategoryVO* rootCate3;

    NSTimer *timer;
    LoginViewController * mloginViewController;
    BOOL mIsLoadingFavourite;
}

@property(nonatomic,retain) NSMutableArray *images;
@property(nonatomic,retain) NSMutableArray *hotImages;
@property(nonatomic,retain) NSArray *listData;
@property(nonatomic,retain) NSArray *categories; 
@property(nonatomic,retain) NSMutableDictionary *cate2Dic;
@property(nonatomic,retain) NSNumber *selectedCateid;
@property(nonatomic,retain) CategoryVO* rootCate1;
@property(nonatomic,retain) CategoryVO* rootCate2;
@property(nonatomic,retain) CategoryVO* rootCate3;

-(IBAction)openFavoriteView:(id)sender;
-(IBAction)openHistroy:(id)sender;
-(IBAction)openPromotion:(id)sender;
-(IBAction)openTrack:(id)sender;
-(void)closeCateView;
@end
