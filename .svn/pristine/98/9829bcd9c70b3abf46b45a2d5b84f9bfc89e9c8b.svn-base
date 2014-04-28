//
//  OTSPhoneWeRockRuleVC.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//

#import "OTSPhoneWeRockRuleVC.h"
#import "OTSUtility.h"

@interface OTSPhoneWeRockRuleVC ()
@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
@property (retain, nonatomic) IBOutlet UIImageView *ruleImage;

@end

@implementation OTSPhoneWeRockRuleVC

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
    [_bgImageView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, ApplicationWidth, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    if (iPhone5) {
        CGRect rect = _ruleImage.frame;
        rect.size.height = 460;
        rect.size.width = 280;
        [_ruleImage setImage:[UIImage imageNamed:@"rockbuy_ruleDetail_iP5"]];
        [_ruleImage setFrame:rect];
    }
    [_ruleImage setCenter:CGPointMake(ApplicationWidth/2, (ApplicationHeight+NAVIGATION_BAR_HEIGHT)/2)];
    self.naviBar.titleLabel.text = @"规则";
    
    //[OTSUtility alert:@"这个页面还没做ya~"];
    
    [self.naviBar.leftNaviBtn addTarget:self action:@selector(naviBackAction:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)naviBackAction:(id)sender
{
    [self popSelfAnimated:YES];
}

- (void)viewDidUnload
{
    [self setBgImageView:nil];
    [self setRuleImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc {
    [_bgImageView release];
    [_ruleImage release];
    [super dealloc];
}
@end
