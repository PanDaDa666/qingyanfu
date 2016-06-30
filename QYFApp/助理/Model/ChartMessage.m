//
//  ChartMessage.m
//  气泡
//

#import "ChartMessage.h"

@implementation ChartMessage

-(void)setMessage:(AVIMMessage *)message
{
    _message=message;
    AVIMTypedMessage *typedMessage=(AVIMTypedMessage*)message;
    self.icon = typedMessage.clientId;
    self.content=typedMessage.text;
    self.messageMediaType=typedMessage.mediaType;
    self.messageImageAVFile = typedMessage.file;
    self.playTime = [[typedMessage.attributes objectForKey:@"playTime"] integerValue];
    BOOL isMe= [[AVIMClient defaultClient].clientId isEqualToString:typedMessage.clientId];
    self.messageType = isMe;
}
@end
