//
//  ProductBottomView.h
//  QingYanFuYanWo


#import <UIKit/UIKit.h>

@protocol ProductBottomViewDelegate <NSObject>

- (void)BottomViewWithBuyCarButtonOnClick;


- (void)BottomViewWithBuyButtonOnClick;
@end

@interface ProductBottomView : UIView
@property (nonatomic,assign)id<ProductBottomViewDelegate> delegate;
@end
