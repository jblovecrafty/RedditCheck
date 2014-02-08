//
//  RedditFetchWebViewController.m
//  RedditFetch
//
//  Created by Joe Jones on 1/6/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import "RedditFetchWebViewController.h"
#import "RedditCommentsViewController.h"

@interface RedditFetchWebViewController () 

@end

@implementation RedditFetchWebViewController

@synthesize redditStoryURL = _redditStoryURL;
@synthesize redditCommentsURL = _redditCommentsURL;
@synthesize redditWebView = _redditWebView;

UIActivityIndicatorView *spinner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidUnload
{
    [self setRedditWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    //set up spinner here
    //
    self.redditWebView.delegate = self;
    
    CGFloat xVal = self.view.bounds.size.width/2;
    CGFloat yVal = self.view.bounds.size.height/2;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(xVal, yVal);
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
	
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.redditStoryURL];
    [self.redditWebView loadRequest:requestObj];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RedditCommentsViewController *redditComments = [segue destinationViewController];
    redditComments.redditCommentsURL = self.redditCommentsURL;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
