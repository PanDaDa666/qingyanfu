//
//  BuyViewController.h
//  QingYanFuYanWo


#import "UIBaseViewController.h"
#import "YanwoList.h"

@protocol BuyViewControllerDelegate <NSObject>

-(void)cleanAllSelected;

@end

@interface BuyViewController : UIBaseViewController
@property (nonatomic,assign)id<BuyViewControllerDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *selectedGoodsArr;
@property (nonatomic,copy) NSString *allMoney;
@end
