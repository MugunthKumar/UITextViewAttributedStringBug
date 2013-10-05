//
//  SCTViewController.m
//  UITextViewAttributedStringBug
//
//  Created by Mugunth on 5/10/13.
//  Copyright (c) 2013 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "SCTViewController.h"

@interface SCTViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation SCTViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"applewiki" ofType:@"html"];
  NSString *htmlString = [NSString stringWithContentsOfFile:filePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
  
  NSAttributedString *attributedText = [[NSAttributedString alloc]
                                initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                options:@{
                                          NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                documentAttributes:nil
                                error:nil];
  
  self.textView.attributedText = attributedText;
  
  // lets add a KVO to watch contentSize
  // In iOS 6 the value changes only once. But in iOS 7 it changes as the user scrolls
  [self.textView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
  
  // lets highlight the word "Apple Computer, Inc"
  NSRange range = [attributedText.string rangeOfString:@"Apple Computer, Inc"];
  UITextPosition *start = [self.textView positionFromPosition:self.textView.beginningOfDocument offset:range.location];
  UITextPosition *end = [self.textView positionFromPosition:start offset:range.length];
  UITextRange *textRange = [self.textView textRangeFromPosition:start toPosition:end];
  CGRect rect = [self.textView firstRectForRange:textRange];
  // in the above rect, the x, width and height are correct. But y is a bit off.
  // I can show that to you by adding a view with that rect
  
  UIView *view = [[UIView alloc] initWithFrame:rect];
  view.backgroundColor = [UIColor yellowColor];
  view.alpha = 0.7;
  view.layer.cornerRadius = 10.0f;
  [self.textView addSubview:view];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
  if (object == self.textView && [keyPath isEqualToString:@"contentSize"]) {
    
    NSLog(@"%@", NSStringFromCGSize(self.textView.contentSize));
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object
                           change:change context:context];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
