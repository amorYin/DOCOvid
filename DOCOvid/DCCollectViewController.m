//
//  DCCollectViewController.m
//  DOCOVedio
//
//  Created by amor on 13-11-13.
//  Copyright (c) 2013年 amor. All rights reserved.
//

#import "DCCollectViewController.h"
#import "DCCollecttionViewControoler.h"
#import "DCTableViewController.h"
#import "DCMPMoviePlayerView.h"
#import "MJRefresh.h"
#import "DCVedioViewDeleagate.h"
#import "DCDropAnimation.h"
#import "DCAboutViewController.h"

@interface DCCollectViewController ()<MJRefreshBaseViewDelegate,DCVedioViewDeleagate>
{
    char contentTag[2];
    BOOL isSelect;
    DCTableViewController *tabletView;
    DCCollecttionViewControoler *collectView;
    MJRefreshHeaderView *_header;
    //
//    UIBarButtonItem *all_done;//铨选
    UIBarButtonItem *edit_done;
    UIBarButtonItem *delete_done;
    NSMutableArray  *arryData;//数据
    
    UIBarButtonItem *list_done;
    UIBarButtonItem *tab_done;
    
    UIImageView *placeHolder;
    
    UIButton *userLoginView;//login
}
@end

@implementation DCCollectViewController
#pragma mark - abot view
- (void)popAbout:(UIButton*)button
{
    for (id obj in button.subviews) {
        if ([obj respondsToSelector:@selector(setHighlighted:)]) {
            [obj setHighlighted:YES];
        }
    }
    DCAboutViewController *about = [[[DCAboutViewController alloc] initWithNibName:nil bundle:nil] DD_AUTORELEASE];
    about.hidesBottomBarWhenPushed = YES;
    double delayInSeconds = 0.258;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController pushViewController:about animated:YES];
        for (id obj in button.subviews) {
            if ([obj respondsToSelector:@selector(setHighlighted:)]) {
                [obj setHighlighted:NO];
            }
        }
    });
}
#pragma mark - user agent
- (void)showLoginlal:(BOOL)y
{
    if (y) {
        if (!userLoginView) {
            
            userLoginView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.height-300, 0, 300, 44)];
            userLoginView.backgroundColor = [UIColor blackColor];
            [userLoginView addTarget:self action:@selector(popAbout:) forControlEvents:UIControlEventTouchUpInside];
            @autoreleasepool {
                UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(userLoginView.frame)-34, 10, 24, 24)];
                [imgv setImage:[UIImage imageNamed:@"doco_login_btn_n"]];
                [imgv setHighlightedImage:[UIImage imageNamed:@"doco_login_btn_h"]];
                [userLoginView addSubview:imgv];
                
                UILabel *lal = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMinX(imgv.frame)-10, 44)];
                lal.text = @"登录后您可在不同设备间同步收藏记录";
                lal.backgroundColor = [UIColor clearColor];
                lal.textColor = [UIColor lightGrayColor];
                lal.highlightedTextColor = [UIColor whiteColor];
                lal.font = Cond_font(14);
                lal.textAlignment = NSTextAlignmentRight;
                [userLoginView addSubview:lal];
            }
            
        }
        [self.view addSubview:userLoginView];
    }else{
        [userLoginView removeFromSuperview];
    }
}
//loadUser
- (void)userStautsDidChanged:(UserLoadStauts)status
{
    switch (status) {
        case UserLoadStautsNone:
            [self showLoginlal:YES];
            break;
        case UserLoadStautsWillLoadQQ:
            [self showLoginlal:NO];
            break;
        case UserLoadStautsWillLoadSina:
            [self showLoginlal:NO];
            break;
        case UserLoadStautsLoadingQQ:
            [self showLoginlal:NO];
            break;
        case UserLoadStautsLoadingSina:
            [self showLoginlal:NO];
            break;
        case UserLoadStautsLoadedSina:
            [self showLoginlal:NO];
            break;
        case UserLoadStautsErrorQQ:
            [self showLoginlal:NO];
            break;
        case UserLoadStautsErrorSina:
            [self showLoginlal:NO];
            break;
            [self showLoginlal:NO];
        default:
            break;
    }
}

#pragma mark - Action
//  play
- (void)play:(id)sender
{
    DCMPMoviePlayerView*  mmpplayer = [[DCMPMoviePlayerView alloc] initWithNibName:nil bundle:nil];
    mmpplayer.hidesBottomBarWhenPushed = YES;
    [mmpplayer playURLString:@"http://doco.u.qiniudn.com/201312251000134399?p/1/avthumb"];
    //delay initial load so statusBarOrientation returns correct value
    double delayInSeconds = 0.258;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:mmpplayer animated:YES];
    });
}

- (void)deleteVedio:(NSDictionary*)arr
{
    if (arr.count>0) {
        [((UIButton*)delete_done.customView) setTitle:[NSString stringWithFormat:@"删除(%d)",arr.count] forState:UIControlStateNormal];
        [((UIButton*)delete_done.customView) setBackgroundImage:[UIImage imageNamed:@"del_btn_h"] forState:UIControlStateNormal];
        [((UIButton*)delete_done.customView) setBackgroundImage:[UIImage imageNamed:@"del_btn_h"] forState:UIControlStateHighlighted];
        [((UIButton*)delete_done.customView) setBackgroundImage:[UIImage imageNamed:@"del_btn_h"] forState:UIControlStateSelected];
    }else{
        [((UIButton*)delete_done.customView) setTitle:@"删   除" forState:UIControlStateNormal];
        [((UIButton*)delete_done.customView) setBackgroundImage:[UIImage imageNamed:@"edit_btn_n"] forState:UIControlStateNormal];
        [((UIButton*)delete_done.customView) setBackgroundImage:[UIImage imageNamed:@"edit_btn_n"] forState:UIControlStateHighlighted];
        [((UIButton*)delete_done.customView) setBackgroundImage:[UIImage imageNamed:@"edit_btn_n"] forState:UIControlStateSelected];
    }
}


-(void) setSelectButton:(NSInteger)index
{
    if (index==0) {
        ((UIButton*)list_done.customView).selected = YES;
        ((UIButton*)tab_done.customView).selected = NO;
    }else{
        ((UIButton*)list_done.customView).selected = NO;
        ((UIButton*)tab_done.customView).selected = YES;
    }
}
#pragma mark - noti

- (void)animationDropDown:(NSNotification*)noti
{
    int bag = self.dcTabbatItem.badgeValue;
    [DCDropAnimation animationFinishWith:self.dcTabbatItem badge:bag+1];
}


#pragma mark -
#pragma mark - UIBarButtonItem
- (void)setRightBarButton:(BOOL)y
{
    if (y) {
        if (!edit_done) {
            UIButton *tabbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 48)];
            [tabbtn setTitle:@"编  辑" forState:UIControlStateNormal];
            [tabbtn.titleLabel setFont:Euph_font(15)];
            [tabbtn setBackgroundImage:[UIImage imageNamed:@"edit_btn_n"] forState:UIControlStateNormal];
            [tabbtn setBackgroundImage:[UIImage imageNamed:@"edit_btn_h"] forState:UIControlStateHighlighted];
            [tabbtn setBackgroundImage:[UIImage imageNamed:@"edit_btn_h"] forState:UIControlStateSelected];
            [tabbtn addTarget:self action:@selector(openDeleteView:) forControlEvents:UIControlEventTouchUpInside];
            edit_done = [[UIBarButtonItem alloc] initWithCustomView:tabbtn];
            [tabbtn DD_AUTORELEASE];
        }
        
        if (!delete_done) {
            UIButton *tabbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 48)];
            [tabbtn setTitle:@"删  除" forState:UIControlStateNormal];
            [tabbtn.titleLabel setFont:Euph_font(15)];
            [tabbtn setBackgroundImage:[UIImage imageNamed:@"edit_btn_n"] forState:UIControlStateNormal];
            [tabbtn setBackgroundImage:[UIImage imageNamed:@"edit_btn_n"] forState:UIControlStateHighlighted];
            [tabbtn setBackgroundImage:[UIImage imageNamed:@"edit_btn_n"] forState:UIControlStateSelected];
            [tabbtn addTarget:self action:@selector(deletePituresInRange:) forControlEvents:UIControlEventTouchUpInside];
            delete_done = [[UIBarButtonItem alloc] initWithCustomView:tabbtn];
            [tabbtn DD_AUTORELEASE];
        }
        
        //        if (!all_done) {
        //            all_done = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(allSelect_done:)];
        //        }
        
        [self.navigationItem
         setRightBarButtonItems:[NSArray arrayWithObject:edit_done] animated:YES];
    }else{
        [self.navigationItem
         setRightBarButtonItems:nil animated:YES];
    }
    
}

- (void)setLeftBarButton:(BOOL)y
{
    if (y) {
        if (!tab_done) {
            UIButton *tabbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
            [tabbtn setImage:[UIImage imageNamed:@"tab_btn_h"] forState:UIControlStateNormal];
            [tabbtn setImage:[UIImage imageNamed:@"tab_btn_n"] forState:UIControlStateHighlighted];
            [tabbtn setImage:[UIImage imageNamed:@"tab_btn_n"] forState:UIControlStateSelected];
            [tabbtn addTarget:self action:@selector(tabSelect:) forControlEvents:UIControlEventTouchUpInside];
            tab_done = [[UIBarButtonItem alloc] initWithCustomView:tabbtn];
            [tabbtn DD_AUTORELEASE];
        }
        
        if (!list_done) {
            UIButton *tabbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
            [tabbtn setImage:[UIImage imageNamed:@"list_btn_h"] forState:UIControlStateNormal];
            [tabbtn setImage:[UIImage imageNamed:@"list_btn_n"] forState:UIControlStateHighlighted];
            [tabbtn setImage:[UIImage imageNamed:@"list_btn_n"] forState:UIControlStateSelected];
            [tabbtn addTarget:self action:@selector(listSelect:) forControlEvents:UIControlEventTouchUpInside];
            list_done = [[UIBarButtonItem alloc] initWithCustomView:tabbtn];
            [tabbtn DD_AUTORELEASE];
        }
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:list_done,tab_done, nil] animated:YES];
    }else{
        [self.navigationItem setLeftBarButtonItems:nil animated:YES];
    }
    
}

- (void)listSelect:(UIButton*)btn
{
    [self reachableViewAtIndex:0 scroller:YES];
}

- (void)tabSelect:(UIButton*)btn
{
    [self reachableViewAtIndex:1 scroller:YES];
}

- (void)openDeleteView:(id)sender
{
    [collectView layoutSubView:YES];
    [tabletView  layoutSubView:YES];
    
    self.scrollerView.scrollEnabled = NO;
    [((UIButton*)edit_done.customView) setTitle:@"完   成" forState:UIControlStateNormal];
    [((UIButton*)edit_done.customView) setBackgroundImage:[UIImage imageNamed:@"done_btn_n"] forState:UIControlStateNormal];
    [((UIButton*)edit_done.customView) setBackgroundImage:[UIImage imageNamed:@"done_btn_h"] forState:UIControlStateHighlighted];
    [((UIButton*)edit_done.customView) setBackgroundImage:[UIImage imageNamed:@"done_btn_h"] forState:UIControlStateSelected];
    [((UIButton*)edit_done.customView) removeTarget:self action:@selector(openDeleteView:) forControlEvents:UIControlEventTouchUpInside];
    [((UIButton*)edit_done.customView) addTarget:self action:@selector(cancleDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setRightBarButtonItems:
//    [NSArray arrayWithObjects:edit_done,all_done,delete_done, nil] animated:YES];
    [NSArray arrayWithObjects:edit_done,delete_done, nil] animated:YES];
}

- (void)deletePituresInRange:(id)range
{
    if (((UIButton*)list_done.customView).selected) {
        [tabletView  deletePituresInRange:YES callback:^(NSMutableArray *data) {
            //if data change reset,nesscery?
            if (data.count<arryData.count) arryData = data;
            if (data.count<1) [self performSelector:@selector(layoutSublayersOfByData:) withObject:Nil afterDelay:0.0];
        }];
    }else{
        [collectView deletePituresInRange:YES callback:^(NSMutableArray *data) {
            //if data change reset,nesscery?
            if (data.count<arryData.count) arryData = data;
            if (data.count<1) [self performSelector:@selector(layoutSublayersOfByData:) withObject:Nil afterDelay:0.0];
        }];
    }
    
    [self deleteVedio:Nil];
}

- (void)allSelect_done:(id)sender
{
    [collectView allSelect_done:YES];
    [tabletView  allSelect_done:YES];
}

- (void)cancleDone:(id)sender
{
    [((UIButton*)edit_done.customView) setTitle:@"编  辑" forState:UIControlStateNormal];
    [((UIButton*)edit_done.customView) setBackgroundImage:[UIImage imageNamed:@"edit_btn_n"] forState:UIControlStateNormal];
    [((UIButton*)edit_done.customView) setBackgroundImage:[UIImage imageNamed:@"edit_btn_h"] forState:UIControlStateHighlighted];
    [((UIButton*)edit_done.customView) setBackgroundImage:[UIImage imageNamed:@"edit_btn_h"] forState:UIControlStateSelected];
    
    [((UIButton*)edit_done.customView) removeTarget:self action:@selector(cancleDone:) forControlEvents:UIControlEventTouchUpInside];
    [((UIButton*)edit_done.customView) addTarget:self action:@selector(openDeleteView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem
     setRightBarButtonItems:[NSArray arrayWithObject:edit_done] animated:YES];
    [collectView layoutSubView:NO];
    [tabletView  layoutSubView:NO];
//    self.segment.hidden = NO;
    self.scrollerView.scrollEnabled = YES;
}
#pragma mark -
#pragma mark UISegmentedControl
- (void)reachableViewAtIndex:(NSInteger)index scroller:(BOOL)show
{
    [self setSelectButton:index];
    if (contentTag[index] == NO) {
        if (index==0) {
            tabletView = [[DCTableViewController alloc] initWithNibName:nil bundle:nil];
            tabletView.arrayData = arryData;
            tabletView.tableView.tag = 1000+index;
            contentTag[index]=YES;
            if ([UIView iOSVersion]<7.0) {
                tabletView.tableView.size = CGSizeMake( self.view.width, self.view.height-20);
            }else{
                tabletView.tableView.size = CGSizeMake( self.view.width, self.view.height-50);
            }

            tabletView.tableView.origin = CGPointMake(0,0);
            tabletView.tableView.backgroundColor = [UIColor clearColor];
            tabletView.actionDelegate = self;
            [(UIScrollView*)self.scrollerView addSubview:tabletView.view];
        }else if (index==1){
            collectView = [[DCCollecttionViewControoler alloc] initWithNibName:nil bundle:nil];
            collectView.arrayData = arryData;
            collectView.view.tag = 1000+index;
            contentTag[index]=YES;
            if ([UIView iOSVersion]<7.0) {
                collectView.view.size = CGSizeMake( self.view.width, self.view.height-20);
            }else{
                collectView.view.size = CGSizeMake( self.view.width, self.view.height-50);
            }
            
            collectView.view.origin = CGPointMake(self.view.width,0);
            collectView.view.backgroundColor = [UIColor clearColor];
            collectView.actionDelegate = self;
            [(UIScrollView*)self.scrollerView addSubview:collectView.view];
        }else{
        
        }
    }
    UIScrollView *tempView = (UIScrollView*)[self.view viewWithTag:1000+index];
    _header.scrollView = tempView;
    if (show) {
        
        [(UIScrollView*)self.scrollerView scrollRectToVisible:tempView.frame animated:YES];
    }
}
//seg
- (void)changeNewView:(UISegmentedControl*)seg
{
    isSelect = YES;
    [self reachableViewAtIndex:seg.selectedSegmentIndex scroller:YES];
}

#pragma mark -  refresh view delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) { // 下拉刷新
        //关闭界面切换
        self.segment.enabled = NO;
        self.scrollerView.scrollEnabled = NO;
        // 增加9个假数据
        for (int i = 0; i<7; i++) {
            [arryData insertObject:[NSString stringWithFormat:@"%d",arryData.count+i] atIndex:0];
        }
        
        // 2秒后刷新表格
        [self performSelector:@selector(reloadDeals) withObject:nil afterDelay:2];
    }
}

#pragma mark - refresh
- (void)reloadDeals
{
    //刷新数据
    [collectView layoutSubView:NO];
    [tabletView  layoutSubView:NO];
    // 结束刷新状态
    [_header endRefreshing];
    //打开界面切换
    self.segment.enabled = YES;
    self.scrollerView.scrollEnabled = YES;
    
}

#pragma mark -
#pragma mark - (void)scrollViewDidScroll:(UIScrollView *)scrollView;   
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isSelect) {return;}
    CGFloat indexf = scrollView.contentOffset.x/scrollView.width;
    NSInteger index = ceil(indexf);
    [self reachableViewAtIndex:index scroller:NO];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    isSelect = NO;
}
#pragma mark -
#pragma mark UIViewController
//view
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //add observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationDropDown:) name:DCDropAnimationCellectFinishNotification object:nil];
    }
    return self;
}
//loadData
- (void)layoutSublayersOfByData:(NSDictionary*)dic
{
    if (dic.count<1) {
        if (!placeHolder)
            placeHolder= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"collect_content_null_bg"]];
        [self.view addSubview:placeHolder];
        [self setRightBarButton:NO];
        [self setLeftBarButton:NO];
    }else{
        if (placeHolder){
            [placeHolder  removeFromSuperview];
            placeHolder = nil;
        }
        [self setRightBarButton:YES];
        [self setLeftBarButton:YES];
        //refresh
        if (!_header) {
            _header = [MJRefreshHeaderView header];
            _header.delegate = self;
        }
        //    //segment
        //    if (!self.segment) {
        //            self.segment = [[UISegmentedControl alloc] initWithItems:@[@"普通",@"网状"]];
        //            self.segment.frame = CGRectMake(0, 0, 200, 33);
        //
        //            [self.segment addTarget:self action:@selector(changeNewView:) forControlEvents:UIControlEventValueChanged];
        //            [self.navigationController.navigationBar addSubview:self.segment];
        //    }
        //    self.segment.center = CGPointMake(AppFrame.height*0.5,self.navigationController.navigationBar.centerY*0.5);
        self.scrollerView.contentSize = CGSizeMake(self.view.width*2, self.view.height-49-64);
        
        // delay load the number view
        [self performSelector:@selector(load) withObject:nil afterDelay:0.1];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收藏";
    //initlied data
    arryData = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19", nil];
	// Do any additional setup after loading the view.
    //set top buttons
    [self performSelector:@selector(layoutSublayersOfByData:) withObject:arryData afterDelay:0.];
    //判断用户
    [self userStautsDidChanged:self.userStatus];
}

- (void)load
{
    [self reachableViewAtIndex:0 scroller:YES];
}

- (void)viewDidUnload
{
    memset(contentTag, 0, sizeof(NO));
    self.scrollerView = nil;
    self.segment =nil;
    tabletView = nil;
    collectView = nil;
    _header = nil;
    arryData = nil;
//    all_done = nil;
    delete_done = nil;
    edit_done = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
