//
//  SearchBar.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        [self setBackgroundColor:[UIColor clearColor]];
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subview removeFromSuperview];
                break;
            }
        }
    }
    return self;
}

@end
