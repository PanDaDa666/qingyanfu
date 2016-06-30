//
//  YanWoTableViewCell.h
//  燕窝模板
//


#import <UIKit/UIKit.h>

@protocol YanWoTableViewCellDelegate <NSObject>

-(void)reduceBuyNumOnClick:(UIButton *)btn andBuyNum:(NSString *)buyNum andMoney:(float)money;
-(void)addBuyNumOnClick:(UIButton *)btn andBuyNum:(NSString *)buyNum andMoney:(float)money;
-(void)showPopupWithButton:(UIButton *)btn;

- (void)YanWoTableViewCellWithClick;

@end

@interface YanWoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageNameImageView;
@property (weak, nonatomic) IBOutlet UILabel *TitleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *describeButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceBuyNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBuyNumBtn;
@property (weak, nonatomic) id<YanWoTableViewCellDelegate> delegate;




@end
