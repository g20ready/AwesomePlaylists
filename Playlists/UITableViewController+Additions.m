//
//  UITableViewControllerAdditions.m
//  Playlists
//
//  Created by Marsel Xhaxho on 19/07/16.
//
//

#import "UITableViewController+Additions.h"

@implementation UITableViewController (Additions)

- (void) showRefreshControl {
    if (self.refreshControl) {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl.frame.size.height) animated:YES];
    }
}

@end
