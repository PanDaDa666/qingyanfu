//
//  ProductBottomView.m
//  QingYanFuYanWo


#import "ProductBottomView.h"
#import "Masonry.h"

@interface ProductBottomView()
{
    UILabel * _moneyLabel;
    UIButton *_buyCarButton;
    UIButton *_buyButton;
}

@end

@implementation ProductBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BLUE_COLOR;
        [self configUI];
    }
    return self;
}

- (void)configUI{
    _buyCarButton = [[UIButton alloc] init];
    [_buyCarButton setBackgroundImage:[UIImage imageNamed:@"order_buy"] forState:UIControlStateNormal];
    [_buyCarButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    _buyCarButton.tag = kProductBottomView_BuyCarButtonTag;
    [self addSubview:_buyCarButton];
    [_buyCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(30);
        make.width.equalTo(self.mas_height).offset(-10);
        make.height.equalTo(self.mas_height).offset(-10);
    }];
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.font = [UIFont boldSystemFontOfSize:20];
    _moneyLabel.backgroundColor = [UIColor clearColor];
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.text = @"￥ 0";
    _moneyLabel.tag = kProductBottomView_MoneyLabelTag;
    [self addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_buyCarButton.mas_right).offset(10);
        make.width.equalTo(@(100));
        make.height.equalTo(self.mas_height);
    }];
    
    _buyButton = [[UIButton alloc] init];
    [_buyButton setTitle:@"结算" forState:UIControlStateNormal];
    [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buyButton.tag = kProductBottomView_BuyButtonTag;
    [self addSubview:_buyButton];
    _buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [_buyButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.equalTo(self.mas_height);
        make.height.equalTo(self.mas_height);
    }];
    
}

- (void)onClick:(UIButton *)btn{
    switch (btn.tag) {
        case kProductBottomView_BuyButtonTag:
        {
            if ([_delegate respondsToSelector:@selector(BottomViewWithBuyButtonOnClick)]) {
                [_delegate BottomViewWithBuyButtonOnClick];
            }else{
                NSLog(@"没有遵守协议或者代理");
            }
            
        }
            break;
        case kProductBottomView_BuyCarButtonTag:
        {
            if ([_delegate respondsToSelector:@selector(BottomViewWithBuyCarButtonOnClick)]) {
                [_delegate BottomViewWithBuyCarButtonOnClick];
            }else{
                NSLog(@"没有遵守协议或者没有代理");
            }
        }
            break;
        default:
            break;
    }
}


@end
