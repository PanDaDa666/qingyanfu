//
//  DidBuyCell.m
//  QingYanFuYanWo
//



#import "DidBuyCell.h"

@interface DidBuyCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *buyProductTextField;
@property (weak, nonatomic) IBOutlet UILabel *buyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *buySituationLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressNumberLabel;

@end

@implementation DidBuyCell
- (void)awakeFromNib {
    // Initialization code
    UIImage *image = [UIImage imageNamed:@"appdetail_background"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.backgroundView = imageView;
}

- (void)setModel:(DidBuyModel *)model{
    
    _model = model;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd HH:mm"];
    _timeLabel.text = [df stringFromDate:model.object.createdAt];
    NSString *product = @"";
    for (NSMutableDictionary *dic in model.buyProducts) {
        NSString *productName = [dic objectForKey:@"种类"];
        NSString *productNum = [dic objectForKey:@"件数"];
        product =  [product stringByAppendingFormat:@"%@   %@件  \n",productName,productNum];
    }
    
    _buyProductTextField.text  =product;
    _buyNameLabel.text = [NSString stringWithFormat:@"收货人：%@",model.buyName];
    _buyAddressLabel.text = model.buyAddress;
    _buyAddressLabel.adjustsFontSizeToFitWidth = YES;
    _buyPhoneLabel.text = [NSString stringWithFormat:@"联系方式：%@",model.buyPhone];
    _buySituationLabel.text = [NSString stringWithFormat:@"交易状态：%@",model.buySituation];
    _buyMoneyLabel.text = [NSString stringWithFormat:@"交易金额：%@",model.buyMoney];
    _buyIDLabel.text = model.object.objectId;
    _buyIDLabel.adjustsFontSizeToFitWidth = YES;
    _expressNumberLabel.text = model.expressNumber;
    _expressNumberLabel.adjustsFontSizeToFitWidth = YES;
}


@end
