// copiable label class


@interface OTSCopiableLabel : UILabel

@end


@interface OTSAdvancedCopiableLabel : OTSCopiableLabel
@property(nonatomic, copy)  NSString        *textForCopy;
@end
