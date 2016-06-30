//
//  YanwoList.m
//  QingYanFuYanWo


#import "YanwoList.h"


@implementation YanwoList

- (void)setObject:(AVObject *)object{
    _object = object;
    _productImage = [object objectForKey:@"productImage"];
    _productName = [object objectForKey:@"productName"];
    _productPrice = [object objectForKey:@"productPrice"];
    _didBuyNumber = [object objectForKey:@"didBuyNumber"];
    _describeLong = [object objectForKey:@"describeLong"];
    _buyNum = @"0";
}
@end
