//
//  NSString+DocumentPath.m
//  气泡
//


#import "NSString+DocumentPath.h"

@implementation NSString (DocumentPath)
+(NSString *)documentPathWith:(NSString *)fileName
{

    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
}
@end
