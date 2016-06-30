//
//  ProductViewController.m
//  QingYanFuYanWo




#import "ProductViewController.h"
#import "ProductBottomView.h"
#import "YanWoTableViewCell.h"
#import "YanwoList.h"
#import "CNPPopupController.h"
#import "PreviewImageView.h"
#import "BuyViewController.h"
@interface ProductViewController ()<ProductBottomViewDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,YanWoTableViewCellDelegate,CNPPopupControllerDelegate,BuyViewControllerDelegate,MBProgressHUDDelegate>
{
    NSInteger _listNum;
    UITableView *_menuTableView;
    UITableView *_yanwoListTableView;
    NSArray *_menuArr;
}
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSMutableArray *singleListArr;
@property (nonatomic,strong) NSMutableArray *yanwoListArr;
@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _listNum = 0;
    _menuArr = [[NSMutableArray alloc] initWithObjects:@"热卖",@"干燕窝",@"即食燕窝",@"促销",@"其他",nil];
    [self initNavigationBar];
    [self configUI];
    [self loadInfo];
}

- (void)initNavigationBar{
    
    [self setNavigationTitle:@"产品展示"];
    [self initWithBackBarButton];
    
}

- (void)configUI{
    ProductBottomView *bottomView = [[ProductBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kBottomHeight, kScreenWidth, kBottomHeight)];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [self createTableView];
}

- (void)loadInfo{
    [self.hud show:YES];
    AVQuery *query = [AVQuery queryWithClassName:@"YanwoProduct"];
    query.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [query orderByAscending:@"productPrice"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.hud hide:YES];
        if (!error) {
        
            NSMutableArray *arr1 = [[NSMutableArray alloc] init];
            NSMutableArray *arr2 = [[NSMutableArray alloc] init];
            NSMutableArray *arr3 = [[NSMutableArray alloc] init];
            NSMutableArray *arr4 = [[NSMutableArray alloc] init];
            NSMutableArray *arr5 = [[NSMutableArray alloc] init];
            for (AVObject *obj in objects) {
                YanwoList *model = [[YanwoList alloc] init];
                model.object = obj;
                if ([[obj objectForKey:@"classify"] isEqualToString:@"热卖"]) {
                    [arr1 addObject:model];
                }
                if ([[obj objectForKey:@"classify"] isEqualToString:@"干燕窝"]) {
                    [arr2 addObject:model];
                }
                if ([[obj objectForKey:@"classify"] isEqualToString:@"即食燕窝"]) {
                    [arr3 addObject:model];
                }
                if ([[obj objectForKey:@"classify"] isEqualToString:@"促销"]) {
                    [arr4 addObject:model];
                }
                if ([[obj objectForKey:@"classify"] isEqualToString:@"其他"]) {
                    [arr5 addObject:model];
                }
            }
            
            [self.yanwoListArr addObject:arr1];
            [self.yanwoListArr addObject:arr2];
            [self.yanwoListArr addObject:arr3];
            [self.yanwoListArr addObject:arr4];
            [self.yanwoListArr addObject:arr5];
            self.singleListArr = self.yanwoListArr[_listNum];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_yanwoListTableView reloadData];
            });
        }
    }];

}

- (void)createTableView{

    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMenuTableViewWidth, kScreenHeight-kBottomHeight-64) style:UITableViewStylePlain];
    _menuTableView.estimatedRowHeight = 10;
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.backgroundColor = [UIColor whiteColor];
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_menuTableView];
    [_menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    _yanwoListTableView = [[UITableView alloc] initWithFrame:CGRectMake(kMenuTableViewWidth, 64, kScreenWidth-kMenuTableViewWidth, kScreenHeight-kBottomHeight-64) style:UITableViewStyleGrouped];
    _yanwoListTableView.delegate = self;
    _yanwoListTableView.dataSource = self;
    _yanwoListTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:_yanwoListTableView];
    
}

#pragma mark ProductBottomViewDelegate
- (void)BottomViewWithBuyCarButtonOnClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要清空购物车吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)BottomViewWithBuyButtonOnClick{
    // 跳转到填写信息付款界面
    UILabel *label = (UILabel *)[self.view viewWithTag:kProductBottomView_MoneyLabelTag];
    
    if ([label.text isEqualToString:@"￥ 0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还未选择任何商品哦~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else
    {
        BuyViewController *buy = [[BuyViewController alloc] init];
        buy.delegate = self;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i=0; i<self.yanwoListArr.count; i++) {
            for (YanwoList *model in self.yanwoListArr[i]) {
                if (![model.buyNum isEqualToString:@"0"]) {
                    [arr addObject:model];
                }
            }
        }
        buy.selectedGoodsArr = arr;
        buy.allMoney = label.text;
        [self.navigationController pushViewController:buy animated:NO];
        
    }
}

- (void)cleanAllSelected{
    [self cleanCart];
}


- (void)cleanCart{
    for (int i=0; i<self.yanwoListArr.count; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (YanwoList *ywModel in self.yanwoListArr[i]) {
            ywModel.buyNum = @"0";
            [arr addObject:ywModel];
        }
        self.yanwoListArr[i] = arr;
    }
    self.singleListArr = self.yanwoListArr[_listNum];
    [_yanwoListTableView reloadData];
    UILabel *label = (UILabel *)[self.view viewWithTag:kProductBottomView_MoneyLabelTag];
    label.text = [NSString stringWithFormat:@"￥ 0"];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_menuTableView == tableView ) {
        return _menuArr.count;
    }
    else{
        
        return self.singleListArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_menuTableView ==tableView) {
        static NSString *cellIde = @"CELLIDE";
        UITableViewCell *cell1 =  [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        cell1.layer.borderColor = [UIColor whiteColor].CGColor;
        cell1.textLabel.font = [UIFont systemFontOfSize:14];
        cell1.layer.borderWidth = 0.3;
        cell1.textLabel.text = _menuArr[indexPath.row];
        
        cell1.contentView.backgroundColor = [UIColor clearColor];
        UIView *aView = [[UIView alloc] initWithFrame:cell1.bounds];
        UIView *acView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 50)];
        acView.backgroundColor = [UIColor orangeColor];
        [aView addSubview:acView];
        aView.backgroundColor = [UIColor whiteColor];
        cell1.selectedBackgroundView = aView;
        cell1. backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        return cell1;
    }else{
        static NSString *cellIde2 = @"CELLIDE2";
        YanWoTableViewCell *cell2 =[tableView dequeueReusableCellWithIdentifier:cellIde2];
        if (cell2 ==nil) {
            cell2 = [[[NSBundle mainBundle]loadNibNamed:@"YanWoTableViewCell" owner:self options:nil]lastObject];
        }
        AVFile *productImageFile =[self.singleListArr[indexPath.row] productImage] ;
        [cell2.imageNameImageView sd_setImageWithURL:[NSURL URLWithString:productImageFile.url] placeholderImage:[UIImage imageNamed:@"empty_list_search_2.jpg"]];
        cell2.imageNameImageView.tag = kYanWoTableViewCell_imageNameImageView+indexPath.row;
        cell2.TitleNameLabel.text = [self.singleListArr[indexPath.row]productName];
        cell2.priceLabel.adjustsFontSizeToFitWidth = YES;
        cell2.priceLabel.text = [self.singleListArr[indexPath.row]productPrice];
        
        cell2.sellNumLabel.text = [self.singleListArr[indexPath.row]didBuyNumber];
        cell2.buyNumLabel.text = [self.singleListArr[indexPath.row]buyNum];
        cell2.reduceBuyNumBtn.tag = kYanWoTableViewCell_reduceBuyNumBtnTag+indexPath.row;
        cell2.addBuyNumBtn.tag = kYanWoTableViewCell_addBuyNumBtnTag+indexPath.row;
        cell2.describeButton.tag = kYanWoTableViewCell_describeButton+indexPath.row;
        cell2.delegate =self;
        return cell2;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_menuTableView == tableView) {
        if (!self.yanwoListArr.count) {
            
        }else{
        _listNum = indexPath.row;
        self.singleListArr = self.yanwoListArr[indexPath.row];
        [_yanwoListTableView reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_yanwoListTableView==tableView) {
        return FOOTERHEIGHT;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_yanwoListTableView==tableView) {
        return HEADERHEIGHT;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_menuTableView == tableView) {
        return 50;
    }else{
        return ROWHEIGHT;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_yanwoListTableView == tableView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-kMenuTableViewWidth, HEADERHEIGHT)];
        label.text = _menuArr[_listNum];
        return label;
    }else{
        return nil;
    }
    
}

#pragma mark YanWoTableViewCellDelegate
-(void)reduceBuyNumOnClick:(UIButton *)btn andBuyNum:(NSString *)buyNum andMoney:(float)money {
    YanwoList *model = self.singleListArr[btn.tag-kYanWoTableViewCell_reduceBuyNumBtnTag];
    model.buyNum = buyNum;
    self.singleListArr[btn.tag-kYanWoTableViewCell_reduceBuyNumBtnTag] = model;
    self.yanwoListArr[_listNum] = self.singleListArr;
    UILabel *label = (UILabel *)[self.view viewWithTag:kProductBottomView_MoneyLabelTag];
    NSString *str = [label.text substringFromIndex:1];
    label.text = [NSString stringWithFormat:@"￥ %.f",str.floatValue-money];
}

-(void)addBuyNumOnClick:(UIButton *)btn andBuyNum:(NSString *)buyNum andMoney:(float)money {
    YanwoList *model = self.singleListArr[btn.tag-kYanWoTableViewCell_addBuyNumBtnTag];
    model.buyNum = buyNum;
    self.singleListArr[btn.tag-kYanWoTableViewCell_addBuyNumBtnTag] = model;
    self.yanwoListArr[_listNum] = self.singleListArr;
    UILabel *label = (UILabel *)[self.view viewWithTag:kProductBottomView_MoneyLabelTag];
    NSString *str = [label.text substringFromIndex:1];
    label.text = [NSString stringWithFormat:@"￥ %.f",str.floatValue+money];
}

- (void)YanWoTableViewCellWithClick{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"联系客服" message:@"尊敬的客户您好！软件正在优化，购买支付系统尚未开通，购买请联系客服手机18762814272或者V号yanqing535996399,谢谢您的谅解" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [self.view addSubview:alert];
    [alert show];
}

-(void)showPopupWithButton:(UIButton *)btn {
    [self showPopupWithStyle:CNPPopupStyleCentered andButton:btn];
}

#pragma  mark CNPPopupControllerDelegate
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andButton:(UIButton *)btn {
    // NSMutableParagraphStyle 段落的风格（设置首行，行间距，对齐方式什么的）
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;//行中断模式:结尾部分的内容以什么方式显示(这里是以单个字词为中断)
    paragraphStyle.alignment = NSTextAlignmentCenter;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
    // 初始化富文本字符串
    //    属性字符串NSAtrributeString 和 NSString 普通字符串的 转换方法:
    //    一:把普通的字符串,替换为包含图片的属性字符串
    //    plist 文件,图片 格式
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"商品详情" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString * productName= [[NSAttributedString alloc] initWithString:[self.singleListArr[btn.tag-kYanWoTableViewCell_describeButton] productName] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:[self.singleListArr[btn.tag-kYanWoTableViewCell_describeButton] describeLong] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName : paragraphStyle}];
    UIImageView *imageView = (UIImageView*)[self.view viewWithTag:btn.tag-kYanWoTableViewCell_describeButton+kYanWoTableViewCell_imageNameImageView];
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"返回" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupController *popupController = [[CNPPopupController alloc] initWithTitle:title contents:@[imageView.image,productName,lineOne] buttonTitles:@[buttonTitle] destructiveButtonTitle:nil];
    popupController.theme = [CNPPopupTheme defaultTheme];
    popupController.theme.popupStyle = popupStyle;
    popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromTop;
    popupController.theme.dismissesOppositeDirection = YES;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}

- (void)popupControllerWithImageView:(UIImageView *)imageView{
    [self createTapGesture:imageView];
}

- (void)createTapGesture:(UIImageView *)imageView{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    tapGR.cancelsTouchesInView = YES;
    tapGR.delaysTouchesBegan = NO;
    tapGR.delaysTouchesEnded = NO;
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    [tapGR addTarget:self action:@selector(handleTapView:)];
    [imageView addGestureRecognizer:tapGR];
}


- (void)handleTapView:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [imageView convertRect:imageView.bounds toView:windows];
    [PreviewImageView showPreviewImage:imageView.image startImageFrame:startRect inView:windows viewFrame:kScreenBounds];
}



#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self cleanCart];
    }
}


#pragma mark getter
- (NSMutableArray *)singleListArr{
    if (!_singleListArr) {
        _singleListArr = [[NSMutableArray alloc] init];
    }
    return _singleListArr;
}

- (NSMutableArray *)yanwoListArr{
    if (!_yanwoListArr) {
        _yanwoListArr = [[NSMutableArray alloc] init];
    }
    return _yanwoListArr;
}


- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
        _hud.labelText = @" >_< 正在努力初次加载中...";
        _hud.delegate = self;
    }
    return _hud;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
