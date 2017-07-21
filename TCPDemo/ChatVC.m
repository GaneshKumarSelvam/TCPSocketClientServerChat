//
//  ChatVC.m
//  TCPDemo
//
//  Created by Tarun Sharma on 08/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "ChatVC.h"

@interface ChatVC ()

@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sendMessageTF.delegate=self;
    [self initNetworkCommunication];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initNetworkCommunication {
    
    uint portNo = 13370;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)@"127.0.0.1", portNo, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    
    
}




- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
   
    uint8_t buffer[1024];
    NSInteger len;
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened now");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"has bytes");
            if (theStream == inputStream) {
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                         NSLog(@"server said Before: %@", output);
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            [_chatTextView performSelectorOnMainThread:@selector(setText:) withObject:[_chatTextView.text stringByAppendingString:[NSString stringWithFormat:@"Server wrote:\n%@\n\n", output]] waitUntilDone:NO];
                        }
                    }
                }
            } else {
                NSLog(@"it is NOT theStream == inputStream");
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
            break;
            
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            break;
            
        default:
            NSLog(@"Unknown event %lu", (unsigned long)streamEvent);
    }
    


}

#pragma mark  UITextfield Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendButtonClick:(id)sender {
    
   
    NSLog(@"Send Called");
    NSString *response  = [NSString stringWithFormat:@"msg:%@", _sendMessageTF.text];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    [_chatTextView setText:[_chatTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", [UIDevice currentDevice].name,_sendMessageTF.text]]];
    [_sendMessageTF setText:@""];
}
@end
