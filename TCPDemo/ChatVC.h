//
//  ChatVC.h
//  TCPDemo
//
//  Created by Tarun Sharma on 08/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatVC : UIViewController<NSStreamDelegate,UITextFieldDelegate>
{
//    CFReadStreamRef readStream;
//    CFWriteStreamRef writeStream;
        
    NSInputStream   *inputStream;
    NSOutputStream  *outputStream;
        
   
}

@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet UITextField *sendMessageTF;

- (IBAction)sendButtonClick:(id)sender;

@end
