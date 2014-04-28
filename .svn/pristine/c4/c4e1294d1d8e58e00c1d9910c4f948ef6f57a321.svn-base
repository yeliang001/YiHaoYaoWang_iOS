//
//  OTSWrBoxPageGetter.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-8.
//
//

#import "OTSWrBoxPageGetter.h"
#import "StorageBoxVO.h"
#import "GlobalValue.h"
#import "Page.h"
#import "OTSWeRockService.h"
#import "RockCouponVO.h"
#import "CouponVO.h"
#import "StorageBoxVO.h"

#define BOX_PAGE_SIZE   3

@interface OTSWrBoxPageGetter ()
{
    BOOL    _isRunning;
}
@property (retain) NSMutableArray   *pages;
@property (retain) Page             *currentPage;
@property (retain) NSMutableArray   *itemsCache;    // cache
@end

@implementation OTSWrBoxPageGetter
@synthesize pages = _pages;
@synthesize currentPage = _currentPage;
@synthesize itemsCache = _itemsCache;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_pages release];
    [_currentPage release];
    [_itemsCache release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _pages = [[NSMutableArray alloc] initWithCapacity:10];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogOut) name:NOTIFY_LOG_OUT object:nil];
    }
    return self;
}


-(void)addBoxItem:(StorageBoxVO*)aBoxItem
{
    if (aBoxItem)
    {
        if (self.itemsCache == nil)
        {
            self.itemsCache = [NSMutableArray array];
        }
        
        [self.itemsCache insertObject:aBoxItem atIndex:0];
    }
}

-(StorageBoxVO*)getItemWithProduct:(ProductVO*)aProductVO
{
    if (aProductVO)
    {
        for (StorageBoxVO* boxItem in self.itemsCache)
        {
            ProductVO *theProduct = boxItem.rockProductV2.prodcutVO;
            if ([theProduct isTheSameWithProduct:aProductVO])
            {
                return boxItem;
            }
        }
    }
    
    return nil;
}

-(void)handleLogOut
{
    [self reset];
}

-(BOOL)isRunning
{
    return _isRunning;
}

-(BOOL)canRequestPage
{
    if ([GlobalValue getGlobalValueInstance].token == nil)
    {
        // user is not logged in, all pages r invalid, must reset!
        [self reset];
        return NO;
    }
    
    if (self.currentPage == nil)
    {
        return YES; // current page is nil, means no request has been made, allways can request
    }
    
    int currentPage = [self.currentPage.currentPage intValue]; // current page must >= 1
    NSAssert(currentPage > 0, @"current page must >= 1");
    
    int totalSize = [self.currentPage.totalSize intValue];
    int pageSize = [self.currentPage.pageSize intValue];
    int currentSize = (currentPage - 1) * BOX_PAGE_SIZE + pageSize;
    
    return currentSize < totalSize;
}

-(void)reset
{
    [self.pages removeAllObjects];
    self.currentPage = nil;
    self.itemsCache = nil;
    
    [self performInMainBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_STORAGE_BOX_CHANGED object:nil];
    }];
}

-(void)requestToTheEnd
{
    [NSThread detachNewThreadSelector:@selector(threadRequestToTheEnd) toTarget:self withObject:nil];
}

-(void)threadRequestToTheEnd
{
    @autoreleasepool
    {
        if (!_isRunning)
        {
            _isRunning = YES;
            
            while ([self canRequestPage])
            {
                [self requestPage];
            }
            
            _isRunning = NO;
        }
    }
}

-(void)requestPage
{
    if ([self canRequestPage])
    {
        // do request, this method should run in a sub thread!
        NSAssert(![NSThread isMainThread], @"not in a sub thread");
        
        //int currentPage = self.currentPage.currentPage ? [self.currentPage.currentPage intValue] : 1;
        
        int requestPageNumber = 1;
        if (self.currentPage.currentPage)
        {
            requestPageNumber = [self.currentPage.currentPage intValue] + 1;
        }
        
        self.currentPage = [[OTSWeRockService myInstance]getMyStorageBoxList:[GlobalValue getGlobalValueInstance].token
                                                     type:[NSNumber numberWithInt:kRockBoxQueryAll]
                                              currentPage:[NSNumber numberWithInt:requestPageNumber]
                                                 pageSize:[NSNumber numberWithInt:BOX_PAGE_SIZE]];
        
        if (self.currentPage)
        {
            [self.pages addObject:self.currentPage];
            
            [self refreshCache];
            
            [self performInMainBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_STORAGE_BOX_CHANGED object:nil];
            }];
        }
        else
        {
            self.currentPage = [self.pages lastObject];
        }
    }
}

-(NSArray*)allPageItems
{
    if ([GlobalValue getGlobalValueInstance].token == nil)
    {
        // user is not logged in, all pages r invalid, must reset!
        [self reset];
        return nil;
    }
    
    return self.itemsCache;
}
-(int)totalPageItemsCount{
    return self.itemsCache.count; //[self.currentPage.totalSize intValue];
}
-(void)refreshCache
{
    self.itemsCache = [NSMutableArray array];
    
    NSArray *copiedPages = [NSArray arrayWithArray:self.pages];
    for (Page *thePage in copiedPages)
    {
        if (thePage.objList)
        {
            for (id item in thePage.objList)    // each item should be a StorageBoxVO
            {
                NSAssert([item isKindOfClass:[StorageBoxVO class]], @"item isnt StorageBoxVO");
                
//#warning TEST CODE........>>>>>>>
//                StorageBoxVO* boxVO = (StorageBoxVO*)item;
//                if ([boxVO getItemType] == kRockBoxItemProduct)
//                {
//                    RockProductV2 *product = boxVO.rockProductV2;
//                    
//                }
//                else if ([boxVO getItemType] == kRockBoxItemTicket)
//                {
//                    RockCouponVO *ticket = boxVO.rockCouponVO;
//                }
//#warning TEST CODE........<<<<<<<<<<
                
                [self.itemsCache addObject:item];
            }
        }
    }
}

@end
