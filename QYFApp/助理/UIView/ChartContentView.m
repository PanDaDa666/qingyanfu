//
//  ChartContentView.m
//  气泡

#define kContentStartMargin 25
#import "ChartContentView.h"
#import "ChartMessage.h"
@implementation ChartContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView=[[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled=YES;
        self.backImageView.layer.masksToBounds=YES;
        [self addSubview:self.backImageView];
        

        
        self.contentImageView = [[UIImageView alloc] init];
        [self addSubview:self.contentImageView];
        
        [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)]];
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    
    [super setFrame:frame];
    self.backImageView.frame=self.bounds;
    if (self.chartMessage.messageMediaType==kAVIMMessageMediaTypeText) {
        [self.contentImageView removeFromSuperview];
        [self.contentLabel removeFromSuperview];
        [self.playAudioImageView removeFromSuperview];
        [self.playTimeLabel removeFromSuperview];
        
        self.contentLabel=[[UILabel alloc]init];
        self.contentLabel.numberOfLines=0;
        self.contentLabel.textAlignment=NSTextAlignmentLeft;
        self.contentLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
        [self addSubview:self.contentLabel];
        CGFloat contentLabelX=0;
        if(!self.chartMessage.messageType){
            
            contentLabelX=kContentStartMargin*0.8;
        }else if(self.chartMessage.messageType){
            contentLabelX=kContentStartMargin*0.5;
        }
        self.contentLabel.frame=CGRectMake(contentLabelX, -3, self.frame.size.width-kContentStartMargin-5, self.frame.size.height);
    }
    else if(self.chartMessage.messageMediaType==kAVIMMessageMediaTypeImage){
        [self.contentLabel removeFromSuperview];
        [self.contentImageView removeFromSuperview];
        [self.playAudioImageView removeFromSuperview];
        [self.playTimeLabel removeFromSuperview];
        
        self.contentImageView = [[UIImageView alloc] init];
        self.contentImageView.contentMode=UIViewContentModeScaleAspectFit;

        [self addSubview:self.contentImageView];
        CGFloat contentImageViewX=0;
        if(!self.chartMessage.messageType){
            
            contentImageViewX=kContentStartMargin*0.9;
        }else if(self.chartMessage.messageType){
            contentImageViewX=kContentStartMargin*0.5;
        }
        CGFloat X = contentImageViewX;
        CGFloat Y = 15;
        CGFloat W = self.frame.size.width-kContentStartMargin-10;
        CGFloat H = self.frame.size.height-40;
        self.contentImageView.frame = CGRectMake(X, Y, W, H);
        
    }else if (self.chartMessage.messageMediaType==kAVIMMessageMediaTypeAudio){
        [self.contentImageView removeFromSuperview];
        [self.contentLabel removeFromSuperview];
        [self.playAudioImageView removeFromSuperview];
        [self.playTimeLabel removeFromSuperview];
        
        self.playTimeLabel = [[UILabel alloc] init];
        self.playAudioImageView = [[UIImageView alloc] init];
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        [self addSubview:self.playAudioImageView];
        [self addSubview:self.playTimeLabel];
        CGFloat contentLabelX=0;
        if(!self.chartMessage.messageType){
            contentLabelX=kContentStartMargin*1.1;
            self.playAudioImageView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying003"];
            for (int i = 0; i < 3;  i++) {
                NSString *path = [NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%d",i+1];
                UIImage *image = [UIImage imageNamed:path];
                [imageArray addObject:image];
            }
        }else if(self.chartMessage.messageType){
            self.playAudioImageView.image = [UIImage imageNamed:@"SenderVoiceNodePlaying003"];
            for (int i = 0; i < 3;  i++) {
                NSString *path = [NSString stringWithFormat:@"SenderVoiceNodePlaying00%d",i+1];
                UIImage *image = [UIImage imageNamed:path];
                [imageArray addObject:image];
            }
            
        contentLabelX=self.frame.size.width- kContentStartMargin*2;
        }
        self.playAudioImageView.animationDuration = 3;
        //设置图片视图动画的重复次数
        self.playAudioImageView.animationRepeatCount = 0;//如果为0,则是无限次播放
        //设置图片视图动画的图片数组(传过来的数组里面放的是图片对象）
        self.playAudioImageView.animationImages = imageArray;
        self.playAudioImageView.frame=CGRectMake(contentLabelX, 10, 20, 20);
        if (self.chartMessage.messageType) {
            self.playTimeLabel.frame = CGRectMake(self.backImageView.frame.size.width-contentLabelX-8, 10, 30, 20);
        }else{
            self.playTimeLabel.frame = CGRectMake(self.backImageView.frame.size.width-contentLabelX-30, 10, 30, 20);
        }
        
        self.playTimeLabel.font = [UIFont systemFontOfSize:13];
        self.playTimeLabel.textColor = [UIColor lightGrayColor];
    }
    

}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

-(void)longTap:(UILongPressGestureRecognizer *)longTap
{
    if([self.delegate respondsToSelector:@selector(chartContentViewLongPress:content:)]){
        
        [self.delegate chartContentViewLongPress:self content:self.contentLabel.text];
    }
}
-(void)tapPress:(UILongPressGestureRecognizer *)tapPress
{
    if([self.delegate respondsToSelector:@selector(chartContentViewTapPress:content:)]){
    
        [self.delegate chartContentViewTapPress:self content:self.contentLabel.text];
    }
}
@end
