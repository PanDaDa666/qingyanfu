//
//  WordsModel+NetWork.h
//  QingYanFuYanWo

#import "WordsModel.h"
#import "AFNetworking.h"
typedef void(^ModelRequestBlock)(NSArray *array,NSError *error);

@interface WordsModel (NetWork)

+(void)requestWithPageNumber:(NSInteger)dayNumber andRequestBlock:(ModelRequestBlock )requestBlock;

@end
