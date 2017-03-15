//
//  UsersTableViewController.m
//  GithubUsersInfo
//
//  Created by Alexander on 13.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import "UsersTableViewController.h"

@interface UsersTableViewController ()

@property (nonatomic, strong) NSNumber *lastRetrievedUserID;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) UsersSearchTableViewController *searchResultsController;
@property (nonatomic, strong) UISearchController *searchController;

- (void)setUpPullToRefresh;
- (void)setUpInfiniteScroll;
- (void)appendToAllUsersInfoNewObject:(NSArray*)usersInfo;
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)filterContentForSearchText: (NSString*) searchText;

@end

@implementation UsersTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setUpPullToRefresh];
  [self setUpInfiniteScroll];
  GithubSessionManager *sessionManager = [GithubSessionManager sharedGithubSessionManager];
  sessionManager.delegate = self;
  [sessionManager updateUsersListFromID:0];

  //setUp searchController
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                           bundle: nil];
  self.searchResultsController = [mainStoryboard instantiateViewControllerWithIdentifier:@"searchResultsViewController"];
  self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
  self.searchController.searchResultsUpdater = self;
  self.tableView.tableHeaderView = self.searchController.searchBar;
  self.definesPresentationContext = YES;
  self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self adjustContentInsets];
  GithubSessionManager *sessionManager = [GithubSessionManager sharedGithubSessionManager];
  sessionManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Custom accessors/setters

- (NSMutableArray*)allUsersInfo{
  if (!_allUsersInfo){
    _allUsersInfo = [[NSMutableArray alloc] init];
  }
  return _allUsersInfo;
}

- (NSNumber*)lastRetrievedUserID{
  if (!_lastRetrievedUserID){
    _lastRetrievedUserID = [[NSNumber alloc] init];
  }
  return _lastRetrievedUserID;
}

#pragma mark - Private

- (void)adjustContentInsets{
  self.automaticallyAdjustsScrollViewInsets = NO;
  CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
  CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
  CGFloat contentInsetTop = navigationBarHeight+statusBarHeight;
  [self.tableView setContentInset:UIEdgeInsetsMake(contentInsetTop, 0, 0, 0)];
}

- (void) setUpPullToRefresh
{
  __weak UsersTableViewController *weakSelf = self;
  __weak GithubSessionManager *weakSessionManager = [GithubSessionManager sharedGithubSessionManager];
  [self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
      //reFetch data, startUpdates
      weakSelf.allUsersInfo = nil;
      weakSelf.lastRetrievedUserID = 0;
      [weakSelf.tableView reloadData];
      [weakSelf.tableView beginUpdates];
      [weakSessionManager updateUsersListFromID:0];
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
    
  __weak GithubSessionManager *weakSessionManager = [GithubSessionManager sharedGithubSessionManager];
  
  [self.tableView ins_addInfinityScrollWithHeight:60 handler:^(UIScrollView *scrollView) {
      [self.tableView beginUpdates];
      [weakSessionManager updateUsersListFromID:[self.lastRetrievedUserID integerValue]];
      
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
     
#pragma mark - GithubSessionManagerDelegate
     
- (void)githubSessionManager:(nullable GithubSessionManager*)manager didUpdateWithUsersInfo:(nullable id) usersInfo{
  
  [self appendToAllUsersInfoNewObject:(NSArray*)usersInfo];
}

- (void)appendToAllUsersInfoNewObject:(NSArray*)usersInfo{
    
  NSMutableArray *newIndexPaths = [NSMutableArray new];
  for (int i=0; i<usersInfo.count; i++){
      NSError *error = nil;
      NSDictionary *iteratorUserDictionary = [usersInfo objectAtIndex:i];
      GithubUser *iteratorUser = [MTLJSONAdapter modelOfClass:GithubUser.class
                                              fromJSONDictionary:iteratorUserDictionary
                                                           error:&error];
      error ? NSLog(@"error while parsing iteratorUser: %@", error.userInfo) : nil ;
      [self.allUsersInfo addObject:iteratorUser];
      NSIndexPath *iterIndexPath = [NSIndexPath indexPathForRow:self.allUsersInfo.count inSection:0];
      [newIndexPaths addObject:iterIndexPath];
  }
  //change lastRetrievedUserID
  GithubUser *lastRetrievedUser = [self.allUsersInfo lastObject];
  self.lastRetrievedUserID = lastRetrievedUser.userID;
  [self.tableView reloadData];
  [self.tableView endUpdates];
    
}

- (void)githubSessionManagerDidFailWithError: (nullable NSError*) error{
    
  NSLog(@"Failed to get users. Error: %@", error.userInfo);
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
  [self filterContentForSearchText:self.searchController.searchBar.text];
}

- (void)filterContentForSearchText: (NSString*) searchText{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"login contains[c] %@", searchText];
  self.searchResults = [self.allUsersInfo filteredArrayUsingPredicate:predicate];
  self.searchResultsController.usersTVC = self;
  self.searchResultsController.searchResults = self.searchResults;
  [self.searchResultsController.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger sections = 0;
  if (self.allUsersInfo.count > 0){
      sections = 1;
  }
  return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger rows = self.allUsersInfo.count;
  return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user_cell"/* forIndexPath:indexPath*/];
  if (cell==nil){
      cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"user_cell"];
  }
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;{
  GithubUser *userForThisCell = [self.allUsersInfo objectAtIndex:indexPath.row];
  if ([cell.reuseIdentifier isEqualToString:@"user_cell"]){
      [((UserTableViewCell*) cell).avatarImageView setImageWithURL:userForThisCell.avatarUrl placeholderImage:[UIImage imageNamed:@"gray_square"]];
      ((UserTableViewCell*) cell).userNameTextField.text = userForThisCell.login;
      ((UserTableViewCell*) cell).userNameTextField.enabled = NO;
  }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
  return 63;
}

 #pragma mark - Navigation

- (void)performSegueToUserDescriptionWithCellAtIndexPath:(NSIndexPath*)indexPath{
  [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  GithubUser *userToGive = [self.allUsersInfo objectAtIndex:indexPath.row];
  [self performSegueWithIdentifier:@"show_user" sender:(id)userToGive];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

 if ([segue.destinationViewController isKindOfClass: [UserDescriptionViewController class]]){
     if ([sender isKindOfClass:UITableViewCell.class]){
         //segue from UsersTableViewController
         //get chosen cell index
         UserTableViewCell *chosenCell = (UserTableViewCell*)sender;
         NSIndexPath *chosenIndexPath = [self.tableView indexPathForCell:chosenCell];
         NSInteger cellIndex = chosenIndexPath.row;
         
         //give chosen user object
         UserDescriptionViewController *userDescriptionVC = (UserDescriptionViewController*)[segue destinationViewController];
         userDescriptionVC.user = [self.allUsersInfo objectAtIndex:cellIndex];
     } else {
         //segue from search
         UserDescriptionViewController *userDescriptionVC = (UserDescriptionViewController*)[segue destinationViewController];
         userDescriptionVC.user = (GithubUser*)sender;
     }
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

@end
