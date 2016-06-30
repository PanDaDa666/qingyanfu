//
//  DidBuyModel.m
//  QingYanFuYanWo
//

#import "DidBuyModel.h"

@implementation DidBuyModel
- (void)setObject:(AVObject *)object{
    _object =object;
    _buyProducts = [object objectForKey:@"BuyProducts"];
    _buyName = [object objectForKey:@"buyName"];
    _buyAddress = [object objectForKey:@"buyAddress"];
    _buyPhone = [object objectForKey:@"buyPhone"];
    _buyMoney = [object objectForKey:@"BuyMoney"];
    _buySituation = [object objectForKey:@"BuySituation"];
    _expressNumber = [object objectForKey:@"ExpressNumber"];
}
@end
