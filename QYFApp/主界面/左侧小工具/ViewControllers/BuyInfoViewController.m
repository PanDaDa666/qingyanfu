//
//  BuyInfoViewController.m
//  QingYanFuYanWo


#import "BuyInfoViewController.h"
#import "DidBuyModel.h"
#import "DidBuyCell.h"

@interface BuyInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    UIImageView *_backImageView;
}
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation BuyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backgroundImageView];
    [self initNavigationBar];
    [self createCollectionView];
    [self loadInfo];
}

- (void)backgroundImageView{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *imagePath = [bundle pathForResource:@"MainImg.jpg" ofType:nil];
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.userInteractionEnabled = YES;
    [self.view addSubview:_backImageView];
}

- (void)initNavigationBar{
    [self initWithBackBarButton];
    [self setNavigationTitle:@"订单详情"];
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kKnowledgeCell_Weight, 335);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 50.0;
    layout.headerReferenceSize = CGSizeMake(0, 50);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"DidBuyCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DidBuyCell"];
    _collectionView.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadInfo];
    }];
    [_backImageView addSubview:_collectionView];
}

- (void)loadInfo{
    AVQuery *query = [AVQuery queryWithClassName:@"DidBuy"];
    query.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"buyNameID" equalTo:[AVUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [_collectionView.header endRefreshing];
        if (!error) {
            [self.dataSource removeAllObjects];
            for (AVObject *obj in objects) {
                DidBuyModel *model = [[DidBuyModel alloc] init];
                model.object = obj;
                [self.dataSource addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
        }else{
            NSLog(@"加载失败");
        }
    }];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DidBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DidBuyCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    return cell;
}



- (void)onLeftBackClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
