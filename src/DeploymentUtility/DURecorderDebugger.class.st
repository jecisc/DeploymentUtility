"
Description
--------------------

A class to not open debuggers in production. I will instead log the errors via TinyLogger (https://github.com/jecisc/TinyLogger) if present in the image, or in the trascript otherwise.
"
Class {
	#name : #DURecorderDebugger,
	#superclass : #Object,
	#category : #DeploymentUtility
}

{ #category : #'opening api' }
DURecorderDebugger class >> messageToPrintFrom: aDebugSession [
	^ String
		streamContents: [ :s | 
			s
				<< 'ERROR. Here is the stack:';
				<< OSPlatform current lineEnding.
			aDebugSession interruptedContext shortDebugStackOn: s ]
]

{ #category : #opening }
DURecorderDebugger class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	self flag: #pharo7.	"When Pharo 8 will be the minimal requirement, inherits from LogDebugger."

	"Make TinyLogger an optional dependancy. We can do better later but for now it will do."

	(self class environment hasClassNamed: #TinyLogger)
		ifTrue: [ (self messageToPrintFrom: aDebugSession) record ]
		ifFalse: [ self traceCr: (self messageToPrintFrom: aDebugSession) ]
]
