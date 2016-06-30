//
//  CenterViewController.m
//  QingYanFuYanWo
//


#define RADIUS 100.0
#define PHOTONUM 5
#define TAGSTART 1000
#define TIME 1.5
#define SCALENUMBER 1.25

#import "EFItemView.h"
#import "CenterViewController.h"
#import "KnowLedgeViewController.h"
#import "WoyouCircleViewController.h"
#import "HelpViewController.h"
#import "MoreViewController.h"
#import "LoginViewController.h"
#import "ProductViewController.h"
#import "LeftViewController.h"
#import "QuanViewController.h"
NSInteger array [PHOTONUM][PHOTONUM] = {
    {0,1,2,3,4},
    {4,0,1,2,3},
    {3,4,0,1,2},
    {2,3,4,0,1},
    {1,2,3,4,0}
};

@interface CenterViewController ()<EFItemViewDelegate,CNPPopupControllerDelegate>
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) UIButton *leftButton;
@end

@implementation CenterViewController

CATransform3D rotationTransform1[PHOTONUM];


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configNavBar];
    [self registerNotification];
}

- (void)configNavBar{
    [self setNavigationTitle:@"青燕府"];
    UIBarButtonItem *left= [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = left;
    if ([AVUser currentUser]) {
        AVFile *headImage = (AVFile *)[[AVUser currentUser]
                                       objectForKey:@"HeadImage"];
        [self.leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[headImage getThumbnailURLWithScaleToFit:YES width:180 height:180]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"hd_avatar_not_login"]];
    }
    
}

- (void)registerNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoCome:) name:@"CHANGEIMAGE" object:nil];
}

-(void)infoCome:(NSNotification *)no{
    AVFile *headImage = (AVFile *)[[AVUser currentUser]
                                   objectForKey:@"HeadImage"];
    [self.leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[headImage getThumbnailURLWithScaleToFit:YES width:180 height:180]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"hd_avatar_not_login"]];
}


- (void)onLeftClick{
    if ([AVUser currentUser]) {
        AppDelegate *delegate =[UIApplication sharedApplication].delegate;
        JVFloatingDrawerViewController *jvfVc =(JVFloatingDrawerViewController *) delegate.window.rootViewController;
        LeftViewController *left = (LeftViewController *)jvfVc.leftViewController;
        AVFile *headImage = (AVFile *)[[AVUser currentUser]
                                       objectForKey:@"HeadImage"];
        [left.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[headImage getThumbnailURLWithScaleToFit:YES width:180 height:180]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"hd_avatar_not_login"]];
        [jvfVc toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
            
        }];
        
    }else{
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
         UIImage *icon = [UIImage imageNamed:@"login_forbidden.jpg"];
        NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"登录" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
        NSAttributedString *buttonTitle2 = [[NSAttributedString alloc] initWithString:@"取消" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
        CNPPopupController *popupController = [[CNPPopupController alloc] initWithTitle:nil contents:@[icon] buttonTitles:@[buttonTitle,buttonTitle2] destructiveButtonTitle:nil];
        popupController.theme = [CNPPopupTheme defaultTheme];
        popupController.theme.popupStyle = CNPPopupStyleCentered;
        popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromTop;
        popupController.theme.dismissesOppositeDirection = YES;
        popupController.delegate = self;
        [popupController presentPopupControllerAnimated:YES];
    }
    
}

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    if ([title isEqualToString:@"登录"]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }else {
//        NSLog(@"失败");
    }
    
}

- (void)popupControllerWithImageView:(UIImageView *)imageView{
    
}



#pragma mark - configViews

- (void)configViews {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *imagePath = [bundle pathForResource:@"MainImg.jpg" ofType:nil];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    backImageView.contentMode = UIViewContentModeScaleToFill;
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    NSArray *dataArray = @[@"exer_icon_knowledge", @"exer_icon_woyouCircle", @"exer_icon_product", @"exer_icon_help", @"exer_icon_more"];
    CGFloat centery = self.view.center.y - 50;
    CGFloat centerx = self.view.center.x;
    
    for (NSInteger i = 0;i < PHOTONUM;i++) {
        CGFloat tmpy =  centery + RADIUS*cos(2.0*M_PI *i/PHOTONUM);
        CGFloat tmpx =	centerx - RADIUS*sin(2.0*M_PI *i/PHOTONUM);
        EFItemView *view = [[EFItemView alloc] initWithNormalImage:dataArray[i] highlightedImage:[dataArray[i] stringByAppendingFormat:@"%@", @"_hover"] tag:TAGSTART+i title:nil];
        view.frame = CGRectMake(0.0, 0.0,115,115);
        view.center = CGPointMake(tmpx,tmpy);
        view.delegate = self;
        rotationTransform1[i] = CATransform3DIdentity;
        
        CGFloat Scalenumber = fabs(i - PHOTONUM/2.0)/(PHOTONUM/2.0);
        if (Scalenumber < 0.3) {
            Scalenumber = 0.4;
        }
        CATransform3D rotationTransform = CATransform3DIdentity;
        rotationTransform = CATransform3DScale (rotationTransform, Scalenumber*SCALENUMBER,Scalenumber*SCALENUMBER, 1);
        view.layer.transform=rotationTransform;
        [backImageView addSubview:view];
        
    }
    self.currentTag = TAGSTART;
    
}

#pragma mark - EFItemViewDelegate

- (void)didTapped:(NSInteger)index {
    id vc;
    if (self.currentTag  == index) {
        switch (self.currentTag) {
            case 1000:
            {
                vc = [[KnowLedgeViewController alloc] init];
            }
                break;
            case 1001:
            {
               vc = [[WoyouCircleViewController alloc] init];
               // vc = [[QuanViewController alloc]init];
            }
                break;
            case 1002:
            {
                vc = [[ProductViewController alloc] init];
            }
                break;
            case 1003:
            {
                vc= [[HelpViewController alloc] init];
            }
                break;
            case 1004:
            {
                vc= [[MoreViewController alloc] init];
            }
                break;
                
            default:
                break;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    NSInteger t = [self getIemViewTag:index];
    
    for (NSInteger i = 0;i<PHOTONUM;i++ ) {
        
        UIView *view = [self.view viewWithTag:TAGSTART+i];
        [view.layer addAnimation:[self moveanimation:TAGSTART+i number:t] forKey:@"position"];
        [view.layer addAnimation:[self setscale:TAGSTART+i clicktag:index] forKey:@"transform"];
        
        NSInteger j = array[index - TAGSTART][i];
        CGFloat Scalenumber = fabs(j - PHOTONUM/2.0)/(PHOTONUM/2.0);
        if (Scalenumber < 0.3) {
            Scalenumber = 0.4;
        }
    }
    self.currentTag  = index;
}

- (CAAnimation*)setscale:(NSInteger)tag clicktag:(NSInteger)clicktag {
    
    NSInteger i = array[clicktag - TAGSTART][tag - TAGSTART];
    NSInteger i1 = array[self.currentTag  - TAGSTART][tag - TAGSTART];
    CGFloat Scalenumber = fabs(i - PHOTONUM/2.0)/(PHOTONUM/2.0);
    CGFloat Scalenumber1 = fabs(i1 - PHOTONUM/2.0)/(PHOTONUM/2.0);
    if (Scalenumber < 0.3) {
        Scalenumber = 0.4;
    }
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = TIME;
    animation.repeatCount =1;
    
    CATransform3D dtmp = CATransform3DScale(rotationTransform1[tag - TAGSTART],Scalenumber*SCALENUMBER, Scalenumber*SCALENUMBER, 1.0);
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform1[tag - TAGSTART],Scalenumber1*SCALENUMBER,Scalenumber1*SCALENUMBER, 1.0)];
    animation.toValue = [NSValue valueWithCATransform3D:dtmp ];
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

- (CAAnimation*)moveanimation:(NSInteger)tag number:(NSInteger)num {
    // CALayer
    UIView *view = [self.view viewWithTag:tag];
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animation];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,view.layer.position.x,view.layer.position.y);
    
    NSInteger p =  [self getIemViewTag:tag];
    CGFloat f = 2.0*M_PI  - 2.0*M_PI *p/PHOTONUM;
    CGFloat h = f + 2.0*M_PI *num/PHOTONUM;
    CGFloat centery = self.view.center.y - 50;
    CGFloat centerx = self.view.center.x;
    CGFloat tmpy =  centery + RADIUS*cos(h);
    CGFloat tmpx =	centerx - RADIUS*sin(h);
    view.center = CGPointMake(tmpx,tmpy);
    
    CGPathAddArc(path,nil,self.view.center.x, self.view.center.y - 50,RADIUS,f+ M_PI/2,f+ M_PI/2 + 2.0*M_PI *num/PHOTONUM,0);
    animation.path = path;
    CGPathRelease(path);
    animation.duration = TIME;
    animation.repeatCount = 1;
    animation.calculationMode = @"paced";
    return animation;
}

- (NSInteger)getIemViewTag:(NSInteger)tag {
    
    if (self.currentTag >tag){
        return self.currentTag  - tag;
    } else {
        return PHOTONUM  - tag + self.currentTag ;
    }
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    AVFile *headImage = (AVFile *)[[AVUser currentUser]
//                                   objectForKey:@"HeadImage"];
//    [self.leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[headImage getThumbnailURLWithScaleToFit:YES width:180 height:180]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"hd_avatar_not_login"]];
//    
//}

- (UIButton *)leftButton{
    if (!_leftButton) {
        const CGFloat RBW = 35;
        const CGFloat RBH = 35;
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, RBW, RBH)];
        _leftButton.layer.cornerRadius = RBW/2;
        _leftButton.clipsToBounds = YES;
        [_leftButton addTarget:self action:@selector(onLeftClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"hd_avatar_not_login"] forState:UIControlStateNormal];
    }
    return _leftButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
