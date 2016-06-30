//
//  WoyouCircleCollectionViewCell.m
//  QingYanFuYanWo
//

#import "WoyouCircleCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "PreviewImageView.h"
@interface WoyouCircleCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *picNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mothLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UILabel *zanNumLabel;

@end


@implementation WoyouCircleCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(WordsModel *)model{
    _model = model;
    NSArray *strAuthorArray=[model.strAuthor componentsSeparatedByString:@"&"];
    NSArray *dateArray=[model.strMarketTime componentsSeparatedByString:@"-"];
    UIImage *image = [UIImage imageNamed:@"contBack"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    _backImageVIew.image = image;
    [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:model.strOriginalImgUrl]placeholderImage:[UIImage imageNamed:@"empty_list_search_2.jpg"]];
    UIImage *image02 = [UIImage imageNamed:@"home_likeBg"];
    image02 = [image02 stretchableImageWithLeftCapWidth:floorf(image02.size.width/2) topCapHeight:floorf(image02.size.height/2)];
    _zanImageView.image = image02;
    _idLabel.text=_model.strHpTitle;
    _picNameLabel.text = strAuthorArray[0];
    _authorLabel.text = strAuthorArray[1];
    _wordsLabel.text= model.strContent;
    _dayLabel.text=dateArray[2];
    NSString * str=[self month:dateArray[1]];
    _mothLabel.text=[NSString stringWithFormat:@"%@.%@",str,dateArray[0]];
    _zanNumLabel.text = model.strPn;
    if (!_model.zan) {
        _zanButton.selected = NO;
    }else{
        _zanButton.selected = YES;
    }
    [_backImageVIew addSubview:_wordsLabel];
    [self createTapGesture:_pictureImageView];
}
-(NSString *)month:(NSString *)str{
    if([str isEqual:@"01"]){
        return @"Jan";
    }else if ([str isEqual:@"02"]){
        return @"Feb";
        
    }else if ([str isEqual:@"03"]){
        return @"Mar";
        
    }else if ([str isEqual:@"04"]){
        return @"Apr";
        
    }else if ([str isEqual:@"05"]){
        return @"May";
        
    }else if ([str isEqual:@"06"]){
        return @"Jun";
        
    }else if ([str isEqual:@"07"]){
        return @"Jul";
        
    }else if ([str isEqual:@"08"]){
        return @"Aug";
        
    }else if ([str isEqual:@"09"]){
        return @"Sept";
        
    }else if ([str isEqual:@"10"]){
        return @"Oct";
        
    }else if ([str isEqual:@"11"]){
        return @"Nov";
        
    }else {
        return @"Dec";
    }
}
- (IBAction)zanOnClick:(UIButton *)sender {
    if (sender.selected==NO) {
        sender.selected= YES;
        NSInteger num = [_zanNumLabel.text integerValue];
        num +=1;
        _zanNumLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
        _model.zan = @"1";
    }else{
        sender.selected= NO;
        NSInteger num = [_zanNumLabel.text integerValue];
        num -=1;
        _model.zan = nil;
        _zanNumLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    }
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

                                               
                                               
                                               
@end
