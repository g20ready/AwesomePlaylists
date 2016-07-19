//
//  ViewController.m
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    [self.loadingIndicator startAnimating];
    
    if ([[CoreDataManager sharedManager] hasPlaylists]) {
        [self performSegueWithIdentifier:@"showPlaylists" sender:self];
        return;
    }
    
    [[SyncManager sharedManager] syncPlaylists:^(NSError *error) {
        [self.loadingIndicator stopAnimating];
        if (error) {
            NSLog(@"Error while syncing playlists : %@", error);
            return;
        }
        [self performSegueWithIdentifier:@"showPlaylists" sender:self];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
