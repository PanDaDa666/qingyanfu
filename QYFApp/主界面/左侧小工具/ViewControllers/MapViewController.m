//
//  MapViewController.m
//  QingYanFuYanWo


#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "CLLocation+Sino.h"
#import <CoreLocation/CoreLocation.h>
@interface MapViewController ()<UITextFieldDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) UITextField *searchTextField;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) MKPointAnnotation *annntation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self createLocationManager];
    [self createMapView];
}

- (void)initNavigationBar{
    [self initWithBackBarButton];
    [self setNavigationTitle:@"搜搜你在哪"];
}

-(void)createMapView{
    //创建地图视图
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    //设置代理
    _mapView.delegate = self;
    //设置地图类型
    //    MKMapTypeStandard = 0, 标准
    //    MKMapTypeSatellite,  卫星地图
    //    MKMapTypeHybrid 混合
    _mapView.mapType = MKMapTypeHybrid;
    
    //是否能够拖动
    _mapView.scrollEnabled = YES;
    
//    [self.view insertSubview:_mapView belowSubview:self.searchTextField];
    
    [self.view addSubview:_mapView];
    [self.view addSubview:self.searchTextField];
}

-(void)createLocationManager{
    //创建定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    //设置代理
    _locationManager.delegate = self;
    //设置距离过滤器
    _locationManager.distanceFilter = 100.f;
    //设置精确度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 8.0) {
        //想用户请求
        [_locationManager requestWhenInUseAuthorization];
    }
    //开始定位，如果用户不允许则啥都不做
    [_locationManager startUpdatingLocation];
}


//当选中某个MKAnnotationView 会调用这个方法
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"选择了 这个 view %@",view);
    MKPointAnnotation *annotation = view.annotation;
    NSLog(@"annotation %@",annotation.title);
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //记录当前的位置信息
    _currentLocation = [[locations lastObject] locationMarsFromEarth];

    MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
    
    MKCoordinateRegion region2 = MKCoordinateRegionMake(CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude), span );
    
    _mapView.region = region2;
    
    //设置标题
    self.annntation.title = @"姐姐我";
    //设置副标题
    self.annntation.subtitle = @"就是漂亮";
    //设置坐标
    self.annntation.coordinate =CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
    
    //添加大头针
    [_mapView addAnnotation:self.annntation];

}




- (void)onLeftBackClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark UITextFiledDelegate
//点击return触发的方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //退出第一义响应
    [textField resignFirstResponder];
    //开启动画
//    [self.activityView startAnimating];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    //设置搜索关键字
    request.naturalLanguageQuery = textField.text;
    //设置搜索的范围
    request.region = _mapView.region;
    
    //清除上一次搜索的结果,移除上一次的大头针
    [_mapView removeAnnotations:_mapView.annotations];
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        if (error == nil) {
            //遍历结果，创建大头针
            for (MKMapItem *item in response.mapItems) {
                MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
                //设置大头针标题
                pointAnnotation.title = item.name;
                //设置大头针的副标题
                pointAnnotation.subtitle = item.phoneNumber;
                //设置大头针经纬度的坐标
                pointAnnotation.coordinate = item.placemark.coordinate;
                [_mapView addAnnotation:pointAnnotation];
            }
            //停止等待
//            [self.activityView stopAnimating];
            
        }else{
            NSLog(@"error %@",error);
        }
        
    }];
    return YES;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (MKPointAnnotation *)annntation{
    if (!_annntation) {
        _annntation = [[MKPointAnnotation alloc] init];
    }
    return _annntation;
}
- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, 64, 200, 30)];
        _searchTextField.placeholder = @"请输入关键字搜索";
        _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
        _searchTextField.delegate = self;
    }
    return _searchTextField;
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
