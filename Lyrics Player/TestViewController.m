//
//  ViewController.m
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.03.16..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMediaPicker:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    
    mediaPicker.delegate=self;
    mediaPicker.prompt=@"Select song!";
    
    [self presentViewController:mediaPicker animated:YES completion:Nil];
}
-(void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    if (mediaItemCollection){
        NSLog(@"Number of songs: %lu", ((unsigned long) mediaItemCollection.count));
        
        for(MPMediaItem *media in mediaItemCollection.items){
            NSLog(@"Song: %@ - %@",[media valueForProperty:MPMediaItemPropertyArtist],[media valueForProperty:MPMediaItemPropertyTitle]);
        }
    }
}

@end
