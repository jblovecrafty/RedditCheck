//
//  RedditFetchStoryResults_TVC.m
//  RedditFetch
//
//  Created by Joe Jones on 1/5/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import "RedditFetchStoryResults_TVC.h"
#import "RedditFetchWebViewController.h"

@interface RedditFetchStoryResults_TVC ()
@property (nonatomic, weak) NSURL *chosenURL;
@end

@implementation RedditFetchStoryResults_TVC

@synthesize modKey = _modKey;
@synthesize chosenURL = _chosenURL;
@synthesize subReddit = _subReddit;
@synthesize numberOfStories = _numberOfStories;

//lazy handling of the stories collection
//
-(NSArray *)storiesCollection
{
    return _storiesCollection;
}

-(void) setStoriesCollectiona:(NSArray *)storiesCollection
{
    if(![storiesCollection isEqualToArray:_storiesCollection])
    {
        _storiesCollection = storiesCollection;
    }
}

//set up constants here
//
#define TABLE_CELL_NAME @"redditStoryCell"
#define DEFAULT_SUB_REDDIT @"politics"
#define DEFAULT_STORY_LIMIT 25
#define REDDIT_REQUEST_URL @"http://www.reddit.com/r/%@.json?limit=%@"
#define REDDIT_BASE_URL @"http://www.reddit.com"

//method for gathering the list of stories and placing them into the
//stories collection dict
//
/*-(void)addToStoriesCollection:(NSString *)passedModKey
{
    NSString *chosenSubReddit;
    
    if(!self.subReddit)
    {
        chosenSubReddit = DEFAULT_SUB_REDDIT;
    }
    else
    {
        chosenSubReddit = self.subReddit;
    }
    
    //story limit
    //
    if(!self.numberOfStories)
    {
        self.numberOfStories = DEFAULT_STORY_LIMIT;
    }
    
    //first lets build our url
    //
    NSURL *redditURL = [NSURL URLWithString:[NSString stringWithFormat:REDDIT_REQUEST_URL ,chosenSubReddit, [NSString stringWithFormat: @"%d",self.numberOfStories]]];
    
     NSLog(@"redditURL %@",redditURL);
    
    //second lets make our request
    //
    NSMutableURLRequest *storyRequest = [NSMutableURLRequest requestWithURL:redditURL];
    
    [storyRequest setHTTPMethod:@"GET"];
    
    NSURLResponse *storyResponse = NULL;
    NSError *storyRequestError = NULL;
    
    NSData *storyResponseData = [NSURLConnection sendSynchronousRequest:storyRequest returningResponse:&storyResponse error:&storyRequestError];
    
    NSString *storyResponseString = [[NSString alloc]initWithData:storyResponseData encoding:NSUTF8StringEncoding];
    
    //last lets fill the stories collection
    //
    NSError *error;
    NSData *jsonData = [storyResponseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *storyResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSArray* storyArray = [storyResults valueForKeyPath:@"data.children"];
    
    self.storiesCollection = storyArray;
    
    NSLog(@"Logging %@",[storyArray objectAtIndex:1] );
}*/


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.storiesCollection = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self addToStoriesCollection:self.modKey];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //
    return self.storiesCollection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = TABLE_CELL_NAME;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // pull info from the dictionary
    //
    NSString *storyTitle = [[self.storiesCollection objectAtIndex:indexPath.row] valueForKeyPath:@"data.title"];
    
    cell.textLabel.text = storyTitle;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *baseURL = [[self.storiesCollection objectAtIndex:[[self.tableView indexPathForSelectedRow] row]] valueForKeyPath:@"data.url"];
    
    NSString *commentsURL = [[self.storiesCollection objectAtIndex:[[self.tableView indexPathForSelectedRow] row]] valueForKeyPath:@"data.permalink"];
    
    self.chosenURL = [NSURL URLWithString:baseURL];
    
    RedditFetchWebViewController *storyDetailVC = [segue destinationViewController];
    storyDetailVC.redditStoryURL = self.chosenURL;
    storyDetailVC.redditCommentsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REDDIT_BASE_URL,commentsURL]];
}

@end
