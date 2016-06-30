//
//  EFItemView.h
//  QingYanFuYanWo
//


#import <UIKit/UIKit.h>

@protocol EFItemViewDelegate <NSObject>

- (void)didTapped:(NSInteger)index;

@end

@interface EFItemView : UIButton
@property (nonatomic, weak) id <EFItemViewDelegate>delegate;

- (instancetype)initWithNormalImage:(NSString *)normal highlightedImage:(NSString *)highlighted tag:(NSInteger)tag title:(NSString *)title;
@end
