//
//  UserRepositoriesTableViewController.m
//  GithubUsersInfo
//
//  Created by Alexander on 14.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import "UserRepositoriesTableViewController.h"

@interface UserRepositoriesTableViewController ()

@property (copy, nonatomic) NSMutableArray *allRepositories;
@property (strong, nonatomic) NSNumber *lastFetchedRepositoriesPage;

- (void)appendToAllRepositoriesNewResponseObject:(NSArray*)repositoriesObject;
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)setUpPullToRefresh;
- (void)setUpInfiniteScroll;

@end

@implementation UserRepositoriesTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.allowsSelection = NO;
  [self setUpPullToRefresh];
  [self setUpInfiniteScroll];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  GithubSessionManager *sessionManager = [GithubSessionManager sharedGithubSessionManager];
  sessionManager.delegate = self;
  [sessionManager updateRepositoriesListForUser:self.user forPage:1 repositoriesPerPage:30];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma - Custom accessors/setters

- (NSNumber*)lastFetchedRepositoriesPage{
  if (!_lastFetchedRepositoriesPage){
      _lastFetchedRepositoriesPage = [[NSNumber alloc] initWithInt:0];
  }
  return _lastFetchedRepositoriesPage;
}

- (NSMutableArray*)allRepositories{
    if (!_allRepositories){
        _allRepositories = [[NSMutableArray alloc] init];
    }
    return _allRepositories;
}

#pragma mark - Private

- (void) setUpPullToRefresh{
  __weak UserRepositoriesTableViewController *weakSelf = self;
  __weak GithubSessionManager *weakSessionManager = [GithubSessionManager sharedGithubSessionManager];
  [self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
      //reFetch data, startUpdates
      weakSelf.allRepositories = nil;
      weakSelf.lastFetchedRepositoriesPage = 0;
      [weakSelf.tableView reloadData];
      [weakSelf.tableView beginUpdates];
      [weakSessionManager updateRepositoriesListForUser:self.user forPage:1 repositoriesPerPage:30];
      int64_t delayInSeconds = 1;
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          [scrollView ins_endPullToRefresh];
      });
  }];
  
  CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
  UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [[INSDefaultPullToRefresh alloc] initWithFrame:defaultFrame backImage:[UIImage imageNamed:@"gray_arrow_down"] frontImage:[UIImage imageNamed:@"green_nimb"]];
  self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
  [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)setUpInfiniteScroll{
  __weak UserRepositoriesTableViewController *weakSelf = self;
  __weak GithubSessionManager *weakSessionManager = [GithubSessionManager sharedGithubSessionManager];
  [self.tableView ins_addInfinityScrollWithHeight:60 handler:^(UIScrollView *scrollView) {
      [self.tableView beginUpdates];
      NSInteger forPage = [weakSelf.lastFetchedRepositoriesPage integerValue]+1;
      [weakSessionManager updateRepositoriesListForUser:self.user forPage:forPage repositoriesPerPage:30];
      
      int64_t delayInSeconds = 1;
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          [scrollView ins_endInfinityScrollWithStoppingContentOffset:YES];
      });
  }];
  
  CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
  UIView <INSAnimatable> *infinityIndicator = [[INSDefaultInfiniteIndicator alloc] initWithFrame:defaultFrame];
  [self.tableView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
  [infinityIndicator startAnimating];
}

- (void)appendToAllRepositoriesNewResponseObject:(NSArray*)repositoriesObject{
  NSError *error = nil;
  NSMutableArray *fetchedRepositories = (NSMutableArray*)[MTLJSONAdapter modelsOfClass:GithubRepository.class
                                                                     fromJSONArray:repositoriesObject
                                                                             error:&error];
  [self.allRepositories addObjectsFromArray:fetchedRepositories];
  error ? NSLog(@"error while parsing firstRetrievedRepository Owner: %@", error.userInfo) : nil ;
  [self.tableView reloadData];
  [self.tableView endUpdates];
}

#pragma mark - GithubSessionManagerDelegate

- (void)githubSessionManager:(nullable GithubSessionManager*)manager didUpdateWithRepositoriesObject:(nullable id)repositoriesObject forUser:(nullable GithubUser*)user toPage:(NSInteger)toPage;{
  //parse 1 object to check if it is the same user we are waiting repositories for
  NSError *error = nil;
  NSDictionary *firstFetchedDictionary = (NSDictionary*)[(NSArray*)repositoriesObject firstObject];
  GithubRepository *firstFetchedRepository = [MTLJSONAdapter modelOfClass:GithubRepository.class
                                                      fromJSONDictionary:firstFetchedDictionary
                                                                  error:&error];
  error ? NSLog(@"error while parsing firstRetrievedRepository: %@", error.userInfo) : nil ;
  GithubUser *firstFetchedUser = [MTLJSONAdapter modelOfClass:GithubUser.class
                                           fromJSONDictionary:firstFetchedRepository.ownerDictionary
                                                        error:&error];
  error ? NSLog(@"error while parsing firstRetrievedRepository Owner: %@", error.userInfo) : nil ;
  
  //check if it is a correct user and add info to
  if ([self.user.userID isEqual:firstFetchedUser.userID]){
      [self appendToAllRepositoriesNewResponseObject:(NSArray*)repositoriesObject];
      self.lastFetchedRepositoriesPage = [NSNumber numberWithInteger:toPage];
  } else {
      [self.tableView endUpdates];
  }
}

- (void)githubSessionManagerDidFailWithError: (nullable NSError*) error{
  NSLog(@"Failed to get users. Error: %@", error.userInfo);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger sections = 0;
  if (self.allRepositories.count > 0){
      sections = 1;
  }
  return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger rows = self.allRepositories.count;
  return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repository_cell" forIndexPath:indexPath];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
  GithubRepository *repositoryForThisCell = [self.allRepositories objectAtIndex:indexPath.row];
  if ([cell.reuseIdentifier isEqualToString:@"repository_cell"]){
      cell.textLabel.text = repositoryForThisCell.nameOfRepository;
      cell.detailTextLabel.text = repositoryForThisCell.descriptionOfRepository;
  }
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
