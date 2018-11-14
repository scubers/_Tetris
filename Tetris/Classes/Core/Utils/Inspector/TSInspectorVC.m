//
//  TSInspectorVC.m
//  Tetris
//
//  Created by Junren Wong on 2018/11/14.
//

#import "TSInspectorVC.h"
#import "UIViewController+TSRouter.h"

@interface TSInspectComponent : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) id value;
@end
@implementation TSInspectComponent
@end


@interface TSInspectorVC () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<TSInspectComponent *> *datas;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation TSInspectorVC

- (void)loadView {
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    self.searchController = _searchController;
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    _datas = @[].mutableCopy;

    TSSyncTree *tree = [[TSTetris shared].router valueForKey:@"viewTree"];
    
    [tree enumerateEndNode:^(TSNodePath * _Nonnull path) {
        TSInspectComponent *comp = [TSInspectComponent new];
        comp.key = [path.path componentsJoinedByString:@"/"];
        comp.value = path.value;
        [_datas addObject:comp];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(ts_finishDisplay)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"xx"];
    }
    TSInspectComponent *comp = _datas[indexPath.row];
    
    cell.textLabel.text = comp.key;
    cell.detailTextLabel.text = [comp.value description];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%@", searchController.searchBar.text);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
