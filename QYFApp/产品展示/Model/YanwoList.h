//
//  YanwoList.h
//  QingYanFuYanWo
//


#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface YanwoList : NSObject
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *didBuyNumber;
@property (nonatomic,copy) NSString *describeLong;
@property (nonatomic,copy) NSString *productPrice;
@property (nonatomic,strong) AVFile *productImage;
@property (nonatomic,copy) NSString *buyNum;
@property (nonatomic,strong)AVObject *object;
@end
