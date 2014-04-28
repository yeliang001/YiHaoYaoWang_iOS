//
//  GameViewController.m
//  TheStoreApp
//
//  Created by yuan jun on 12-10-31.
//
//

#import "GameViewController.h"
#import "OTSNavigationBar.h"
#import "GameGiftBtn.h"
#import "GameRecViewController.h"
#import "OTSWeRockService.h"
#import "GlobalValue.h"
#import "RockProductV2.h"
#import "OTSBaseServiceResult.h"
#import "OTSNaviAnimation.h"
#import "DataController.h"
#import "OTSLoadingView.h"

#define GiftStartY_Pos ((iPhone5)?90:65)
#define GiftSepY_pos ((iPhone5)?145:125)

@interface GameViewController ()
@property (nonatomic, retain) GameRecViewController *gameRecVC;
@end

@implementation GameViewController
@synthesize gameRecVC = _gameRecVC;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [giftBtnArray release];
    [presentsArray release];
    [_gameRecVC release];
    
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
-(void)naviBackAction:(id)sender
{
    [self popSelfAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(naviBackAction:) name:@"BackToRockGame" object:nil];
    self.naviBar.titleLabel.text=@"你送我猜";

    if (presentsArray==nil) {
        presentsArray=[[NSMutableArray alloc] init];
    }
    if (giftBtnArray==nil) {
        giftBtnArray=[[NSMutableArray alloc] init];
    }
    [self initView];
    [self showLoading:YES];
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getPresents) toTarget:self withObject:nil];
    NSNumber*first=[[NSUserDefaults standardUserDefaults] valueForKey:@"FirstGame"];
    if (first==nil||![first boolValue]) {
        [self helpShow:QABtn];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"FirstGame"];
    }
    
    [self.naviBar.leftNaviBtn addTarget:self action:@selector(naviBackAction:) forControlEvents:UIControlEventTouchUpInside];
	// Do any additional setup after loading the view.
}
//-(void)createRockGame{
//    @autoreleasepool {
//        NSString*token=[GlobalValue getGlobalValueInstance].token;
//        int result=[[OTSWeRockService myInstance] createRockGame:token];
//
//    }
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if (!selFriend) {
//        friendName.text=@"";
//        friendPhone.text=@"";
//        friendName.hidden=YES;
//        friendPhone.hidden=YES;
//        emptyLab.hidden=NO;
//        icon.image=[UIImage imageNamed:@"game_ABIcon.png"];
//        statusImg.hidden=YES;
//        selFriend=NO;
//    }
}
-(void)getPresents{
    NSAutoreleasePool*pool=[[NSAutoreleasePool alloc] init];
    NSString* token=[GlobalValue getGlobalValueInstance].token;
    
    if (token!=nil&&[token isKindOfClass:[NSString class]]) {
        NSArray* RockGameProductVOs=[[OTSWeRockService myInstance] getPresentsByToken:token];
        if (RockGameProductVOs!=nil&&[RockGameProductVOs isKindOfClass:[NSArray class]]) {
            [presentsArray removeAllObjects];
            [presentsArray addObjectsFromArray:RockGameProductVOs];
            if (presentsArray!=nil&&presentsArray.count) {
                for (int i=0; i<presentsArray.count; i++) {
                    RockGameProductVO*RGPV=(RockGameProductVO*)[presentsArray objectAtIndex:i];
                    NSString* picked=RGPV.picturePicked;
//                    NSString*unpicked=RGPV.pictureUnpicked;
//                    NSData* udata=[NSData dataWithContentsOfURL:[NSURL URLWithString:unpicked]];
//                    [DataController writeApplicationData:udata name:[NSString stringWithFormat:@"game_unpick_%d",i]];
                   NSData* data= [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:picked]] returningResponse:nil error:nil];
                    [DataController writeApplicationData:data name:[NSString stringWithFormat:@"game_pick_%d",i]];
                }
                [self performSelectorOnMainThread:@selector(freshGift) withObject:nil waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(showErrorr) withObject:nil waitUntilDone:NO];
            }
        }else{
            [self performSelectorOnMainThread:@selector(showErrorr) withObject:nil waitUntilDone:NO];
        }
    }else{
        [self performSelectorOnMainThread:@selector(showLogin) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

-(void)freshGift{
    for (int i=0; i<presentsArray.count; i++) {
        RockGameProductVO*RGPV=(RockGameProductVO*)[presentsArray objectAtIndex:i];
        GameGiftBtn*gift=(GameGiftBtn*)[giftBtnArray objectAtIndex:i];
        [gift addTarget:self action:@selector(selectGift:) forControlEvents:UIControlEventTouchUpInside];
        ProductVO*product= RGPV.rockProductV2.prodcutVO;
        [gift giftName:product.cnName];
        //[gift giftValue:[NSString stringWithFormat:@"¥ %@",product.maketPrice]];
        [gift giftValue:[NSString stringWithFormat:@"¥ %@",product.price]];
        [gift downloadUnpickImage:RGPV.pictureUnpicked];
        NSData* data=[DataController applicationDataFromFile:[NSString stringWithFormat:@"game_pick_%d",i]];
        [gift setImage:[UIImage imageWithData:data] forState:UIControlStateSelected];
//        NSData* udata=[DataController applicationDataFromFile:[NSString stringWithFormat:@"game_unpick_%d",i]];
//        [gift setImage:[UIImage imageWithData:udata] forState:UIControlStateNormal];
    }
    [self.view bringSubviewToFront:infoView];
    [self hideLoading];
}

-(void)selectGift:(UIButton*)btn{
    if (btn.selected) {
        return;
    }
    for (GameGiftBtn* bt in giftBtnArray) {
        bt.selected=NO;
    }
    btn.selected=YES;
    int seclectIndex= btn.tag-10;
    selectedRGPV=[presentsArray objectAtIndex:seclectIndex];
}

-(void)showErrorr{
    [self hideLoading];
    UIAlertView*al=[[UIAlertView alloc] initWithTitle:nil message:@"连接失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    al.tag=2001;
    [al show];
    [al release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==2001) {
        if (buttonIndex==0) {
//            [self popSelfAnimated:YES];
        friendName.text=@"";
        friendPhone.text=@"";
        friendName.hidden=YES;
        friendPhone.hidden=YES;
        emptyLab.hidden=NO;
            act.hidden=YES;
        icon.image=[UIImage imageNamed:@"game_ABIcon.png"];
        statusImg.hidden=YES;
        }
    }
}

-(void)showLogin{
    [self hideLoading];
}

-(void)initView{    
    UIImageView*bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    
    [self.view addSubview:bg];
    bg.userInteractionEnabled=YES;
    [bg release];
    
    UILabel* gametitle=[[UILabel alloc] initWithFrame:CGRectMake(72, 32, 180, 30)];
    gametitle.textColor=[UIColor colorWithRed:(80.0/255.0) green:(36.0/255.0) blue:(12.0/255.0) alpha:1];
    gametitle.text=@"挑选一份礼物送给TA";
    gametitle.backgroundColor=[UIColor clearColor];
    gametitle.textAlignment=NSTextAlignmentCenter;
    gametitle.font=[UIFont boldSystemFontOfSize:18];
    gametitle.shadowColor=[UIColor colorWithRed:(224.0/255.0) green:(195.0/255.0) blue:(162.0/255.0) alpha:1];
    [bg addSubview:gametitle];
    [gametitle release];
    
    if (iPhone5) {
        bg.image=[UIImage imageNamed:@"game5_BG1.png"];
        [gametitle setFrame:CGRectMake(72, 52, 180, 30)];
    }else{
        bg.image=[UIImage imageNamed:@"game_BG1.png"];
    }
    
    UIButton* but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.frame=CGRectMake(90, bg.frame.size.height-7-36, 133, 36);
    [but addTarget:self action:@selector(gameStep2) forControlEvents:UIControlEventTouchUpInside];
    [but setBackgroundImage:[UIImage imageNamed:@"game_next.png"] forState:UIControlStateNormal];
    [but setBackgroundImage:[UIImage imageNamed:@"game_next_touched.png"] forState:UIControlStateHighlighted];
    [bg addSubview:but];
    
    UIImageView*contract=[[UIImageView alloc] initWithFrame:CGRectMake(25, bg.frame.size.height-60-56, 201, 62)];
    contract.image=[UIImage imageNamed:@"game_Contract.png"];
    [bg addSubview:contract];
    
    emptyLab=[[UILabel alloc] initWithFrame:CGRectMake(65, 13, 140, 40)];
    
    emptyLab.text=@"未选择联系人";
    emptyLab.textColor=[UIColor colorWithRed:(80.0/255.0) green:(36.0/255.0) blue:(12.0/255.0) alpha:0.6];
    emptyLab.backgroundColor=[UIColor clearColor];
    [contract addSubview:emptyLab];
    [emptyLab release];
    
    icon=[[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 38, 38)];
    icon.image=[UIImage imageNamed:@"game_ABIcon.png"];
    [contract addSubview:icon];
    [icon release];
    
    statusImg=[[UIImageView alloc] initWithFrame:CGRectMake(155, 13, 40 , 40)];
    statusImg.image=[UIImage imageNamed:@"game_checkWrong.png"];
    [contract addSubview:statusImg];
    statusImg.hidden=YES;
    [statusImg release];

    friendName=[[UILabel alloc] initWithFrame:CGRectMake(65, 13, 90, 20)];
    friendName.textColor=[UIColor blackColor];
    friendName.backgroundColor=[UIColor clearColor];
    friendName.font=[UIFont boldSystemFontOfSize:16];
    friendName.hidden=YES;
    
    friendPhone=[[UILabel alloc] initWithFrame:CGRectMake(65, 37, 100, 15)];
    friendPhone.textColor=[UIColor colorWithRed:(80.0/255.0) green:(36.0/255.0) blue:(12.0/255.0) alpha:0.6];
    friendPhone.backgroundColor=[UIColor clearColor];
    friendPhone.font=[UIFont systemFontOfSize:14];
    friendPhone.hidden=YES;
    [contract addSubview:friendName];
    [friendName release];
    
    [contract addSubview:friendPhone];
    [friendPhone release];
    
    [contract release];

    act=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    act.frame=CGRectMake(155, 13, 40, 40);
    act.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [contract addSubview:act];
    act.hidden=YES;
    [act release];
    
    UIButton* addContract=[UIButton buttonWithType:UIButtonTypeCustom];
    addContract.frame=CGRectMake(320-30-48, bg.frame.size.height-60-48, 48, 48);
    [addContract setBackgroundImage:[UIImage imageNamed:@"game_addContract.png"] forState:UIControlStateNormal];
    [addContract addTarget:self action:@selector(openAB) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:addContract];
    
    for (int i=0; i<4; i++) {
        GameGiftBtn*gift=[GameGiftBtn buttonWithType:UIButtonTypeCustom];
        gift.tag=i+10;
        gift.frame=CGRectMake((i%2)*150+10, 44+GiftStartY_Pos+((int)(i/2))*GiftSepY_pos, 150, 120);
        [self.view addSubview:gift];
        [giftBtnArray addObject:gift];
    }
    infoView=[[UIImageView alloc]initWithFrame:CGRectMake(90, 140, 140, 140)];
    infoView.image=[UIImage imageNamed:@"game_mic_bg.png"];
    
    UIImageView* errorView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 38)];
    errorView.center=CGPointMake(70, 70);
    errorView.image=[UIImage imageNamed:@"game_loadError.png"];
    [infoView addSubview:errorView];
    [errorView release];
    
    infoLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 90, 120, 30)];
    infoLab.textColor=[UIColor whiteColor];
    infoLab.backgroundColor=[UIColor clearColor];
    infoLab.textAlignment=NSTextAlignmentCenter;
    infoLab.adjustsFontSizeToFitWidth=YES;
    [infoView addSubview:infoLab];
    [self.view addSubview:infoView];
    [self.view bringSubviewToFront:infoView];
    [infoView release];
    infoView.hidden=YES;
}
#pragma mark error info show

-(void)hiddenInfoView{
    [self performBlock:^(void){
        infoView.hidden=YES;
    } afterDelay:1];
}
-(void)showGiftSelectInfo{
    infoLab.text=@"请选择1款商品";
    infoView.hidden=NO;
    [self hiddenInfoView];
}

-(void)showFriendSelectInfo{
    infoLab.text=@"请从通讯录中选择好友";
    infoView.hidden=NO;
    [self hiddenInfoView];
}

-(void)showFriendFailedInfo{
    infoLab.text=@"您邀请的好友已注册";
    infoView.hidden=NO;
    [self hiddenInfoView];
}
#pragma mark --
-(void)gameStep2{
    
    if (selectedRGPV==nil) {
        [self showGiftSelectInfo];
        return;
    }
    if (friendName.text==@""||!friendName.text.length) {
        [self showFriendSelectInfo];
        return;
    }
    if (statusImg.image==[UIImage imageNamed:@"game_checkWrong.png"]) {
        [self showFriendFailedInfo];
        return;
    }
    if (!checkOK) {
        return;
    }
    selFriend=NO;
    self.gameRecVC = [[[GameRecViewController alloc] init] autorelease];
    self.gameRecVC.shareCellPhone=friendPhone.text;
    self.gameRecVC.shareCellName=friendName.text;
    self.gameRecVC.rockGameProductVo=selectedRGPV;
    self.gameRecVC.rockGameVO=rockGameVO;
    [self pushVC:self.gameRecVC animated:YES fullScreen:YES];
}

-(void)statusChanged{
    checkOK=NO;
    emptyLab.hidden=YES;
    
    friendName.hidden=NO;
    friendPhone.hidden=NO;
    act.hidden=NO;
    [act startAnimating];

    [self otsDetatchMemorySafeNewThreadSelector:@selector(checkOut) toTarget:self withObject:nil];
}
- (void)checkOut{
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    InviteeResult* rest=[[OTSWeRockService myInstance] isCanInviteeUser:[GlobalValue getGlobalValueInstance].trader PhoneNum:friendPhone.text];
    if (rest!=nil) {
        [self performSelectorOnMainThread:@selector(checkResult:) withObject:rest waitUntilDone:NO];
    }else{
        [self performSelectorOnMainThread:@selector(showErrorr) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

-(void)checkResult:(InviteeResult*)result{
    act.hidden=YES;
    [act stopAnimating];
    statusImg.hidden=NO;
    if ([result.resultCode integerValue]==1) {
        checkOK=YES;
        statusImg.image=[UIImage imageNamed:@"game_checkRigjht.png"];
    }else{
        statusImg.image=[UIImage imageNamed:@"game_checkWrong.png"];
    }
}
#pragma mark AddressBook func
-(void)openAB{
    ABPeoplePickerNavigationController* peopleView=[[ABPeoplePickerNavigationController alloc] init];
    peopleView.peoplePickerDelegate=self;
    peopleView.displayedProperties=[NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],nil];
    [self presentModalViewController:peopleView animated:YES];
    [peopleView release];
    
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    DebugLog(@"%d=======%d",property,identifier);
    if (property!=kABPersonPhoneProperty) {
        return NO;
        /*添加警告选择号码的*/
    }
    
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, property);
    CFStringRef phone = ABMultiValueCopyValueAtIndex(multi, identifier);
    DebugLog(@"phone %@", (NSString *)phone);
    
    NSString*phoneNum=(NSString *)phone;
    if (phoneNum) {
        friendPhone.text=[[phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }

    //图片
    NSData *imageData = (NSData*)ABPersonCopyImageData(person);
    if (imageData) {
        icon.image=[UIImage imageWithData:imageData];
    }else{
        icon.image=[UIImage imageNamed:@"game_ABIcon.png"];
    }
   //姓名
    /*
     AB_EXTERN const ABPropertyID kABPersonFirstNameProperty;          // First name - kABStringPropertyType
     AB_EXTERN const ABPropertyID kABPersonLastNameProperty;           // Last name - kABStringPropertyType
     AB_EXTERN const ABPropertyID kABPersonMiddleNameProperty;         // Middle name - kABStringPropertyType
*/
    NSString*familyname=(NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (familyname==nil) {
        familyname=@"";
    }
    NSString* name=(NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty );
    if (name==nil) {
        name=@"";
    }
   NSString* newname=[familyname stringByAppendingString:name];
    friendName.text=newname;
    [self dismissModalViewControllerAnimated:YES];
    [phoneNum autorelease];
    CFRelease(multi);
    [familyname autorelease];
    [name autorelease];
    [imageData autorelease];
    selFriend=YES;
    [self statusChanged];
    return NO;
}



@end
