//
//  UsersSearchTableViewController.m
//  GithubUsersInfo
//
//  Created by Alexander on 15.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import "UsersSearchTableViewController.h"
#import "UsersTableViewController.h"

@interface UsersSearchTableViewController ()

@end

@implementation UsersSearchTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated{
  if ([self.usersTVC respondsToSelector:@selector(adjustContentInsets)]){
      [self.usersTVC adjustContentInsets];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Custom accessors/setters

- (void)setSearchResults:(NSArray *)searchResults{
  _searchResults = searchResults;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger sections = 0;
  if (self.searchResults.count > 0){
      sections = 1;
  }
  return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger rows = self.searchResults.count;
  return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user_cell" /*forIndexPath:indexPath*/];
  if (cell==nil){
      cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"user_cell"];
  }
  // Configure the cell...
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;{
  GithubUser *userForThisCell = [self.searchResults objectAtIndex:indexPath.row];
  if ([cell.reuseIdentifier isEqualToString:@"user_cell"]){
      [((UserTableViewCell*) cell).avatarImageView setImageWithURL:userForThisCell.avatarUrl placeholderImage:[UIImage imageNamed:@"gray_square"]];
      ((UserTableViewCell*) cell).userNameTextField.text = userForThisCell.login;
      ((UserTableViewCell*) cell).userNameTextField.enabled = NO;
  }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
  return 63;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  //pass InexPath of chosen user to UsersTableViewController and go to UserDescriptionViewController via UsersTableViewController segue
  GithubUser *chosenUser = [self.searchResults objectAtIndex:indexPath.row];
  NSInteger indexOfChosenUserInAllUsersArray = [self.usersTVC.allUsersInfo indexOfObject:chosenUser];
  NSIndexPath *chosenIndexPathForUsersTVC = [NSIndexPath indexPathForRow:indexOfChosenUserInAllUsersArray inSection:0];
  if ([self.usersTVC respondsToSelector:@selector(performSegueToUserDescriptionWithCellAtIndexPath:)]){
      [self.usersTVC performSegueToUserDescriptionWithCellAtIndexPath:chosenIndexPathForUsersTVC];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass: [UserDescriptionViewController class]]){
        //get chosen cell index
        UserTableViewCell *chosenCell = (UserTableViewCell*)sender;
        NSIndexPath *chosenIndexPath = [self.tableView indexPathForCell:chosenCell];
        NSInteger cellIndex = chosenIndexPath.row;
        
        //give chosen user object
        UserDescriptionViewController *userDescriptionVC = (UserDescriptionViewController*)[segue destinationViewController];
        userDescriptionVC.user = [self.searchResults objectAtIndex:cellIndex];
    }
}
*/

@end
