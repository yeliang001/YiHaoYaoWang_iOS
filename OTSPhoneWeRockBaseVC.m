//
//  OTSPhoneWeRockBaseVC.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//
#import <AudioToolbox/AudioToolbox.h>
#import <MobileCoreServices/MobileCoreServices.h>


#import "OTSPhoneWeRockBaseVC.h"
#import "TheStoreAppAppDelegate.h"



@interface OTSPhoneWeRockBaseVC ()
{
    dispatch_queue_t    _disPatchQueue;
}
@end

@implementation OTSPhoneWeRockBaseVC
@synthesize naviBar = _naviBar;


- (void)dealloc
{
    dispatch_release(_disPatchQueue);
    _disPatchQueue = NULL;
    
    [_naviBar release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    _disPatchQueue  = dispatch_queue_create([[NSString stringWithFormat:@"%@.%@", [self.class description], self] UTF8String], NULL);
    
    // 视图初始化
    [super viewDidLoad];
	
    // add navi bar
    self.naviBar = [[[OTSNavigationBar alloc] initWithTitle:@"1起摇"
                                                               backTitle:@" 返回"
                                                 backAction:nil
                                                        backActionTarget:self] autorelease];
    
    
    [self.view addSubview:self.naviBar];
    
}
#pragma mark --
-(void)performInThreadBlock:(void(^)())aInThreadBlock
{
    dispatch_async(_disPatchQueue, ^{
        
        aInThreadBlock();
        
    });
}

-(void)performInThreadBlock:(void(^)(id obj))aInThreadBlock withObject:(id)anObject
{
    dispatch_async(_disPatchQueue, ^{
        
        aInThreadBlock(anObject);
        
    });
}


-(void)performInThreadBlock:(void(^)())aInThreadBlock completionInMainBlock:(void(^)())aCompletionInMainBlock
{
    dispatch_async(_disPatchQueue, ^{
        
        aInThreadBlock();
        
        [[NSRunLoop mainRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];//the next time through the run loop.
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            aCompletionInMainBlock();
            
        });
    });
}

@end
