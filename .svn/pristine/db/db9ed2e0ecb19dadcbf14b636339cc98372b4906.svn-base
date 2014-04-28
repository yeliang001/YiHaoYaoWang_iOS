//
//  GameProgressView.m
//  TheStoreApp
//
//  Created by yuan jun on 12-11-2.
//
//

#import "GameProgressView.h"

@implementation GameProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithMaxImage:(UIImage*)maxImage MinImage:(UIImage*)minImage Frame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        max=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        max.image=maxImage;
        [self addSubview:max];
        [max release];
        
        min=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        min.image=minImage;
        min.clipsToBounds=YES;
        [self addSubview:min];
        [min release];

        
    }
    return self;
}

-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)setProgress:(float)progressValue{
    CGSize size=self.frame.size;
    if (progressValue>1) {
        progressValue=1;
    }
   CGRect rect= CGRectMake(0, 0, 98 * progressValue, 8);
    UIImage*img=[UIImage imageNamed:@"game_speaker_max.png"];
    CGImageRef imageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    min.frame=CGRectMake(0, 0, size.width*progressValue, size.height);
    min.image=[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
