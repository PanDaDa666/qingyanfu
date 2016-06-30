//
//  ChartMessage.h
//  气泡
//

typedef enum {
  
    kMessageFrom=0,
    kMessageTo
 
}ChartMessageType;
#import <AVOSCloudIM/AVOSCloudIM.h>
#import <Foundation/Foundation.h>

@interface ChartMessage : NSObject
@property (nonatomic,assign) BOOL messageType;
@property (nonatomic,assign) AVIMMessageMediaType messageMediaType;
@property (nonatomic, copy) NSString *icon;
//@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) AVIMMessage *message;
@property (nonatomic, strong) UIImage *messageImage;
@property (nonatomic, strong) AVFile *messageImageAVFile;
@property (nonatomic, assign) NSInteger playTime;
@end
