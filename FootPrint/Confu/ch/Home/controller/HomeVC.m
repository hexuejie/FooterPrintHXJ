//
//  HomeVC.m
//  Zhongsheng
//
//  Created by 陈小卫 on 17/6/6.
//  Copyright © 2017年 Feizhuo. All rights reserved.
//

#import "HomeVC.h"
#import "HomeCell.h"
#import "PackageVC.h"
#import "SearchVC.h"
#import "PackageDetailVC.h"
#import "CourseDetailVC.h"
#import "HomelModel.h"
#import "HomeSearchCell.h"
#import "HomeBannerCell.h"
#import "HomeRichTexCell.h"
#import "HomePackageCell.h"
#import "HomeCourseCell.h"
#import "CourseVC.h"
#import "MJRefresh.h"
#import "MessageDetailVC.h"
#import "BuyVipVC.h"
#import "LivePageVC.h"
#import "LiveDetaileVC.h"
#import "LearnRecordVC.h"
#import "WebsVC.h"
#import "HotCourVC.h"
#import "PictureAndTextCell.h"
#import "CourseListCell.h"
#import "ShopMessageVC.h"
#import "PLPlayerViewController.h"
#import "ShopMessageModel.h"
#import "SaleSuperCell.h"
#import "SaleModel.h"
#import "GroupVC.h"
#import "HomeCourseHorizontalCell.h"
#import "LearnRecordModel.h"
#import "HomeTipBgView.h"
#import "HomeHeadFirstCell.h"
#import "HomeHeadSecondCell.h"
#import "HomeLiveListVC.h"
#import "HomeLiveTipTimeLabel.h"
@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<HomelModel *> *dataSource;
@property (nonatomic,strong) HomelModel *model;
@property (nonatomic,strong) HomelModel *saleModel;

@property (nonatomic, strong) HomeSearchCell *searchView;


@end

@implementation HomeVC

#pragma mark - 星链类注释逻辑

#pragma mark - 生命周期
//placeholder_method_impl//
- (void)viewDidLoad{
    [super viewDidLoad];
    //placeholder_method_call//
    self.navigationItem.title = @"脚印云课";
    self.leftButton.hidden = YES;
    
    self.dataSource = [NSMutableArray array];
    

    if (@available(iOS 11.0, *)) {
        if (is_iPhoneXSerious) {
            self.additionalHeight = 20.0;

    }
        
    }
    
    [self setTableViewFram:CGRectMake(0, 0, SCREEN_WIDTH, KViewHeight)];

    
    [self addDefaultFootView];
    self.BlockscrollViewClick = ^(UIScrollView * _Nonnull scrollView) {
        //去掉tableviewf悬浮
        CGFloat sectionHeaderHeight = 40;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    };
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"HomeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeSearchCell" bundle:nil] forCellReuseIdentifier:@"HomeSearchCell"];
    [self.tableView registerClass:[HomeBannerCell class] forCellReuseIdentifier:@"HomeBannerCell"];
    [self.tableView registerClass:[HomeRichTexCell class] forCellReuseIdentifier:@"HomeRichTexCell"];
    [self.tableView registerClass:[HomePackageCell class] forCellReuseIdentifier:@"HomePackageCell"];
    [self.tableView registerClass:[HomeCourseCell class] forCellReuseIdentifier:@"HomeCourseCell"];
    [self.tableView registerClass:[HomeCourseHorizontalCell class] forCellReuseIdentifier:@"HomeCourseHorizontalCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SaleSuperCell" bundle:nil] forCellReuseIdentifier:@"SaleSuperCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
//    [self loadData];
    
//    [UIApplication sharedApplication].delegate.window.safeAreaInsets;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    // 审核status
    if (![isAudit isEqualToString:@"no"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_CheckStateChange object:nil];

    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    if (self.dataSource && self.dataSource.count > 0) {
//        [self hideEmptyView];
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理
//placeholder_method_impl//
#pragma mark 系统代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //placeholder_method_call//
    HomelModel *model = self.dataSource[section];
    
    NSInteger type = [model.type integerValue];
//    if (type == 1 && ![isAudit isEqualToString:@"no"]) {
//        return 0;
//    }
    
    if (type == -1 || type == -2){
        
        return 1;
    }else if (type == 3) { //课程
        
        if ([model.show_type integerValue] == 1) {  // 列表
            
            return model.content.count;
        }else{  // 网格
            
            return 1;
        }
    }else if (type == 7){
        
        return 1;
    }else {
        
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomelModel *model = self.dataSource[indexPath.section];
    NSInteger type = [model.type integerValue];
    
        if (type == -1) {
            return 88;
        }else if (type == -2) {
            return 120;//140 2行
        }else if (type == 1) { //banner
            return SCREEN_WIDTH*140/345.0;
        }else if (type == 2){ //搜索
            
            return 0;
        }else if (type == 3) { //课程
         
            if ([model.show_type integerValue] == 1) { // 列表
                
                return 120.0;
            }else{ //网格
                
                NSInteger line = ceil(model.content.count/2.0);
                CGFloat width = (SCREEN_WIDTH - 36)/2;
                CGFloat height = width*9.0/16.0 + 120;
                return line*(height);
            }
        }else if (type == 4){ //富文本
            
//            return self.RichCellheight;
            CGFloat height = self.dataSource[indexPath.section].cellHeight;
            
            if (height == 0) {
                
                height = 80;
            }
            return height;
        }else if (type == 6){ //套餐
           
            CGFloat width = (SCREEN_WIDTH-24)*2/3;
            CGFloat height = width*22/27;
            
            if (model.content.count == 1) {
                
                height = width+20;
            }
            
            return height+10;
        }else if (type == 7){ //直播
            
            NSInteger line = ceil(model.content.count/2.0);
            CGFloat width = (SCREEN_WIDTH - 36)/2;
            CGFloat height = width*19/17;
            
            return line*(height+10);
        } else if (type == 10) {
//            NSInteger line = ceil(model.content.count/5.0);
//            CGFloat width = (375.0 / SCREEN_WIDTH) * 34;
//
//            return line * (32 + width) + 17;
        } else if (type == 11) {
            if (model.content.count > 0) {
              NSArray *arr =  model.content;
                CGFloat h = 0;
                for (int i = 0; i < arr.count; i ++) {
                    CourslModel *c = arr[i];
                    if (c.is_buy == 1) {
                        h += 135.0;
                    } else {
                        h += 162.0;

                    }
                }
                
                return  h + 52.0 + 20.0 + 16.0 + 2.5 + 6;
            }
            return 0.01;
        }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    HomelModel *model = self.dataSource[section];
    NSInteger type = [model.type integerValue];
    
    if (type == -1 || type == -2 || type == 3 || type == 6 || type == 7) {
        
        return 57;
    }
    return 0;
}
//placeholder_method_impl//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HomelModel *model = self.dataSource[section];
    //placeholder_method_call//

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
    view.backgroundColor = [UIColor colorWithHex:0xffffff];
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    title.text = self.dataSource[section].type_name;
    [view addSubview:title];
    
    if ([model.type intValue] != -1) {
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(19.0);//43
            make.centerY.mas_equalTo(view);
        }];
        if ([model.type intValue] == -2) {
            title.text = @"最近在学";
        }
    }else{
        title.text = @"直播";
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(43.0);//43
            make.centerY.mas_equalTo(view);
        }];
        UILabel *title2 = [[UILabel alloc] init];
        title2.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        title2.textColor = UIColorFromRGB(0x4B8096);
        [view addSubview:title2];
        [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.equalTo(title.mas_trailing).offset(1);
            make.centerY.mas_equalTo(view);
        }];
        title2.text = @"·今日 20:00";
        
        UIImageView *iconimg = [[UIImageView alloc] init];
        iconimg.image = [UIImage imageNamed:@"home_course_first_headTag"];
        [view addSubview:iconimg];
        [iconimg mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.leading.mas_equalTo(view).offset(18);
            make.centerY.mas_equalTo(view).offset(0);
        }];
    }
    
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"mine_arrow"];
    [view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {

        make.trailing.mas_equalTo(view).offset(-14);
        make.centerY.mas_equalTo(view).offset(0);
    }];
    img.hidden = [model.show_more integerValue] == 1?NO:YES;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    btn.hidden = [model.show_more integerValue] == 1?NO:YES;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitle:@"查看更多" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(view).offset(-28.0);

        make.top.left.bottom.mas_equalTo(view);
    }];
    WS(weakself)
    [btn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
       
        if ([model.show_more integerValue] == 1) {
            if ([model.group_id intValue] > 0) {
                GroupVC *next = [[GroupVC alloc] init];
                
                next.id = model.group_id;
                [weakself.navigationController pushViewController:next animated:YES];
                
            } else {
                
                
                if ([model.type integerValue] == -1) { //直播预告
                    
                    HomeLiveListVC *next = [[HomeLiveListVC alloc] init];
                    [self.navigationController pushViewController:next animated:YES];

                }else if ([model.type integerValue] == -2) { //学习记录
                    
                    LearnRecordVC *next = [[LearnRecordVC alloc] init];
                    [self.navigationController pushViewController:next animated:YES];

                }else if ([model.type integerValue] == 3) { //课程列表
                    
                    CourseVC *next = [[CourseVC alloc] init];
                    next.isList = YES;
                    [self.navigationController pushViewController:next animated:YES];

                }else if ([model.type integerValue] == 6){ // 套餐列表
                    
                    PackageVC *next = [[PackageVC alloc] init];
                    [self.navigationController pushViewController:next animated:YES];
                }else if ([model.type integerValue] == 7){ //直播列表
                    
                    LivePageVC *next = [[LivePageVC alloc] init];
                    [self.navigationController pushViewController:next animated:YES];
                }
            }
            
           
        }
    }];
    
    return view;
}
//placeholder_method_impl//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomelModel *model = self.dataSource[indexPath.section];
    NSInteger type = [model.type integerValue];
    //placeholder_method_call//
    WS(weakself)

    if (type == -1) {
        
        HomeCourseHorizontalCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"HomeCourseHorizontalCell"];
        cell.type = 3;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.dataSource = model.list;
        cell.BlockLiveClick = ^(NSDictionary * _Nonnull model) {
            [self showHomeTipBgViewDetial:model];
        };
        cell.BlockLiveClickYuyue = ^(NSDictionary * _Nonnull model) {
            [self showHomeTipBgViewYuyueSuccess:model];
        };
        return cell;
    }else if (type == -2) {
        
        HomeCourseHorizontalCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"HomeCourseHorizontalCell"];
        cell.type = 4;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.dataSource = model.list;
        cell.BlockCourseClick = ^(LearnRecordModel * _Nonnull model) {

            CourseDetailVC *next = [[CourseDetailVC alloc] init];
            
            next.goodsType = [model.goods_type integerValue];
            next.courseId = model.cid;
//            next.is_buy = model.is_buy;
            [self.navigationController pushViewController:next animated:YES];
        };
        return cell;
    }else if (type == 1) { //banner
            
            HomeBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeBannerCell"];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.dataSource = model.content;
            cell.BlockBannerClick = ^(HomeBannelModel * _Nonnull model) { //banner点击

                
              
                
                [weakself goingToTheControllerWith:model];
            };
            
            return cell;
        }else if (type == 2){ //搜索
//
//            HomeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSearchCell"];
//            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//            cell.BlockSearchClick = ^{ //搜索
//
//
//
//                SearchVC *next = [[SearchVC alloc] init];
//                BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:next];
//                nav.modalPresentationStyle = UIModalPresentationFullScreen;
//                [self presentViewController:nav animated:YES completion:nil];
//            };
//
//            return cell;
        }else if (type == 3) { //课程
            
            if ([model.show_type integerValue] == 1) { //竖排序
                
//                HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
//                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//                cell.model = model.content[indexPath.row];
                
                [self.tableView registerNib:[UINib nibWithNibName:@"CourseListCell" bundle:nil] forCellReuseIdentifier:@"CourseListCell"];
                CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseListCell" forIndexPath:indexPath];
                cell.topLineView.hidden = YES;
               NSArray *dataSource = [CourslModel mj_objectArrayWithKeyValuesArray:model.content];
                cell.courseModel = dataSource[indexPath.row];
                
                
                return cell;
            }else{ //网格列表排序

                HomeCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCourseCell"];
                cell.type = 1;
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                cell.dataSource = model.content;
                cell.BlockCourseClick = ^(CourslModel * _Nonnull model) {
                    
                    CourseDetailVC *next = [[CourseDetailVC alloc] init];
                    
                    next.goodsType = [model.goods_type integerValue];
                    next.courseId = model.cid;
                    next.is_buy = model.is_buy;
                    [self.navigationController pushViewController:next animated:YES];
                };
                
                return cell;
            }
        }else if (type == 6){ //套餐 //左右滑
            
            HomePackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePackageCell"];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.dataSource = model.content;
            cell.BlockPackageClick = ^(HomePackaglModel * _Nonnull model) {

                PackageDetailVC *next = [[PackageDetailVC alloc] init];
                next.packId = model.id;
                next.banner = model.banner;
                [self.navigationController pushViewController:next animated:YES];
            };

            return cell;
        }else if (type == 4){ //富文本
            
            HomeRichTexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeRichTexCell"];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.model = model;
            cell.BlocHeightkClick = ^(CGFloat height) {
                
                if (model.cellHeight == height) {

                    return ;
                }
                model.cellHeight = height;
                model.isUpHeight = YES;
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            };
            
            return cell;
        }else if (type == 7){ //直播

            HomeCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCourseCell"];
            cell.type = 2;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.dataSource = model.content;
            cell.BlockLiveClick = ^(LiveModel * _Nonnull model) {

                LiveDetaileVC *next = [[LiveDetaileVC alloc] init];
                next.liveId = model.id;
                [self.navigationController pushViewController:next animated:YES];
            };

            return cell;
        } else if (type == 10) {//轮播图下icon入口
//            PictureAndTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureAndTextCell"];
//           if (!cell) {
//
//               cell = [[PictureAndTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PictureAndTextCell" withDirection:1];
//
//           }
//           cell.backgroundColor = [UIColor whiteColor];
//           cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//
//           cell.dataSource = model.content;
//               cell.BlockClick = ^(HomeBannelModel *model) {
//                   [weakself goingToTheControllerWith:model];
//               };
////           cell.BlockPackageClick = ^(PictureAndTextChildModel * _Nonnull model) {
////
////               [weakself goingToOtherController:model];
////
////           };
//
//           return cell;
        } else if (type == 11) {
            SaleSuperCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaleSuperCell"];
            cell.content = self.saleModel.content;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.BlockClick = ^(CourslModel * courseModel) {
                CourseDetailVC *next = [[CourseDetailVC alloc] init];
                
                next.end_time = courseModel.end_time;
                next.goodsType = [courseModel.goods_type intValue];
                next.courseId = courseModel.course_id;
                [weakself.navigationController pushViewController:next animated:YES];
                
            };
            return cell;
        }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    return cell;
}
    
    - (void)goingToTheControllerWith:(HomeBannelModel *)model {
        if ([model.type isEqualToString:@"link"]) {
            if ([model.link containsString:@"service-page"]) {
                WebsVC *w = [[WebsVC alloc] init];
                 w.index = 3;
                 [self.navigationController pushViewController:w animated:YES];
            } else {
                MessageDetailVC *next = [[MessageDetailVC alloc] init];
                next.requsetUrl = model.link;
                [self.navigationController pushViewController:next animated:YES];
            }
           
            
           
            
        }else if ([model.type isEqualToString:@"package"]){
            
            PackageDetailVC *next = [[PackageDetailVC alloc] init];
            next.packId = model.id;
            [self.navigationController pushViewController:next animated:YES];
        }else if ([model.type isEqualToString:@"audio"]){
            
            CourseDetailVC *next = [[CourseDetailVC alloc] init];
            next.courseId = model.id;
            next.goodsType = 2;
            [self.navigationController pushViewController:next animated:YES];
        }else if ([model.type isEqualToString:@"course"]){
            
            CourseDetailVC *next = [[CourseDetailVC alloc] init];
            next.courseId = model.id;
            next.goodsType = 1;
            [self.navigationController pushViewController:next animated:YES];
        }else if ([model.type isEqualToString:@"allcourse"]){
            
            CourseVC *next = [[CourseVC alloc] init];
            next.isList = YES;
            [self.navigationController pushViewController:next animated:YES];
        }else if ([model.type isEqualToString:@"allpackage"]){
            
            PackageVC *next = [[PackageVC alloc] init];
            [self.navigationController pushViewController:next animated:YES];
        }else if ([model.type isEqualToString:@"vip"]){
            if (!Ktoken) {
                [self loginAction];
                return;
            }
            
            BuyVipVC *next = [[BuyVipVC alloc] init];
            [self.navigationController pushViewController:next animated:YES];
        } else if ([model.type isEqualToString:@"group"]){
            
            GroupVC *next = [[GroupVC alloc] init];
//            next.navigationItem.title = model.link;
            next.id = model.id;
            [self.navigationController pushViewController:next animated:YES];
        }
    }
- (void)chooseAction:(UIControl *)control {
    
    
    if (control.tag == 0) {
        HotCourVC *next = [[HotCourVC alloc] init];
        next.model = self.model;
        [self.navigationController pushViewController:next animated:YES];
        
    }else if (control.tag == 1) {
        if (!Ktoken) {
            [self loginAction];
            return;
        }
        LearnRecordVC *next = [[LearnRecordVC alloc] init];
        [self.navigationController pushViewController:next animated:YES];
    }else{
       WebsVC *w = [[WebsVC alloc] init];
        w.index = (int)control.tag;
        [self.navigationController pushViewController:w animated:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //placeholder_method_call//

    HomelModel *model = self.dataSource[indexPath.section];
    
    if ([model.type integerValue] == 3) {
        
        CourseDetailVC *next = [[CourseDetailVC alloc] init];
        NSDictionary *dic = model.content[indexPath.row];
        next.goodsType = [model.content[indexPath.row][@"goods_type"] integerValue];
        next.courseId = model.content[indexPath.row][@"cid"];
        if (dic[@"is_buy"]) {
            next.is_buy = [dic[@"is_buy"] longValue];

        }

        [self.navigationController pushViewController:next animated:YES];
    }
}

- (void)showHomeTipBgViewYuyueSuccess:(NSDictionary *)model{
    ///liveos/api/ykapp/front/livePrepare/info
    
    HomeTipBgView *_tipView1 = [[HomeTipBgView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];

    UIView *showView = [[UIView alloc]init];
    [_tipView1.allBgView addSubview:showView];
    [_tipView1.allBgView sendSubviewToBack:showView];
    
    UIImageView *topImageView = [[UIImageView alloc]init];
    [showView addSubview:topImageView];
    topImageView.image = [UIImage imageNamed:@"home_tip_top"];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(showView);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    [showView addSubview:titleLabel];
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(showView);
        make.top.equalTo(topImageView.mas_bottom).offset(10);
    }];
    UILabel *contentLabel = [[UILabel alloc]init];
    [showView addSubview:contentLabel];
    contentLabel.textColor = UIColorFromRGB(0x999999);
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(showView);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    HomeLiveTipTimeLabel *timeLabel = [[NSBundle mainBundle] loadNibNamed:@"HomeLiveTipTimeLabel" owner:self options:nil].firstObject;
    [showView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(showView);
        make.top.equalTo(contentLabel.mas_bottom).offset(33);
    }];
    
    titleLabel.text = @"预约成功!";
    contentLabel.text = @"开播前我们将会通过APP推送通知您观看直播";
//    timeLabel.text = @"开播倒计时 134 时 21 分";
    
    HomeHeadFirstCell *bottomCell = [[NSBundle mainBundle] loadNibNamed:@"HomeHeadFirstCell" owner:self options:nil].firstObject;
    [showView addSubview:bottomCell];
    bottomCell.sureButton.hidden = YES;
    bottomCell.model =  model;
    [bottomCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(showView);
        make.height.mas_equalTo(88);
        make.top.equalTo(timeLabel.mas_bottom).offset(70);
        make.bottom.equalTo(showView.mas_bottom).offset(-1);
    }];
    
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(_tipView1.allBgView);
        make.top.equalTo(_tipView1.allBgView).offset(0);
        make.bottom.equalTo(_tipView1.allBgView).offset(-85);
//        make.height.mas_equalTo(400);
    }];
}
- (void)showHomeTipBgViewDetial:(NSDictionary *)model{
    ///liveos/api/ykapp/front/livePrepare/info
//    WS(weakself)
//    [APPRequest GET:[NSString stringWithFormat:@"%@%@",HOST_ACTION2,@"/liveos/api/ykapp/front/livePrepare/info"] parameters:@{
//                @"liveCode": [NSString stringWithFormat:@"%@",model[@"liveCode"]]
//            } finished:^(AjaxResult *result) {
//
//        NSLog(@"result.data %@",result.data);
//        if (result.code == AjaxResultStateSuccess) {
//
//        }
//    }];
//    [TalkfunHttpTools liveGet:[NSString stringWithFormat:@"%@%@",HOST_ACTION2,@"/liveos/api/ykapp/front/livePrepare/info"] params:@{
//        @"liveCode": [NSString stringWithFormat:@"%@",model[@"liveCode"]]
//    } callback:^(id result) {
//        NSLog(@"result.data %@",result[@"result"]);
//
//        if ([result[@"code"] intValue] == 200) {
//
//        }
//    }];
    
    HomeTipBgView *_tipView1 = [[HomeTipBgView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];

    UIView *showView = [[UIView alloc]init];
    [_tipView1.allBgView addSubview:showView];
    [_tipView1.allBgView sendSubviewToBack:showView];
    
    HomeLiveTipTimeLabel *timeLabel = [[NSBundle mainBundle] loadNibNamed:@"HomeLiveTipTimeLabel" owner:self options:nil].firstObject;
    [showView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(showView);
    }];
//    timeLabel.text = @"开播倒计时 134 时 21 分";
    
    HomeHeadSecondCell *bottomCell = [[NSBundle mainBundle] loadNibNamed:@"HomeHeadSecondCell" owner:self options:nil].firstObject;
    bottomCell.coverImageView.layer.cornerRadius = 10;
    bottomCell.imageBottom.constant = 90;
    [showView addSubview:bottomCell];
    bottomCell.titleLabel.text = [NSString stringWithFormat:@"%@",model[@"title"]];
    [bottomCell.coverImageView sd_setImageWithURL:model[@"liveUrl"] placeholderImage:[UIImage imageNamed:@"mydefault"]];
    [bottomCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(showView).offset(12);
        make.trailing.equalTo(showView).offset(-12);
        make.bottom.equalTo(showView).offset(-1);
        make.height.mas_equalTo(260);
    }];
    
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(_tipView1.allBgView);
        make.top.equalTo(_tipView1.allBgView).offset(43);
        make.bottom.equalTo(_tipView1.allBgView).offset(-85);
        make.height.mas_equalTo(340);
    }];
}

#pragma mark 自定义代理

#pragma mark - 事件

#pragma mark - 公开方法

- (void)loadNewData{
    //placeholder_method_call//
    self.dataSource = [NSMutableArray array];
    [self loadData];
}

- (void)loadData{
   //placeholder_method_call//
    if (!_category) {
        _category = @"";
    }
    
    
    WS(weakself)
    [APPRequest GET:@"/index" parameters:nil finished:^(AjaxResult *result) {

        [self.tableView.mj_header endRefreshing];
        if (result.code == AjaxResultStateSuccess) {
            NSArray *array = [HomelModel mj_objectArrayWithKeyValuesArray:result.data[@"list"]];
            NSMutableArray *mutableArr = array.mutableCopy;
            if (weakself.saleModel) {
                if (mutableArr.count > 0) {
                    if (mutableArr.count > 2) {
                        [mutableArr insertObject:weakself.saleModel atIndex:3];
                    } else {
                        [mutableArr insertObject:weakself.saleModel atIndex:weakself.dataSource.count];
                    }
                } else {
                    mutableArr = [NSMutableArray arrayWithObject:weakself.saleModel];
                }
            }
//            weakself.dataSource = mutableArr;
            [weakself.dataSource addObjectsFromArray:mutableArr];
            
            [weakself.tableView reloadData];
        }
        
        [weakself liveListRequest];

       
        if (self.dataSource && self.dataSource.count > 0) {
            [self performSelector:@selector(hideEmptyView) withObject:nil afterDelay:1];
        }
    }];
    

    [APPRequest GET:@"/goodsDiscountHome" parameters:nil finished:^(AjaxResult *result) {

//        [self.tableView.mj_header endRefreshing];
        if (result.code == AjaxResultStateSuccess) {

             
//            NSMutableArray *mutableArr = [NSMutableArray array];
//            self.dataSource = mutableArr;
//            [self.tableView reloadData];
            
            HomelModel *model = [[HomelModel alloc] init];
            NSArray *content = [CourslModel mj_objectArrayWithKeyValuesArray:result.data];
    
            model.content = content;
            model.type = @"11"; // 限时优惠
            weakself.saleModel = model;
            if (weakself.dataSource.count > 0) {
                if (weakself.dataSource.count > 4) {
                    [weakself.dataSource insertObject:model atIndex:3];
                } else {
                    [weakself.dataSource insertObject:model atIndex:weakself.dataSource.count];
                }
            } else {
//                weakself.dataSource = [NSMutableArray arrayWithObject:model];
                [weakself.dataSource addObject:model];
            }
            
            [weakself.tableView reloadData];
            
        }
        
    }];
}

- (void)liveListRequest{
    WS(weakself)
    [TalkfunHttpTools livePost:[NSString stringWithFormat:@"%@%@",HOST_ACTION2,@"/liveos/api/ykapp/front/livePrepare/page"] params:@{
        @"pageNumber": @10,
        @"pageSize": @1,
        @"queryKey": @""
    } callback:^(id result) {
        NSLog(@"result.data %@",result[@"result"]);

        if ([result[@"code"] intValue] == 200) {
            
            NSArray *list = result[@"result"][@"list"];
            HomelModel *model = [[HomelModel alloc] init];
            model.type = @"-1";
            model.show_more = @"1";
            model.list = list;
          
            for (int i = 0; i<weakself.dataSource.count; i++) {
                HomelModel *temp =  weakself.dataSource[i];
                if ([temp.type intValue] == 1) {//插到轮播图后面
                    if (weakself.dataSource.count > i+1) {
                        HomelModel *temptemp =  weakself.dataSource[i+1];
                        if ([temptemp.type intValue] != -1) {
                            [weakself.dataSource insertObject:model atIndex:i+1];
                            [weakself.tableView reloadData];
                            return;
                        }
                    }
                }
            }
            [weakself.dataSource addObject:model];
            [weakself.tableView reloadData];
        }
    }];
    
    [APPRequest GET:@"/studyList/recordList" parameters:nil finished:^(AjaxResult *result) {
        
        if (result.code == AjaxResultStateSuccess) {
            
            NSArray *tempArray = [LearnRecordModel mj_objectArrayWithKeyValuesArray:result.data[@"list"]];
            
            if (self.dataSource.count == 0) {
            }else{
                HomelModel *model = [[HomelModel alloc] init];
                model.type = @"-2";
                model.show_more = @"1";
                model.list = tempArray;
              
                for (int i = 0; i<weakself.dataSource.count; i++) {
                    HomelModel *temp =  weakself.dataSource[i];
                    if ([temp.type intValue] == -1) {
                        if (weakself.dataSource.count > i+1) {
                            [weakself.dataSource insertObject:model atIndex:i+1];
                            [weakself.tableView reloadData];
                            return;
                        }
                    }
                }
                for (int i = 0; i<weakself.dataSource.count; i++) {
                    HomelModel *temp =  weakself.dataSource[i];
                    if ([temp.type intValue] == 1) {//插到轮播图后面
                        if (weakself.dataSource.count > i+1) {
                            [weakself.dataSource insertObject:model atIndex:i+1];
                            [weakself.tableView reloadData];
                            return;
                        }
                    }
                }
                [weakself.dataSource addObject:model];
                [weakself.tableView reloadData];
            }
        }
    }];
}


#pragma mark - 私有方法
//placeholder_method_impl//
#pragma mark - get set
    - (HomeSearchCell *)searchView{
        
        if (_searchView == nil) {
            
            WS(weakself);
            _searchView = [[[NSBundle mainBundle] loadNibNamed:@"HomeSearchCell" owner:nil options:nil] lastObject];
            //placeholder_method_call//
           
            
            _searchView.frame = CGRectMake(0, -3, SCREEN_WIDTH - 101, 60);
            _searchView.searchBtn.layer.cornerRadius = 16.0;
            _searchView.viewbg.backgroundColor = [UIColor clearColor];
            _searchView.BlockSearchClick = ^{
                
                SearchVC *next = [[SearchVC alloc] init];
                BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:next];
                [weakself presentViewController:nav animated:YES completion:nil];
            };
        }

        return _searchView;
}

@end
