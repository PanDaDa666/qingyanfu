//
//  TopicItemHeader.m
//  QingYanFuYanWo
//


#import "TopicItemHeader.h"

@implementation TopicItemHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setSearchController:(UISearchController *)searchController{
    _searchController = searchController;
    [self addSubview:searchController.searchBar];
}
@end
