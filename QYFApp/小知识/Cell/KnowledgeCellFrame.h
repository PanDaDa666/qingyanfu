//
//  KnowledgeCellFrame.h
//  QingYanFuYanWo
//


#import <Foundation/Foundation.h>
#import "KnowledgeModel.h"


@interface KnowledgeCellFrame : NSObject
@property (nonatomic,strong)KnowledgeModel *knowledgeModel;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,assign)CGFloat titleLabelHeight;
@property (nonatomic,assign)CGFloat titleDescribeLabelHeight;

@end
