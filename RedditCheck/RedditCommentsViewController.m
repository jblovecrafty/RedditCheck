//
//  RedditCommentsViewController.m
//  RedditCheck
//
//  Created by Joe Jones on 5/2/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import "RedditCommentsViewController.h"

@interface RedditCommentsViewController ()

@end

@implementation RedditCommentsViewController
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
	
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.redditCommentsURL];
    [self.redditWebView loadRequest:requestObj];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
} // Dispose of any resources that can be recreated.


@end
