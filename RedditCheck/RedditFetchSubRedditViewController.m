//
//  RedditFetchSubRedditViewController.m
//  RedditFetch
//
//  Created by Joe Jones on 1/12/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import "RedditFetchSubRedditViewController.h"
#import "RedditFetchStoryResults_TVC.h"

@interface RedditFetchSubRedditViewController ()
@property (nonatomic, strong) NSString *subReddit;
@property (nonatomic, strong) NSArray *listOfSubReddits;
@property (nonatomic, strong) NSArray *subRedditStoryCollection;
@property int storyNumber;
@end

@implementation RedditFetchSubRedditViewController

//synthize them properties
//
@synthesize subReddit = _subReddit;
@synthesize listOfSubReddits = _listOfSubReddits;
@synthesize picker = _picker;
@synthesize storyNumberSegment = _storyNumberSegment;
@synthesize versionNumber = _versionNumber;
@synthesize subRedditStoryCollection = _subRedditStoryCollection;

//constants
//
#define SMALL_STORY_LIMIT 10;
#define LARGE_STORY_LIMIT 100;
#define DEFAULT_SUB_REDDIT @"politics"
#define DEFAULT_STORY_LIMIT 25
#define REDDIT_REQUEST_URL @"http://www.reddit.com/r/%@.json?limit=%@"

//method for gathering the list of stories and placing them into the
//stories collection dict
//
-(void)addToStoriesCollection:(NSString *)passedModKey
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
    if(!self.storyNumber)
    {
        self.storyNumber = DEFAULT_STORY_LIMIT;
    }
    
    //first lets build our url
    //
    NSURL *redditURL = [NSURL URLWithString:[NSString stringWithFormat:REDDIT_REQUEST_URL ,chosenSubReddit, [NSString stringWithFormat: @"%d",self.storyNumber]]];
    
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
    
    self.subRedditStoryCollection = storyArray;
    
    NSLog(@"Logging %@",[storyArray objectAtIndex:1] );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //
    self.listOfSubReddits = [[NSArray alloc] initWithObjects:
                             @"lovecraft",
                             @"boardgames",
                             @"FanTheories",
                             @"atheism",
                             @"science",
                             @"politics",
                             @"programming",
                             @"math",
                             @"compsci",
                             @"somethingimade",
                             @"doctorwho",
                             @"selfsufficiency",
                             nil];
    
    self.storyNumber = SMALL_STORY_LIMIT;
    
    self.versionNumber.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PrestoBuildIdentifier"];
}

- (void)viewDidUnload
{
    [self setVersionNumber:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//storyNumberSegmentSelecter
//
-(IBAction)changeSeg
{
	if(self.storyNumberSegment.selectedSegmentIndex == 0)
    {
        self.storyNumber = SMALL_STORY_LIMIT;
	}
	if(self.storyNumberSegment.selectedSegmentIndex == 1)
    {
        self.storyNumber = LARGE_STORY_LIMIT;
	}
}

//uiviewpicker UI set up
//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.listOfSubReddits count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self.listOfSubReddits objectAtIndex:row];
}


//handle the selection here
//
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.subReddit = [self.listOfSubReddits objectAtIndex:row];
    
    //Thread this request and throw up a spinner while we are at it
    //Get that spinner set up
    //
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ai];
    
    [ai startAnimating];
    
    //ok lets build our thread
    //
    dispatch_queue_t subredditListOfStories = dispatch_queue_create("listOfStories", NULL);
    
    dispatch_async(subredditListOfStories, ^{
        
        
        [self addToStoriesCollection:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ai stopAnimating];
            [self performSegueWithIdentifier:@"redditViewer" sender:self];
        });
    });
    
    //clean up
    //
    dispatch_release(subredditListOfStories);
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RedditFetchStoryResults_TVC *storyListVC = [segue destinationViewController];

    storyListVC.subReddit = self.subReddit;
    storyListVC.numberOfStories = self.storyNumber;
    storyListVC.storiesCollection = self.subRedditStoryCollection;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
