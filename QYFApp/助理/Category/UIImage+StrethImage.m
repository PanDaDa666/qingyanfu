//
//  UIImage+StrethImage.m
//  气泡
//


#import "UIImage+StrethImage.h"

@implementation UIImage (StrethImage)

+(id)strethImageWith:(NSString *)imageName
{
    UIImage *image=[UIImage imageNamed:imageName];
    
    image=[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    
    return image;
}
@end
