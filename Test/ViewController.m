//
//  ViewController.m
//  Test
//
//  Created by Sergey  on 31.12.15.
//  Copyright © 2015 test. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* headerButton;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat heightInset;

@end

@implementation ViewController

static CGFloat const kNavBarHeight = 64;
static CGFloat const kHeaderSectionHeight = 60;

- (void)viewDidLoad
{
    [self.headerButton addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UISearchBar* searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.tableView.tableHeaderView = searchBar;
}


#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"CellId";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [self randomColor];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* headerId = @"headerView";
    
    UITableViewHeaderFooterView* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header)
    {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerId];

        UISegmentedControl* segment = [[UISegmentedControl alloc]initWithItems:@[@"first",@"second"]];
        segment.backgroundColor = [UIColor whiteColor];
        [header addSubview:segment];
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header);
            make.left.equalTo(header).offset(20);
            make.right.equalTo(header).offset(-20);
            make.height.equalTo(@30);
        }];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderSectionHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = kHeaderSectionHeight;
    
    if ((scrollView.contentOffset.y + scrollView.bounds.size.height) >= scrollView.contentSize.height || scrollView.contentOffset.y <= 0)
    {
        return;
    }
    
    if (self.lastOffsetY > scrollView.contentOffset.y && (self.heightInset < 0))
    {
        self.heightInset += (self.lastOffsetY - scrollView.contentOffset.y);
        self.heightInset = self.heightInset > 0 ? 0 : self.heightInset;
        
        scrollView.contentInset = UIEdgeInsetsMake(self.heightInset, 0, 0, 0);
    }
    
    else if (self.lastOffsetY < scrollView.contentOffset.y && (self.heightInset >= - sectionHeaderHeight))
    {
        self.heightInset -= (scrollView.contentOffset.y - self.lastOffsetY );
        self.heightInset = self.heightInset < -sectionHeaderHeight ? -sectionHeaderHeight : self.heightInset;
        
        scrollView.contentInset = UIEdgeInsetsMake(self.heightInset, 0, 0, 0);
    }
    
    self.lastOffsetY = scrollView.contentOffset.y;
}


#pragma mark - Action

- (void)scrollToTop
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - Helper

- (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


#pragma mark - Lazy Load

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 88;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerButton.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (UIButton*)headerButton
{
    if (!_headerButton)
    {
        _headerButton = [UIButton new];
        _headerButton.backgroundColor = [UIColor redColor];
        [self.view addSubview:_headerButton];
        
        [_headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(kNavBarHeight));
        }];
    }
    return _headerButton;
}


@end
