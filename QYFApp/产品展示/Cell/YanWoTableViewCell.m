//
//  YanWoTableViewCell.m
//  燕窝模板
//


#import "YanWoTableViewCell.h"



@implementation YanWoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)describeOnClick:(UIButton *)sender {
    [_delegate showPopupWithButton:sender];
}

- (IBAction)contactOnClick:(id)sender {
    [_delegate YanWoTableViewCellWithClick];
}
- (IBAction)reduceBuyNumOnClick:(UIButton *)sender {
    int buyNumber =[_buyNumLabel.text intValue];
    if (buyNumber == 0) {
        return;
    }
    --buyNumber;

    _buyNumLabel.text =[NSString stringWithFormat:@"%d",buyNumber];
    float money = _priceLabel.text.floatValue ;

    [_delegate reduceBuyNumOnClick:sender andBuyNum:_buyNumLabel.text andMoney:money];
}

- (IBAction)addBuyNumOnClick:(UIButton *)sender {
    int buyNumber =[_buyNumLabel.text intValue];
    if (buyNumber ==99) {
        return;
    }
    ++buyNumber;

    _buyNumLabel.text =[NSString stringWithFormat:@"%d",buyNumber];
    float money = _priceLabel.text.floatValue ;
    [_delegate addBuyNumOnClick:sender andBuyNum:_buyNumLabel.text andMoney:money];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
