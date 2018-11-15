//
//  TSInspectorVC.m
//  Tetris
//
//  Created by Junren Wong on 2018/11/14.
//

#import "TSInspectorVC.h"
#import "UIViewController+TSRouter.h"
#import "TSPushPopDisplayer.h"
#import "TSPresentDismissDisplayer.h"
#import "TSInspectorButton.h"
#import "TSInspector.h"
#import "TSInspectorCell.h"

@interface TSInspectComponent : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *desc;
@end
@implementation TSInspectComponent
@end


@interface TSInspectorVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<TSInspectComponent *> *datas;

@property (nonatomic, strong) NSArray<TSInspectComponent *> *results;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITextField *textfield;



@end

@implementation TSInspectorVC


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    
    _datas = @[].mutableCopy;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 400, 30)];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    TSSyncTree *tree = [[TSTetris shared].router valueForKey:@"viewTree"];
    
    [tree enumerateEndNode:^(TSNodePath * _Nonnull path) {
        TSInspectComponent *comp = [TSInspectComponent new];
        comp.key = [[path.path componentsJoinedByString:@"/"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        TSLine *line = ((TSLine *)path.value);
        comp.value = NSStringFromClass(line.intentableClass);
        comp.desc = line.desc;
        [_datas addObject:comp];
    }];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(ts_finishDisplay)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"input" style:UIBarButtonItemStylePlain target:self action:@selector(inputClick:)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSInspectorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];
    
    TSInspectComponent *comp = [self components][indexPath.row];
    
    cell.urlLabel.text = comp.key;
    cell.classLabel.text = comp.value;
    cell.descLabel.text = comp.desc;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self components].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self presentInputWithDefault:[self components][indexPath.row].key];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

- (void)inputClick:(id)sender {
    [self presentInputWithDefault:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    _results = [_datas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.key contains %@ or self.value contains %@", text, text]];
    [_tableView reloadData];
}

- (NSArray<TSInspectComponent *> *)components {
    if (_searchBar.text.length) {
        return _results;
    }
    return _datas;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TSInspectorCell class] forCellReuseIdentifier:@"xx"];
    }
    return _tableView;
}

- (void)startUrl:(NSString *)url {
    id<TSInspectorHandler> handler = _TSInspector.handler;
    TSIntent *intent = [TSIntent presentDismissByUrl:url];
    if (handler) {
        [self ts_finishDisplay:YES complete:^{
            [handler ts_handleIntent:intent];
        }];
    } else {
        [self ts_start:intent];
    }
}

- (void)presentInputWithDefault:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Input url" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = string;
        self.textfield = textField;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startUrl:self.textfield.text];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
