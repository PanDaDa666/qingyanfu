//
//  BuyViewController.m
//  QingYanFuYanWo


#import "BuyViewController.h"
#import "BuyView.h"
@interface BuyViewController ()<BuyViewDelegate,MBProgressHUDDelegate>
{
    BuyView *_buyView;
}
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Gray_COLOR;
    [self initNavigationBar];
    [self configUI];
}

- (void)initNavigationBar{
    [self setNavigationTitle:@"收货信息"];
    [self initWithBackBarButton];
}

- (void)configUI{
    _buyView =[[BuyView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    _buyView.delegate = self;
    _buyView.storeInfoLabel.text = [NSString stringWithFormat:@"您一共挑选了 %ld 件商品, 合计: %@",(unsigned long)self.selectedGoodsArr.count,self.allMoney];
    [self.view addSubview:_buyView];
}

- (void)buyViewWithOnClick{
    UITextField *phoneText= (UITextField *)[self.view viewWithTag:kBuyView_PhoneTag];
    UITextField *addressText = (UITextField *)[self.view viewWithTag:kBuyView_AddressTag];
    UITextField *userNameText = (UITextField *)[self.view viewWithTag:kBuyView_UserNameTag];
    if (phoneText.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的手机号码输入有误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else if(addressText.text.length==0|userNameText.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的信息未填写完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [self.hud show:YES];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (YanwoList *model in self.selectedGoodsArr) {
            NSDictionary *dic = @{@"种类":model.productName,@"件数":model.buyNum};
            [array addObject:dic];
        }
        AVObject *buyObject = [AVObject objectWithClassName:@"DidBuy"];
        [buyObject setObject:[[AVUser currentUser] objectId] forKey:@"buyNameID"];
        [buyObject setObject:addressText.text forKey:@"buyAddress"];
        [buyObject setObject:phoneText.text forKey:@"buyPhone"];
        [buyObject setObject:userNameText.text forKey:@"buyName"];
        [buyObject setObject:array forKey:@"BuyProducts"];
        [buyObject setObject:self.allMoney  forKey:@"BuyMoney"];
        [buyObject setObject:@"未支付" forKey:@"BuySituation"];
        [buyObject setObject:@"未发货" forKey:@"ExpressNumber"];
        [buyObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.hud hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜!" message:@"提交成功，稍候有客服联系您，谢谢！！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag = kBuyViewController_alertTag;
                [alert show];
            }else{
                [self.hud hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }];
    }
}

-(void)hudWasHidden:(MBProgressHUD *)hud {
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kBuyViewController_alertTag) {
        [self.navigationController popViewControllerAnimated:NO];
        if (_delegate && [_delegate respondsToSelector:@selector(cleanAllSelected)]) {
            [_delegate cleanAllSelected];
        }
    }
}


-(MBProgressHUD *)hud {
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.labelText = @"正在上传中,请稍后...";
        _hud.delegate = self;
    }
    return _hud;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any  that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
