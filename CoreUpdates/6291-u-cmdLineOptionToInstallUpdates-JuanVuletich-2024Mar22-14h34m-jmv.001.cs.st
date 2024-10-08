'From Cuis6.3 [latest update: #6290] on 22 March 2024 at 2:36:17 pm'!

!SystemDictionary methodsFor: 'startup' stamp: 'jmv 3/22/2024 14:35:51'!
displayCommandLineUsageOn: aStream
	"Display command line usage on standard out."

	[ aStream
		nextPutAll: 'Command line options:'; newLine;
		nextPutAll: '  -h Display this help message and quit'; newLine;
		nextPutAll: '  -v Display the system information, containing the version and quit'; newLine;
		nextPutAll: '  -q Just quit'; newLine;
		nextPutAll: '  -e Do not ignore exceptions, but open a Debugger'; newLine;
		nextPutAll: '  -u Install updates from CoreUpdates directory'; newLine;
		nextPutAll: '  -r <feature> Require <feature>'; newLine;
		nextPutAll: '  -d <code> Evaluate <code>'; newLine;
		nextPutAll: '  -l <codeFile> Load e.g. file in <codeFile>'; newLine;
		nextPutAll: '  -s <scriptFile> Evaluate code in <scriptFile>'; newLine;
		nextPutAll: '  -ud <directory> Set User Directory to be <directory>'; newLine;
		nextPutAll: '  -udIsBase Set User Directory to be Cuis Base directory'; newLine;
		nextPutAll: '  -- end of options; stop processing options'; newLine;
		newLine;
		nextPutAll: 'Arguments for scripts, code files, packages (and <code>):'; newLine;
		nextPutAll: '  are available in ''Smalltalk startUpScriptArguments'''; newLine;
		newLine;
		nextPutAll: 'Multiple options:'; newLine;
		nextPutAll: '  any option can be passed multiple times'; newLine ]
	on: UnhandledError
	do: [ :exception | exception return ].! !

!SystemDictionary methodsFor: 'startup' stamp: 'jmv 3/22/2024 14:34:27'!
processCommandLineOption: optionString optionArgument: optionArgument raiseExceptions: aBoolean
	"
	A possible example (duplicated single quotes: '' should be double quotes, but not allowed in a Smalltalk comment):
Squeak.app/Contents/MacOS/Squeak Cuis-Smalltalk-Dev/Cuis6.0-????.image -h
Squeak.app/Contents/MacOS/Squeak Cuis-Smalltalk-Dev/Cuis6.0-????.image -v
Squeak.app/Contents/MacOS/Squeak Cuis-Smalltalk-Dev/Cuis6.0-????.image -q
Squeak.app/Contents/MacOS/Squeak Cuis-Smalltalk-Dev/Cuis6.0-????.image -e -d''0 zope''
Squeak.app/Contents/MacOS/Squeak Cuis-Smalltalk-Dev/Cuis6.0-????.image -r YAXO -rJSON -d ''Smalltalk startUpScriptArguments print'' xx YY 3492 -d'' 'here comes another' print'' -d ''{'The answer is: '. Smalltalk startUpScriptArguments first asNumber + Smalltalk startUpScriptArguments second asNumber} print'' 3 4 -- -d'' 'not this' print' ''

Squeak.exe Cuis4.2-2211x.image -r RequiredFeature1 -r RequiredFeature2 -d ''Transcript show: 'popo1'; newLine'' -d ''Transcript show: 'popo2'; newLine'' -s smalltalkScript.st param1ToScript param2ToSCript ''parametro 3 to script ->>>--// 3''
	"
	"You can use 'Smalltalk startUpScriptArguments' inside the startUp script:"


	| exceptionToIgnoreOrNil file directory |
	exceptionToIgnoreOrNil := aBoolean ifFalse: [UnhandledError] ifTrue: [nil].
	optionString caseOf: {
		[ '-h' ] -> [
			self displayCommandLineUsageOn: StdIOWriteStream stdout.
			self quit ].

		[ '-v' ] -> [ 
			self displaySystemInformationStringOn: StdIOWriteStream stdout.
			self quit ].

		[ '-q' ] -> [ self quit ].

		[ '-u' ] -> [ ChangeSet installNewUpdates ].

		[ '-r' ] -> [		"as in 		-rRequiredFeature2        or         -r RequiredFeature2"
			{ 'Feature require: '. optionArgument } print.
			[ Feature require: optionArgument ] on: exceptionToIgnoreOrNil do: [:ex | ex return] ].

		[ '-d' ] -> [		"as in 		-d ''Transcript show: 'popo1'; newLine'' -d''Transcript show: 'popo2'; newLine''        (duplicated singleQuotes should read doubleQuote)"
			{ 'Compiler evaluate: '. optionArgument } print.
			[ Compiler evaluate: optionArgument ] on: exceptionToIgnoreOrNil do: [:ex | ex return] ].

		['-l' ] -> ["file in the file"
			file := optionArgument isAbsolutePathName
				ifTrue: [ FileEntry withAbsolutePathName: optionArgument ]
				ifFalse: [FileEntry withRelativePathName: optionArgument to: DirectoryEntry currentDirectory ].
			{ 'File in: '. optionArgument. ' -> '. file} print.
			[file readStreamDo: [ :stream | stream fileIn ]] on: exceptionToIgnoreOrNil do: [ :ex | ex return]].

		[ '-s' ] -> [		"as in 		-s smalltalkScript.st paramAlScript1 paramAlSCript2 ''parameter to script script ->>>--// 3'' 			(duplicated singleQuotes should read doubleQuote)"
			file := optionArgument isAbsolutePathName
				ifTrue: [ FileEntry withAbsolutePathName: optionArgument ]
				ifFalse: [FileEntry withRelativePathName: optionArgument to: DirectoryEntry currentDirectory ].
			{ 'Compiler evaluate contents of file named: '. optionArgument. ' -> '. file. ' arguments: '. self startUpScriptArguments } print.
			file exists ifTrue: [
				file readStreamDo: [ :stream |
					[ Compiler evaluate: stream contentsOfEntireFile ] on: exceptionToIgnoreOrNil do: [ :ex | ex return]]]].

		[ '-ud' ] -> [
			directory := optionArgument asDirectoryEntry.
			DirectoryEntry setUserBaseDirectory: directory ].

		[ '-udIsBase' ] -> [ DirectoryEntry setUserBaseDirectoryAsCuisBase ].
	}
	otherwise: [].! !

