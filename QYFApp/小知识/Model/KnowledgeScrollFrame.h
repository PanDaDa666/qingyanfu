//
//  KnowledgeScrollFrame.h
//  QingYanFuYanWo
//


#import <Foundation/Foundation.h>
#import "KnowledgeModel.h"
@interface KnowledgeScrollFrame : NSObject
@property (nonatomic,strong)KnowledgeModel *knowledgeModel;
@property (nonatomic,strong)NSMutableArray *textHeightArray;
@property (nonatomic,assign)CGFloat textTitleHeight;
@property (nonatomic,assign)CGFloat scrollHeight;
@end
