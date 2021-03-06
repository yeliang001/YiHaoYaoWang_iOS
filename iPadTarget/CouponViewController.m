//
//  CouponViewController.m
//  TheStoreApp
//
//  Created by xuexiang on 12-11-26.
//
//

#import "CouponViewController.h"
#import "CouponService.h"
#import "CouponVO.h"
#import "CouponProvingViewController.h"
#import "OtsPadLoadingView.h"
#import "DataHandler.h"
#import "AppDelegate.h"

#define kcouponCellBgViewTag 100
#define kcouponCanotUseCellTag 101
#define kcouponSelectedCellTag 102

#define kerrorViewTag 200
#define kerrorLabelTag 201



#define SERVICE_STATE_GET   0
#define SERVICE_STATE_SAVE  1
#define SERVICE_STATE_DELETE 2

@interface CouponViewController ()
@property(nonatomic, retain)UIScrollView* m_ScrollView;
@property(nonatomic, retain)UITextField* couponNumFd;
@property(nonatomic, retain)UIButton* couponUse;
@property(nonatomic, retain)UITableView* m_tableView;
@property(nonatomic, retain)NSMutableArray* currentCouponArr;
@property(nonatomic, assign)NSUInteger currentPageIndex;
@property(nonatomic, assign)NSUInteger totoalCouponCount;
@property(nonatomic, retain)CouponCheckResult *couponCheckResult;
@property(nonatomic, retain)OtsPadLoadingView* loadingView;
@property(nonatomic, retain)NSArray* currentRegulationArr;

@property(nonatomic)NSUInteger serviceState;
@property (retain, nonatomic) IBOutlet UIView *regulationView;
@property (retain, nonatomic) IBOutlet UITableView *regulationTableView;
@property (retain, nonatomic) NSString* errStr;
@property (retain, nonatomic) IBOutlet UILabel *regulationTitleLabel;

@property(nonatomic)BOOL isLoadingMore;
@end
@implementation CouponViewController

@synthesize m_ScrollView, couponNumFd, couponUse, m_tableView, loadingView, errStr;
@synthesize currentCouponArr, currentPageIndex, totoalCouponCount, couponCheckResult, currentCouponNumber,isLoadingMore,serviceState,currentRegulationArr;

#pragma mark -
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
    [self initCoupon];
    
}
-(void)initCoupon{
    self.m_tableView = [[[UITableView alloc]initWithFrame:CGRectMake(11, 55, 468, 464)]autorelease];
    m_tableView.dataSource = self;
    m_tableView.delegate = self;
    currentCouponArr = [[NSMutableArray alloc]init];
    currentPageIndex = 1;
    totoalCouponCount = 0;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_tableView];
    
    loadingView = [[OtsPadLoadingView alloc]init];
    [loadingView showInView:self.view];
    _regulationTableView.layer.borderColor = [UIColor colorWithRed:201.0/255 green:201.0/255 blue:201.0/255 alpha:1.0].CGColor;
    _regulationTableView.layer.borderWidth =1;
    _regulationTableView.layer.cornerRadius = 7.0;
    _regulationTableView.layer.masksToBounds = YES;
    [_regulationTableView setShowsVerticalScrollIndicator:NO];
    [self performInThreadBlock:^(){
        [self getCouponListForSessionOrder];
    }completionInMainBlock:^(){
        [self updateCoupon];
    }];
    
}
#pragma mark -
#pragma mark actions
-(void)useCouponBtnClicked{
    if (couponNumFd.text==nil || [couponNumFd.text isEqualToString:@""]) {
        UIView* errorView = [[m_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]viewWithTag:kerrorViewTag];
        [errorView setHidden:NO];
        errStr = @"抵用券号不能为空\n \n \n";
        UILabel* errorLabel = (UILabel*)[errorView viewWithTag:kerrorLabelTag];
        [errorLabel setText:errStr];
        return;
    }
    [couponNumFd resignFirstResponder];
    self.currentCouponNumber = couponNumFd.text;
    [MobClick event:@"click_coupon"];
    [self performInThreadBlock:^(){
        [self saveCouponToSessionOrder];
    }completionInMainBlock:^(){
        [self dealWithSaveCouponResult];
    }];
}
-(IBAction)closeCouponVC:(id)sender{
    if (serviceState == SERVICE_STATE_DELETE) {
        NSArray* resultArr = [NSArray arrayWithObjects:SAVE_COUPON_SUCCESS,nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseCouponVC" object:resultArr];
    }else{
        NSArray* resultArr = [NSArray arrayWithObjects:CLOSE_COUPON_CLOSEDIRECTLY,nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseCouponVC" object:resultArr];
    }
}
-(IBAction)closeRegulation:(id)sender{
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation setType:kCATransitionFade];
    [self.view.layer addAnimation:animation forKey:nil];
    [_regulationView removeFromSuperview];
}
-(void)regulation:(id)sender{
    UIButton* btn = (UIButton*)sender;
    int index = btn.tag;
    CouponVO* couponVO = [currentCouponArr objectAtIndex:index];
    if (couponVO.defineType.intValue == 5) {
        [_regulationTitleLabel setText:@"购买除以下商品可以使用抵用券："];
        [_regulationTableView setTag:0];                        // table tag用以区分table的颜色
    }else{
        [_regulationTitleLabel setText:@"购买以下商品可以使用抵用券："];
        [_regulationTableView setTag:1];
    }
    self.currentRegulationArr = [couponVO.detailDescription componentsSeparatedByString:@"\n"];
    
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation setType:kCATransitionFade];
    [self.view.layer addAnimation:animation forKey:@"regulation"];
    [self.view addSubview:_regulationView];
    [_regulationTableView reloadData];
}
#pragma mark -
#pragma mark data handle
-(void)updateCoupon{
    if (loadingView) {
        [loadingView hide];
    }
    [m_tableView reloadData];
    isLoadingMore = NO;
}
-(void)dealWithSaveCouponResult{
    NSLog(@"%d,%@",[couponCheckResult.resultCode intValue],couponCheckResult.errorInfo);
    if (loadingView) {
        [loadingView hide];
    }
    if (couponCheckResult!=nil && ![couponCheckResult isKindOfClass:[NSNull class]]) {
        if ([couponCheckResult.resultCode intValue] == NEED_CHECK_PHONE || [couponCheckResult.resultCode intValue] == NEED_CHECK_VALIDATION) { // 需验证，进入短信验证页面
            NSArray* resultArr = [NSArray arrayWithObjects:currentCouponNumber,couponCheckResult,nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseCouponVC" object:resultArr];
        }
        else if([couponCheckResult.resultCode intValue] == NEED_NOT_CHECK){
            //------------------保存抵用卷成功,转到订单详情--------------------------
            if (serviceState == SERVICE_STATE_SAVE) { // 若为选择或使用抵用券，直接返回到检查订单。 删除将抵用券号制空
               NSArray* resultArr = [NSArray arrayWithObjects:SAVE_COUPON_SUCCESS,nil];
               [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseCouponVC" object:resultArr];
            }else{
                self.currentCouponNumber = @"";
            }
        }else
        {
            UIView* errorView = [[m_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]viewWithTag:kerrorViewTag];
            [errorView setHidden:NO];
            UILabel* errorLabel = (UILabel*)[errorView viewWithTag:kerrorLabelTag];
            errStr = couponCheckResult.errorInfo;
            [errorLabel setText:[NSString stringWithFormat:@"%@\n \n \n",errStr]];
            self.currentCouponNumber = @"";
        }
    } else {
        //[self showError:NET_ERROR];
    }
}

#pragma mark -
#pragma mark service
-(void)getCouponListForSessionOrder{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    serviceState = SERVICE_STATE_GET;
    isLoadingMore = YES;
    CouponService *cServ=[[CouponService alloc] init];
    Page *tempPage = nil;
    @try {
        tempPage=[cServ getCouponListForSessionOrder:[GlobalValue getGlobalValueInstance].token currentPage:[NSNumber numberWithInt:currentPageIndex] pageSize:[NSNumber numberWithInt:10]];
    } @catch (NSException * e) {
    } @finally {
        if (tempPage!=nil && ![tempPage isKindOfClass:[NSNull class]]) {
            [currentCouponArr addObjectsFromArray:[tempPage objList]];
            currentPageIndex++;
            totoalCouponCount=[[tempPage totalSize] intValue];
        } 
    }
    [cServ release];
    [pool drain];
}
-(void)saveCouponToSessionOrder{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    serviceState = SERVICE_STATE_SAVE;
    CouponService *couponService=[[CouponService alloc] init];
    self.couponCheckResult = [couponService saveCouponToSessionOrderV2:[GlobalValue getGlobalValueInstance].token couponNumber:currentCouponNumber];
    [couponService release];
    [pool drain];
}
-(void)deleteCouponFromSessionOrder{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    serviceState = SERVICE_STATE_DELETE;
    CouponService *couponService=[[CouponService alloc] init];
    self.couponCheckResult = [couponService deleteCouponFromSessionOrder:[GlobalValue getGlobalValueInstance].token];
    [couponService release];
    [pool drain];
}
#pragma mark -
#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text==nil || [textField.text isEqualToString:@""]) {
        return NO;
    }
    [self useCouponBtnClicked];
    return YES;
}
#pragma mark -
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == m_tableView) {
        return [currentCouponArr count]+1;
    }else{
        return currentRegulationArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    if (tableView == m_tableView) { // 抵用券页面
        int row = [indexPath row];
        
        if (row == 0) {
            static NSString* ident=@"FirstCell";
            cell=[tableView dequeueReusableCellWithIdentifier:ident];
            if (cell==nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
            }else{
                for (UIView* subs in cell.subviews) {
                    [subs removeFromSuperview];
                }
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(18, 10, 320, 31)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:@"添加一张抵用卷"];
            //[label setTextColor:UIColorFromRGB(0x4c566c)];
            [label setFont:[UIFont systemFontOfSize:17.0]];
            [cell addSubview:label];
            [label release];
            
            // --------------------------抵用卷输入筐------------------------------
            couponNumFd = [[UITextField alloc] initWithFrame:CGRectMake(18, 45, 340, 35)];
            couponNumFd.returnKeyType = UIReturnKeyDone;
            [couponNumFd setDelegate:self];
            couponNumFd.textAlignment = NSTextAlignmentLeft;
            couponNumFd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            couponNumFd.borderStyle = UITextBorderStyleRoundedRect;
            couponNumFd.placeholder = @"输入抵用卷编码";
            [couponNumFd setFont:[UIFont systemFontOfSize:16.0f]];
            couponNumFd.adjustsFontSizeToFitWidth = YES;
            couponNumFd.clearButtonMode = UITextFieldViewModeUnlessEditing;
            [cell addSubview:couponNumFd];
            
            // --------------------------使用抵用卷------------------------------
            couponUse=[[UIButton alloc] initWithFrame:CGRectMake(378, 44, 76, 35)];
            [couponUse setBackgroundColor:[UIColor clearColor]];
            [couponUse setTitle:@"使 用" forState:UIControlStateNormal];
            [couponUse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [couponUse setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [couponUse setBackgroundImage:[UIImage imageNamed:@"orange_button.png"] forState:UIControlStateNormal];
            [couponUse.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
            [couponUse addTarget:self action:@selector(useCouponBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:couponUse];
            
            if (currentCouponArr && [currentCouponArr count]>0) {
                UILabel* cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 120, 200, 35)];
                [cellLabel setTextAlignment:NSTextAlignmentLeft];
                [cellLabel setText:@"选择已有抵用券"];
                [cellLabel setFont:[UIFont systemFontOfSize:17.0]];
                [cell addSubview:cellLabel];
                [cellLabel release];
            }
            // 错误信息
            //        if ([cell viewWithTag:kerrorViewTag]) {
            //            [[cell viewWithTag:kerrorViewTag] removeFromSuperview];
            //        }
            UIView* errorView = [[UIView alloc]initWithFrame:CGRectMake(18, 90, 455, 20)];
            [errorView setTag:kerrorViewTag];
            [errorView setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:errorView];
            [errorView release];
            
            UILabel* errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 0, 430, 40)];
            [errorLabel setFont:[UIFont systemFontOfSize:17.0]];
            [errorLabel setTag:kerrorLabelTag];
            [errorLabel setTextColor:[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]];
            [errorLabel setBackgroundColor:[UIColor clearColor]];
            [errorLabel setNumberOfLines:0];
            [errorLabel setLineBreakMode:NSLineBreakByClipping];
            [errorView addSubview:errorLabel];
            [errorLabel release];
            
            UIImageView* errorLogImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 18, 18)];
            [errorLogImageView setImage:[UIImage imageNamed:@"error_log.png"]];
            [errorView addSubview:errorLogImageView];
            [errorLogImageView release];
            if (errStr != nil && ![errStr isEqualToString:@""]) {
                [errorLabel setText:errStr];
            }else{
                [errorView setHidden:YES];
            }
            return cell;
        }else{   // 抵用券的显示CELL
            static NSString* ident=@"Couponcell";
            cell=[tableView dequeueReusableCellWithIdentifier:ident];
            if (cell==nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
            }else{
                for (UIView* subs in cell.subviews) {
                    [subs removeFromSuperview];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CouponVO* couponVO = [currentCouponArr objectAtIndex:row-1];
            
            //CouponVO* couponVO = [[CouponVO alloc]init];
            UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 8, 437, 104)];
            
            UIImageView* bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 437, 104)];
            if ([currentCouponNumber isEqualToString:couponVO.number]) {
                [bgImageView setImage:[UIImage imageNamed:@"couponCell_bg_sel.png"]];
                [cell setTag:kcouponSelectedCellTag];
            }else{
                [bgImageView setImage:[UIImage imageNamed:@"couponCell_bg.png"]];
            }
            [bgImageView setTag:kcouponCellBgViewTag];
            [bgView addSubview:bgImageView];
            [bgImageView release];
            
            //"抵用卷描述："
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(170,5,200, 40)];
            [label setBackgroundColor:[UIColor clearColor]];
            NSString * c_description = [NSString stringWithFormat:@"指定商品满%@元抵%@元",couponVO.threshOld,couponVO.amount];
            [label setText:c_description];
            //        [label setText:couponVO.description];
            [label setNumberOfLines:2];
            [label setFont:[UIFont systemFontOfSize:16.0]];
            [bgView addSubview:label];
            [label release];
            
            //"抵用卷金额："
            label=[[UILabel alloc] initWithFrame:CGRectMake(44, 28, 95, 25)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:[NSString stringWithFormat:@"%@元",couponVO.amount]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]];
            [label setFont:[UIFont systemFontOfSize:22.0]];
            [bgView addSubview:label];
            [label release];
            
            //"抵用卷有效日期："
            label=[[UILabel alloc] initWithFrame:CGRectMake(170, 40, 200, 25)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:[NSString stringWithFormat:@"有效日期:%@ - %@",[OTSUtility NSDateToNSStringDate:couponVO.beginTime],[OTSUtility NSDateToNSStringDate:couponVO.expiredTime]]];
            [label setFont:[UIFont systemFontOfSize:12.0]];
            [label setNumberOfLines:2];
            [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
            [bgView addSubview:label];
            [label release];
            
            [cell addSubview:bgView];
            [bgView release];
            
            // 不可用抵用券加上白色蒙板
            if ([couponVO.canUse isEqualToString:@"false"]) {
                UIView* coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, 470, 104)];
                [coverView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
                [cell addSubview:coverView];
                [coverView release];
                
                label=[[UILabel alloc] initWithFrame:CGRectMake(22, 10, 180, 20)];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:@"未满足使用条件"];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label setTextColor:[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]];
                [label setFont:[UIFont systemFontOfSize:16.0]];
                [coverView addSubview:label];
                [label release];
                [cell setTag:kcouponCanotUseCellTag];
            }
            //"抵用卷规则按钮："
            UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(185, 76, 76, 30)];
            [button setBackgroundColor:[UIColor clearColor]];
            //[button setTitle:[NSString stringWithFormat:@"规 则:%@",couponVO.description] forState:UIControlStateNormal];
            [button setTitle:@"查看规则" forState:UIControlStateNormal];
            //  [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [button.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
            [button setBackgroundImage:[[UIImage imageNamed:@"regulation.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
            [button setTag:[indexPath row]-1];
            [button addTarget:self action:@selector(regulation:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            [button release];
        }
    }else if (tableView == _regulationTableView){   // 规则页面
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.textLabel.text = [currentRegulationArr objectAtIndex:[indexPath row]];
        if (tableView.tag == 0) {
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            [cell.textLabel setTextColor:[UIColor colorWithRed:84.0/255 green:102.0/255 blue:142.0/255 alpha:1.0]];
        }
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] >= [tableView numberOfRowsInSection:0]-2 && currentCouponArr.count < totoalCouponCount && tableView != _regulationTableView) {
        if (!isLoadingMore) {
            [self performInThreadBlock:^(){
                [self getCouponListForSessionOrder];
            }completionInMainBlock:^(){
                [self updateCoupon];
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == m_tableView) {
        if ([indexPath row] == 0) {
            return 150;
        }
        return 120;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == m_tableView) {
        for (int i=1; i<[tableView numberOfRowsInSection:0]; i++) {
            UIImageView* bgView = (UIImageView*)[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] viewWithTag:kcouponCellBgViewTag];
            [bgView setImage:[UIImage imageNamed:@"couponCell_bg.png"]];
        }
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.tag == kcouponCanotUseCellTag || [indexPath row]==0) {
            return;
        }
        CouponVO* tepVo = [currentCouponArr objectAtIndex:[indexPath row]-1];
        self.currentCouponNumber = [tepVo number];
        if (cell.tag == kcouponSelectedCellTag) { // 若为已选择的，删除抵用券
            
            cell.tag = 0;
            [self performInThreadBlock:^(){
                [self deleteCouponFromSessionOrder];
            }completionInMainBlock:^(){
                [self dealWithSaveCouponResult];
            }];
            return;
        }
        UIImageView* currentBg = (UIImageView*)[cell viewWithTag:kcouponCellBgViewTag];
        [currentBg setImage:[UIImage imageNamed:@"couponCell_bg_sel.png"]];
        
        
        [loadingView showInView:self.view];
        [MobClick event:@"click_coupon"];
        [self performInThreadBlock:^(){     // 若为未选择的，保存抵用券到订单
            [self saveCouponToSessionOrder];
        }completionInMainBlock:^(){
            [self dealWithSaveCouponResult];
        }];
    }else if (tableView == _regulationTableView){
        if (tableView.tag != 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NSString* keyWord = [[currentRegulationArr objectAtIndex:[indexPath row]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [DataHandler sharedDataHandler].keyWord = keyWord;
            [[DataHandler sharedDataHandler] saveSearchHistory:keyWord];
            
            [SharedPadDelegate.navigationController popViewControllerAnimated:NO];
            
            [SharedPadDelegate goSearchWithKeyWords:keyWord productListType:5];
        }
    } 
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(couponNumFd);
    OTS_SAFE_RELEASE(m_tableView);
    OTS_SAFE_RELEASE(currentCouponArr);
    OTS_SAFE_RELEASE(couponCheckResult);
    OTS_SAFE_RELEASE(currentCouponNumber);
    OTS_SAFE_RELEASE(loadingView);
    OTS_SAFE_RELEASE(currentRegulationArr);

    [_regulationView release];
    [_regulationTableView release];
    [_regulationTitleLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(couponNumFd);
    OTS_SAFE_RELEASE(m_tableView);
    OTS_SAFE_RELEASE(currentCouponArr);
    OTS_SAFE_RELEASE(couponCheckResult);
    OTS_SAFE_RELEASE(currentCouponNumber);
    OTS_SAFE_RELEASE(loadingView);
    OTS_SAFE_RELEASE(currentRegulationArr);
    OTS_SAFE_RELEASE(errStr);
    [self setRegulationView:nil];
    [self setRegulationTableView:nil];
    [self setRegulationTitleLabel:nil];
    [super viewDidUnload];
}
@end
