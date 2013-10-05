UITextViewAttributedStringBug
=============================

This is the sample code illustrating the Radar 15159094
Summary:

Issue 1. The UITextView calculates the contentSize as the user scrolls. As a result the scroll indicators jump randomly.

Issue 2. Because the text view doesn't know about the complete size of content, methods like

firstRectForRange:
caretRectForPosition:

dont' return the right values on iOS 7.

Steps to Reproduce:
1. Download the sample app attached here.
2. Run it on your iPhone running iOS 7 using Xcode 5+
3. The app displays a static HTML file converted to NSAttributedString
4. The app also adds a Key Value Observer to watch changes on contentSize
5. Scroll the text view.

6. Search for a text (Apple Computer, Inc) in the attributed text and get its range. Convert the NSRange to UITextRange.
  NSRange range = [attributedText.string rangeOfString:@"Apple Computer, Inc"];
  UITextPosition *start = [self.textView positionFromPosition:self.textView.beginningOfDocument offset:range.location];
  UITextPosition *end = [self.textView positionFromPosition:start offset:range.length];
  UITextRange *textRange = [self.textView textRangeFromPosition:start toPosition:end];

7. Get the rectangle for this textRange using the method firstRectForRange and add a subview at this rectangle

Expected Results:
1. The contentSize should be calculated once when the attributedText is loaded.

2. The subview added in Step 7 should be exactly on top of the keyword we searched

Actual Results:
The contentSize is recalculated when the user scrolls. Consequently, you will notice that the contentSize is recalculated. As the contentSize gets recalculated the scroll indicator jumps back a little.

The subview added in Step 7 is not on the keyword we searched

Version:
iOS 7.0 and iOS 7.0.2

Notes:


Configuration:
This bug occurs only on iOS 7 and above
On iOS 6, the behaviour is as expected
