//
//  HomeFunctionView.m
//  TheStoreApp
//
//  Created by yuan jun on 13-1-21.
//
//

#import "HomeFunctionView.h"
#define MODEAL_IMAGE_WIDTH 60
#define MODEAL_IMAGE_HEIGHT 60
#import "HomeModuleVO.h"
#import "SDImageView+SDWebCache.h"
@implementation HomeFunctionView
@synthesize modulesArray;
-(void)dealloc{
    [modulesArray release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *image;
        for (int i=0; i<4; i++) {
            HomeModuleVO* vo=[[HomeModuleVO alloc] init];
            switch (i) {
                case 0:
                    vo.moduleName=@"1起摇";
                    image=[UIImage imageNamed:@"module_rock.png"];
                    break;
                case 1:
                    vo.moduleName=@"物流查询";
                    image=[UIImage imageNamed:@"module_logistic.png"];
                    break;
                case 2:
                    vo.moduleName=@"扫描";
                    image=[UIImage imageNamed:@"module_scan.png"];
                    break;
                case 3:
                    vo.moduleName=@"品牌旗舰";
                    image=[UIImage imageNamed:@"module_groupon.png"];
                    break;
                default:
                    break;
            }
        }

    }
    return self;
}

- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat xValue=14.0;
    CGFloat yValue=8.0;
    int cout=modulesArray.count>4?4:modulesArray.count;
    for (int i=0;i<cout; i++) {
        HomeModuleVO*modulevo=[modulesArray objectAtIndex:i];
        UIImageView* moduleIcon=[[UIImageView alloc] initWithFrame:CGRectMake(14+(i%4)*77, 100, MODEAL_IMAGE_WIDTH, MODEAL_IMAGE_HEIGHT)];
        moduleIcon.userInteractionEnabled=YES;
        SDWebDataManager*down=[SDWebDataManager sharedManager];
        [down downloadWithURL:[NSURL URLWithString:modulevo.moduleIcon] delegate:self];
//        moduleIcon.image=[UIImage imageNamed:@"60x60-holder.png"];
        [moduleIcon setImageWithURL:[NSURL URLWithString:modulevo.moduleIcon] refreshCache:NO placeholderImage:[UIImage imageNamed:@"60x60-holder.png"]];
        [self addSubview:moduleIcon];
        
        UIButton*but=[UIButton buttonWithType:UIButtonTypeCustom];
        but.frame=CGRectMake(0, 0, MODEAL_IMAGE_WIDTH, MODEAL_IMAGE_HEIGHT);
        but.tag=104+i;
        [but addTarget:self action:@selector(moduleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [moduleIcon addSubview:but];
        [moduleIcon release];
        
        UILabel* lab=[[UILabel alloc] initWithFrame:CGRectMake(1+(i%4)*77, 160, MODEAL_IMAGE_WIDTH+26, 30)];
        lab.text=modulevo.moduleName;
        lab.backgroundColor=[UIColor clearColor];
        [lab setFont:[UIFont systemFontOfSize:14.0]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [self addSubview: lab];
        [lab release];
        
    }

    int i;
    for (i=0; i<4+cout; i++) {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(xValue, yValue, MODEAL_IMAGE_WIDTH , MODEAL_IMAGE_HEIGHT)];
        [button setTag:100+i];
        NSString *moduleName;
        UIImage *image;
        switch (i) {
            case 0:
                moduleName=@"1起摇";
                image=[UIImage imageNamed:@"module_rock.png"];
                break;
            case 1:
                moduleName=@"物流查询";
                image=[UIImage imageNamed:@"module_logistic.png"];
                break;
            case 2:
                moduleName=@"扫描";
                image=[UIImage imageNamed:@"module_scan.png"];
                break;
            case 3:
                moduleName=@"1号团";
                image=[UIImage imageNamed:@"module_groupon.png"];
                break;
            default:
                break;
        }
        if (i>3) {
            HomeModuleVO*modulevo=[modulesArray objectAtIndex:i-4];
            UIImageView* moduleIcon=[[UIImageView alloc] initWithFrame:CGRectMake(14+(i%4)*77, 100, MODEAL_IMAGE_WIDTH, MODEAL_IMAGE_HEIGHT)];
            moduleIcon.userInteractionEnabled=YES;
            SDWebDataManager*down=[SDWebDataManager sharedManager];
            [down downloadWithURL:[NSURL URLWithString:modulevo.moduleIcon] delegate:self];
            //        moduleIcon.image=[UIImage imageNamed:@"60x60-holder.png"];
            [moduleIcon setImageWithURL:[NSURL URLWithString:modulevo.moduleIcon] refreshCache:NO placeholderImage:[UIImage imageNamed:@"60x60-holder.png"]];
            [self addSubview:moduleIcon];
            
            UIButton*but=[UIButton buttonWithType:UIButtonTypeCustom];
            but.frame=CGRectMake(0, 0, MODEAL_IMAGE_WIDTH, MODEAL_IMAGE_HEIGHT);
            but.tag=104+i;
            [but addTarget:self action:@selector(moduleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [moduleIcon addSubview:but];
            [moduleIcon release];
            
            UILabel* lab=[[UILabel alloc] initWithFrame:CGRectMake(1+(i%4)*77, 160, MODEAL_IMAGE_WIDTH+26, 30)];
            lab.text=modulevo.moduleName;
            lab.backgroundColor=[UIColor clearColor];
            [lab setFont:[UIFont systemFontOfSize:14.0]];
            [lab setTextAlignment:NSTextAlignmentCenter];
            [self addSubview: lab];
            [lab release];

        }
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moduleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button release];
        
        if (i == 0) {
            UIImageView* secretImage = [[UIImageView alloc] initWithFrame:CGRectMake(38, 0, 54, 23)];
            [secretImage setImage:[UIImage imageNamed:@"tips.png"]];
            [self addSubview:secretImage];
            [secretImage release];
        }
        
        //倒影
        CALayer *reflectionLayer=[[CALayer alloc] init];
        [reflectionLayer setBounds:CGRectMake(0, 0, MODEAL_IMAGE_WIDTH, MODEAL_IMAGE_HEIGHT)];
        [reflectionLayer setPosition:CGPointMake(xValue+MODEAL_IMAGE_WIDTH/2, yValue+MODEAL_IMAGE_HEIGHT*3/2-3.0)];
        [reflectionLayer setContents:(id)[image CGImage]];
        [reflectionLayer setOpacity:0.3];
        [reflectionLayer setValue:[NSNumber numberWithFloat:-1] forKeyPath:@"transform.scale.y"];
        [self.layer addSublayer:reflectionLayer];
        [reflectionLayer release];
        
        //渐变
        CAGradientLayer *gradientLayer=[[CAGradientLayer alloc] init];
        [gradientLayer setBounds:[reflectionLayer bounds]];
        [gradientLayer setPosition:CGPointMake([reflectionLayer bounds].size.width/2, [reflectionLayer bounds].size.height/2)];
        [gradientLayer setColors:[NSArray arrayWithObjects: (id)[[UIColor clearColor] CGColor],(id)[[UIColor blackColor] CGColor], nil]];
        [gradientLayer setStartPoint:CGPointMake(0.5,0.7)];
        [gradientLayer setEndPoint:CGPointMake(0.5,1.0)];
        [reflectionLayer setMask:gradientLayer];
        [gradientLayer release];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(xValue-13, yValue+75, MODEAL_IMAGE_WIDTH+26, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:moduleName];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
        [label release];
        
        xValue+=77.0;
    }
    

}


@end
