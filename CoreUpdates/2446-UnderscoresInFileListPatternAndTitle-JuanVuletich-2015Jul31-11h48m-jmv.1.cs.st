'From Cuis 4.2 of 25 July 2013 [latest update: #2445] on 31 July 2015 at 11:48:54.501165 am'!

!FileList methodsFor: 'volume list and pattern' stamp: 'jmv 7/31/2015 11:44'!
pattern

	^ Text string: (pattern ifNil: ['*']) attribute: TextEmphasis withUnderscoreGlyphs ! !


!Preferences class methodsFor: 'fonts' stamp: 'jmv 7/31/2015 11:46'!
setWindowTitleFontTo: aFont
	"Set the window-title font to be as indicated"

	self parameters at: #windowTitleFont put: aFont withUnderscoreGlyphs! !

"Postscript:
Leave the line above, and replace the rest of this comment by a useful one.
Executable statements should follow this comment, and should
be separated by periods, with no exclamation points (!!).
Be sure to put any further comments in double-quotes, like this one."
	Preferences standardFonts!

