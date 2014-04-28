//
//  OTSPhoneMotionableView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-9.
//
//

#import <UIKit/UIKit.h>

@protocol OTSPhoneMotionableViewDelegate
@required
-(void)handleMotionEvent;
@end

@interface OTSPhoneMotionableView : UIView <UIAccelerometerDelegate>
@property (assign) id<OTSPhoneMotionableViewDelegate>   delegate;

-(id)initWithDelegate:(id<OTSPhoneMotionableViewDelegate>)aDelegate;

@end
