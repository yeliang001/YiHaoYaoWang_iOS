//
//  SDButton+SDWebCache.h
//  Complaint51
//
//  Created by mxy on 12-2-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageCompatibly.h"
#import "SDWebDataManager.h"

@interface UIButton (SDWebCacheCategory)<SDWebDataManagerDelegate> {
    
}
- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder;
- (void)cancelCurrentImageLoad;

@end
