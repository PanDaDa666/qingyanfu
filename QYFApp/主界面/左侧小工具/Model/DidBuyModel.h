//
//  DidBuyModel.h
//  QingYanFuYanWo

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface DidBuyModel : NSObject
@property (nonatomic,strong)NSArray *buyProducts;
@property (nonatomic,copy)NSString *buyName;
@property (nonatomic,copy)NSString *buyAddress;
@property (nonatomic,copy)NSString *buyPhone;
@property (nonatomic,copy)NSString *buyMoney;
@property (nonatomic,copy)NSString *buySituation;
@property (nonatomic,copy)NSString *expressNumber;
@property (nonatomic,strong)AVObject *object;
@end
