//
//  SearchViewController.m
//  NativeH5Demo
//
//  Created by nucarf on 2021/2/26.
//

#import "SearchViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "RegionModel.h"

#define searchTypes @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施"

@interface SearchViewController ()<AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

/***  高德检索api  ****/
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
/***  关键词搜索请求  ****/
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *request;
@property (strong, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataSource = [NSMutableArray array];
    [self.searchTF addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];

    self.request.keywords = @"搜索内容";
    self.tableView.tableFooterView = [UIView new];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    [self requestKeyWord];
}

- (void)textFieldDidEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }

/***  判断输入框是否输入完成,未点击键盘工具栏字体不执行请求  ****/
    UITextRange *selectedRange = textField.markedTextRange;
    if (!(selectedRange == nil || selectedRange.empty)) {
        return;
    }

    self.request.keywords = textField.text;
    [self.searchAPI AMapPOIKeywordsSearch:self.request];
}

#pragma mark -- 高德数据请求 --
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    NSLog(@"%lu___", (unsigned long)response.pois.count);

    if (response.pois.count == 0) {
        return;
    }

    [self.dataSource removeAllObjects];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        RegionModel *model = [[RegionModel alloc]init];
        model.name = obj.name;
        model.lat = [NSString stringWithFormat:@"%f", obj.location.latitude];
        model.lng = [NSString stringWithFormat:@"%f", obj.location.longitude];
        [self.dataSource addObject:model];
    }];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RegionModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", model.name];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RegionModel *model = self.dataSource[indexPath.row];

    if (self.backBlock) {
        self.backBlock(model.lat, model.lng);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (AMapSearchAPI *)searchAPI {
    if (!_searchAPI) {
        self.searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

- (AMapPOIKeywordsSearchRequest *)request {
    if (!_request) {
        self.request = [[AMapPOIKeywordsSearchRequest alloc] init];
        //    request.city                = @"";
        _request.types = searchTypes;
        _request.requireExtension = YES;
    _request.offset = 50;
        /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
        _request.cityLimit = NO;
        _request.requireSubPOIs = YES;
    }
    return _request;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
