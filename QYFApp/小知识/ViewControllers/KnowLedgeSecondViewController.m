//
//  KnowLedgeSecondViewController.m
//  QingYanFuYanWo
//


#import "KnowLedgeSecondViewController.h"
#import "KnowledgeScrollFrame.h"
#import "KnowledgeScrollView.h"

@interface KnowLedgeSecondViewController ()<UMSocialDataDelegate,UMSocialUIDelegate>
@property (nonatomic,strong)KnowledgeScrollFrame *knowledgeScrollFrame;
@end

@implementation KnowLedgeSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Gray_COLOR;
    [self confiUI];
    [self initNavigationBar];
}

- (void)confiUI{
    KnowledgeScrollView *scrollView = [[KnowledgeScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) AndScrollFrame:self.knowledgeScrollFrame];
    [self.view addSubview:scrollView];
}

- (void)initNavigationBar{
    [self initWithShareBarButton];
    [self initWithBackBarButton];
}


- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response{
    
}



- (KnowledgeScrollFrame *)knowledgeScrollFrame{
    if (!_knowledgeScrollFrame) {
        _knowledgeScrollFrame = [[KnowledgeScrollFrame alloc] init];
        _knowledgeScrollFrame.knowledgeModel = _knowledgeModel;
    }
    return _knowledgeScrollFrame;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AVObject *knowledge = [AVObject objectWithoutDataWithClassName:@"Knowledge" objectId:_knowledgeModel.objectID];
    [knowledge setObject:[NSNumber numberWithInt:0] forKey:@"upvotes"];
    knowledge.fetchWhenSave = YES;
    [knowledge incrementKey:@"upvotes"];
    [knowledge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];
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
