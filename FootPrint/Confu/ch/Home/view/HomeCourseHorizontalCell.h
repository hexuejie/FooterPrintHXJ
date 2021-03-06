//
//  HomeCourseHorizontalCell.h
//  FootPrint
//
//  Created by 何学杰 on 2021/8/7.
//  Copyright © 2021 cscs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourslModel.h"
#import "LearnRecordModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface HomeCourseHorizontalCell : UITableViewCell

@property (nonatomic, assign) NSInteger type;
//placeholder_property//
@property (nonatomic, strong) NSArray *dataSource;


@property (nonatomic, copy) void (^BlockCourseClick)(LearnRecordModel *model);
//placeholder_property//
@property (nonatomic, copy) void (^BlockLiveClick)(NSDictionary *model);
@property (nonatomic, copy) void (^BlockLiveClickYuyue)(NSDictionary *model);


@end

NS_ASSUME_NONNULL_END
