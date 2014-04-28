//
//  OtspCordinatorController.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-12.
//
//

#import "OtspCordinatorController.h"
#import "MyListViewController.h"
#import "LoginViewController.h"

@interface OtspCordinatorController ()
-(UIViewController*)topVC;
@end


@implementation OtspCordinatorController

-(UIViewController*)topVC
{
    return SharedPadDelegate.navigationController.topViewController;
}

#pragma mark -
-(void)changeUIWithObject:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]] || [sender isKindOfClass:[UITabBarItem class]])
    {
        NSUInteger tag = [sender tag];
        
        switch (tag)
        {
            case OtspUIChangeMain:
            {
                [SharedPadDelegate.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
                
                [SharedPadDelegate.navigationController popToRootViewControllerAnimated:NO];
            }
                break;
                
            case OtspUIChangeMyStore:
            {
                if (![self.topVC isKindOfClass:[MyListViewController class]])
                {
                    [MobClick event:@"account"];
                    if ([GlobalValue getGlobalValueInstance].token)
                    {
                        [SharedPadDelegate.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
                        MyListViewController *myStoreVC = [[[MyListViewController alloc] initWithNibName:@"MyListViewController" bundle:nil] autorelease];
                        [SharedPadDelegate.navigationController pushViewController:myStoreVC  animated:NO];
                    }
                    else
                    {
                        LoginViewController* loginVC = [[LoginViewController alloc]init];
                        loginVC.delegate = self;
                        DataHandler * datehandle = [DataHandler sharedDataHandler];
                        [loginVC setMcart:datehandle.cart];
                        if (datehandle.cart.totalquantity != 0)
                        {
                            [loginVC setMneedToAddInCart:YES];
                        }
                        
                        UIView * loginView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)] autorelease];
                        loginView.tag = kLoginViewTag;
                        loginView.alpha = 0.5;
                        [loginView setBackgroundColor:[UIColor grayColor]];
                        
                        [SharedPadDelegate.navigationController.topViewController.view addSubview:loginView];
                        [SharedPadDelegate.navigationController.topViewController.view addSubview:loginVC.view];
                        
                        [loginVC.view setFrame:CGRectMake(1024, 0, 1024, 768)];
                        [self moveToLeftSide:loginVC.view];

                        //UISwipeGestureRecognizer
                        UISwipeGestureRecognizer * swipeGes = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)] autorelease];
                        swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
                        [loginVC.view addGestureRecognizer:swipeGes];
                    }
                }
            }
                break;
                
            case OtspUIChangeShoppingCart:
            {
                [SharedPadDelegate enterCart];
            }
                break;
                
            case OtspUIChangeReturn:
            {
                [SharedPadDelegate.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
                
                [SharedPadDelegate.navigationController popViewControllerAnimated:NO];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - singleton methods
static OtspCordinatorController *sharedInstance = nil;

+ (OtspCordinatorController *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
}

- (id)autorelease
{
    return self;
}
@end
