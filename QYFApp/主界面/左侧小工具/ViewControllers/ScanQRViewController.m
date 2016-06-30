//
//  ScanQRViewController.m
//  QingYanFuYanWo
//


#import "ScanQRViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanQRViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIWebViewDelegate>
{
    UIView *_QrCodeline;
    
    NSTimer *_timer;
    
    //设置扫描画面
    
    UIView *_scanView;
}
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//设置输出类型为Metadata，因为这种输出类型中可以设置扫描的类型，譬如二维码
//当启动摄像头开始捕获输入时，如果输入中包含二维码，就会产生输出
@property(nonatomic)AVCaptureMetadataOutput *output;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation ScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setScanView];
    [self initNavigationBar];
    [self initQR];
    
}

- (void)initNavigationBar{
    [self initWithBackBarButton];
    [self setNavigationTitle:@"扫二维码"];
}

- (void)setScanView

{
    
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenWidth-64)];
    
    _scanView.backgroundColor=[UIColor clearColor];
    
    //最上部view
    
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,SCANVIEW_EdgeTop)];
    
    upView.alpha =TINTCOLOR_ALPHA;
    
    upView.backgroundColor = [UIColor blackColor];
    
    [_scanView addSubview:upView];
    
    //左侧的view
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,kScreenWidth-2*SCANVIEW_EdgeLeft)];
    
    leftView.alpha =TINTCOLOR_ALPHA;
    
    leftView.backgroundColor = [UIColor blackColor];
    
    [_scanView addSubview:leftView];
    
    /******************中间扫描区域****************************/
    
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, kScreenWidth-2*SCANVIEW_EdgeLeft,kScreenWidth-2*SCANVIEW_EdgeLeft)];
    
    //scanCropView.image=[UIImage imageNamed:@""];
    
    scanCropView.layer.borderColor=[UIColor blueColor].CGColor;
    
    scanCropView.layer.borderWidth=2.0;
    
    scanCropView.backgroundColor=[UIColor clearColor];
    
    [_scanView addSubview:scanCropView];
    
    //右侧的view
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,kScreenWidth-2*SCANVIEW_EdgeLeft)];
    
    rightView.alpha =TINTCOLOR_ALPHA;
    
    rightView.backgroundColor = [UIColor blackColor];
    
    [_scanView addSubview:rightView];
    
    //底部view
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenWidth-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop,kScreenWidth, kScreenHeight-(kScreenWidth-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop)-64)];
    
    //downView.alpha = TINTCOLOR_ALPHA;
    
    downView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:TINTCOLOR_ALPHA];
    
    [_scanView addSubview:downView];
    
    //用于说明的label
    
    UILabel *labIntroudction= [[UILabel alloc] init];
    
    labIntroudction.backgroundColor = [UIColor clearColor];
    
    labIntroudction.frame=CGRectMake(0,5, kScreenWidth,20);
    
    labIntroudction.numberOfLines=1;
    
    labIntroudction.font=[UIFont systemFontOfSize:15.0];
    
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    
    labIntroudction.textColor=[UIColor whiteColor];
    
    labIntroudction.text=@"将二维码对准方框，即可自动扫描";
    
    [downView addSubview:labIntroudction];
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, downView.frame.size.height-100.0,kScreenWidth, 100.0)];
    
    darkView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:DARKCOLOR_ALPHA];
    
    [downView addSubview:darkView];
    
    //用于开关灯操作的button
    
    UIButton *openButton=[[UIButton alloc] initWithFrame:CGRectMake(10,20, 300.0, 40.0)];
    
    [openButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    
    [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    openButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    openButton.backgroundColor=[UIColor blueColor];
    
    openButton.titleLabel.font=[UIFont systemFontOfSize:22.0];
    
    [darkView addSubview:openButton];
    
    //画中间的基准线
    
    _QrCodeline = [[UIView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, kScreenWidth-2*SCANVIEW_EdgeLeft,2)];
    
    _QrCodeline.backgroundColor = [UIColor blueColor];
    
    [_scanView addSubview:_QrCodeline];
    
}

- (void)initQR{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理，一旦扫描到指定类型的数据，就会通过代理输出
    //在扫描的过程中，会分析扫描的内容，分析成功后就会调用代理方法输出
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    //指定当扫描到二维码的时候，产生输出
    //AVMetadataObjectTypeQRCode 指定二维码
    //指定识别类型一定要放到添加到session之后
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    [self.previewLayer addSublayer:_scanView.layer];
    //
    //开始启动
    [self.session startRunning];
    [self createTimer];
}


#pragma mark -
#pragma mark 输出的代理
//metadataObjects ：把识别到的内容放到该数组中
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //停止扫描
    [self.session stopRunning];
    
    if ([metadataObjects count] >= 1) {
        //数组中包含的都是AVMetadataMachineReadableCodeObject 类型的对象，该对象中包含解码后的数据
        AVMetadataMachineReadableCodeObject *qrObject = [metadataObjects lastObject];
        NSLog(@"识别成功%@",qrObject.stringValue);
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    
        NSURL *url = [NSURL URLWithString:qrObject.stringValue];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //创建webView ->UIView
        UIWebView *webView = [[UIWebView alloc ]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        //设置背景颜色
        webView.backgroundColor = [UIColor redColor];
        webView.scrollView.backgroundColor = BLUE_COLOR;
        //根据请求对象去加载html页面
        [webView  loadRequest:request];
        //设置代理
        webView.delegate = self;
        [self.view addSubview:webView];
    }
}





- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [self stopTimer];
    [self.session stopRunning];
    
}

//二维码的横线移动

- (void)moveUpAndDownLine

{
    CGFloat Y=_QrCodeline.frame.origin.y;
    if (kScreenWidth-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, kScreenWidth-2*SCANVIEW_EdgeLeft,1);
        [UIView commitAnimations];
        
    }else if(SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, kScreenWidth-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, kScreenWidth-2*SCANVIEW_EdgeLeft,1);
        [UIView commitAnimations];
    }
}


- (void)createTimer

{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}


- (void)stopTimer

{
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer =nil;
    }
}

- (void)onLeftBackClick{
    [self dismissViewControllerAnimated:YES completion:nil];
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
