//
//  BuyView.h
//  QingYanFuYanWo


#import <UIKit/UIKit.h>

@protocol  BuyViewDelegate <NSObject>

- (void)buyViewWithOnClick;

@end

@interface BuyView : UIView
@property (nonatomic,strong)UILabel *storeInfoLabel;
@property (nonatomic,assign)id<BuyViewDelegate> delegate;
@end
