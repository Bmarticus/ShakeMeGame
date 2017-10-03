//
//  ViewController.m
//  ShakemeGame
//
//  Created by Brian Martinez on 10/2/17.
//  Copyright © 2017 Brian Martinez. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSTimer *timer;
    
    int     counter;
    int     shakeScore;
    int     rotateScore;
    int     score;
    int     counterSetting;
    int     gameMode; // 1 - currently being played
                      // 2 - game over
}
@property (weak, nonatomic) IBOutlet UIButton *btnStartGame;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgmSelectGameType;
@property (nonatomic, readonly) UIDeviceOrientation orientation;
@property (weak, nonatomic) IBOutlet UISlider *sliderChooseTime;
@property (weak, nonatomic) IBOutlet UIButton *btnStopGame;
-(void) updateScore;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize variables
    shakeScore = 0;
    rotateScore = 0;
    score = 0;
    counter = counterSetting;
    [self sliderUpdate];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gameStarted:(id)sender {
    //this code will run when user presses button
    if (score == 0){
        // my way ...counter = 10;
        gameMode = 1; //we started the game
        self.lblTimer.text = [NSString stringWithFormat:@"%i", counter ];
        //create a timer
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector (startCounter) userInfo:nil repeats:YES];
        
        //button is disabled when game is started
        self.btnStartGame.enabled = NO;
        self.sgmSelectGameType.enabled = NO;
        self.sliderChooseTime.enabled = NO;
        
        //start device orientatio notifcation service
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];

        if (counter == 0 ) {
            score = 0;
            counter = counterSetting;
            self.lblTimer.text = [NSString stringWithFormat:@"%i", counter];
            self.lblTimer.text = [NSString stringWithFormat:@"%i", score];
        }
    }
}

-(void) startCounter {
    //decrement the counter
    counter -= 1;
    self.lblTimer.text = [NSString stringWithFormat:@"%i", counter];
    
    if (counter == 0){
        [timer invalidate];
        gameMode = 2;        //game is over
        
        //enable button again to restart game
        [self.btnStartGame setTitle:@"Restart" forState:UIControlStateNormal];
        self.btnStartGame.enabled = YES;
        self.sgmSelectGameType.enabled = YES;
        self.sliderChooseTime.enabled = YES;
    }
}


-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(event.subtype == UIEventSubtypeMotionShake){
        if(gameMode == 1){
            //increment score
            shakeScore += 1;
            
            //display it
            [self updateScore];
        }
    }
    
    
    

}




- (IBAction)selectedGameType:(id)sender {
    
    if(self.sgmSelectGameType.selectedSegmentIndex == 0){
        score = shakeScore;
    }
    else {
        score = rotateScore;
    }
}

-(void) updateScore {
    if(self.sgmSelectGameType.selectedSegmentIndex == 0){
        score = shakeScore;
        
    }
    else {
        score = rotateScore;
    }
    //display it
    self.lblScore.text = [NSString stringWithFormat:@"%i", score];
}

-(void)deviceOrientationDidChange{
    if(gameMode == 1){
        //increment score
        rotateScore += 1;
        
        //display it
        [self updateScore];
    }
}

- (IBAction)sliderChanged:(id)sender {
    [self sliderUpdate];
    
}
- (void)sliderUpdate {
    counterSetting = self.sliderChooseTime.value;
    counter = counterSetting;
    self.lblTimer.text = [NSString stringWithFormat:@"%i", counter];
    
}
- (IBAction)stopGame:(id)sender {
    counter = 1;
    
    
}



@end
