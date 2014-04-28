//
//  OTSTabView.h
//  TheStoreApp
//
//  Created by jiming huang on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTSTabViewDelegate

@required
-(void)tabClickedAtIndex:(NSNumber *)index;

@end

@interface OTSTabView : UIView {
    NSArray *m_Titles;
    id m_Delegate;
    int m_SelectedIndex;
}

-(id)initWithFrame:(CGRect)frame titles:(NSArray *)titles imgtabs:(NSArray *)imgtabs delegate:(id<OTSTabViewDelegate>)delegate;
@end
