//
//  WordDbManager.h
//  QingYanFuYanWo


#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "WordsModel.h"
typedef void (^GetAllModelsBlock)(NSArray *modelsArray);

@interface WordDbManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WordDbManager);

//插入一条数据
-(void)insertAppModel:(WordsModel *)model;

//获得所有的数据
-(void)getAllModels:(GetAllModelsBlock )complectionBlok;

@end
