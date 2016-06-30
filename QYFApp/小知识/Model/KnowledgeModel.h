//
//  KnowledgeModel.h
//  QingYanFuYanWo
//


#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface KnowledgeModel : NSObject
@property (nonatomic,strong)AVFile *titleImage;
@property (nonatomic,copy)NSString *textTitle;
@property (nonatomic,copy)NSString *titleDescribe;
@property (nonatomic,copy)NSString *text01;
@property (nonatomic,strong)AVFile *image01;
@property (nonatomic,copy)NSString *text02;
@property (nonatomic,strong)AVFile *image02;
@property (nonatomic,copy)NSString *text03;
@property (nonatomic,strong)AVFile *image03;
@property (nonatomic,copy)NSString *text04;
@property (nonatomic,strong)AVFile *image04;
@property (nonatomic,copy)NSString *text05;
@property (nonatomic,strong)AVFile *image05;
@property (nonatomic,copy)NSString *text06;
@property (nonatomic,strong)NSNumber *upvotes;
@property (nonatomic,strong)AVObject *knowledgeObject;
@property (nonatomic,strong)NSDate *createAt;
@property (nonatomic,copy)NSString *objectID;
@end
