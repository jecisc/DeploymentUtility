"
Description
--------------------

I am facade providing scripts to help with the deployement of a Pharo application in production.

I implement most of the points raised in: https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/DeployYourPharoApplication.md
"
Class {
	#name : #DUFacade,
	#superclass : #Object,
	#category : #DeploymentUtility
}

{ #category : #obfuscation }
DUFacade class >> activateServerMode [
	"The server mode slow down the rendering process of Pharo to take less resouces."

	<script>
	self execute: [ WorldState serverMode: true ] recordedAs: 'Enable server mode (slow down rendering process)'
]

{ #category : #obfuscation }
DUFacade class >> addCommandLinesPassword: aString pepper: anotherString iterations: anInteger [
	"Once executed, most of the command lines will need a password to work. Only the command lines returning false to #requireDeploymentPassword will be executable."

	self
		execute: [ CommandLinePasswordManager protectCommandLinesByPasswordWith: aString pepper: anotherString numberOfHashIterations: anInteger ]
		recordedAs: 'Add password to command lines'
]

{ #category : #obfuscation }
DUFacade class >> allowToRunWithoutChangesAndSources [
	"In delevery we want to protect the sources. Thus, we want to only ship an image with bytecode. We do not deliver à .changes or .sources file. In order to make it work we replace some classes of Pharo."

	<script>
	self
		execute: [ FFICompilerPlugin install.
			NoChangesLog install.
			NoPharoFilesOpener install ]
		recordedAs: 'Allow to run without sources and changes'
]

{ #category : #cleaning }
DUFacade class >> cleanUpSystem [
	<script>
	self execute: [ Smalltalk cleanUp: true except: {} confirming: false ] recordedAs: 'Cleaning the system'
]

{ #category : #obfuscation }
DUFacade class >> closeAllWindows [
	<script>
	self execute: [ self currentWorld closeAllWindowsDiscardingChanges ] recordedAs: 'Close all windows'
]

{ #category : #obfuscation }
DUFacade class >> disableDebugger [
	<script>
	self execute: [ Smalltalk tools register: DURecorderDebugger as: #debugger ] recordedAs: 'Disabling debugger. Replace it by a debugger only loging the error.'
]

{ #category : #obfuscation }
DUFacade class >> disableDeprecationWarnings [
	<script>
	self
		execute: [ Deprecation
				raiseWarning: false;
				showWarning: false ]
		recordedAs: 'Disabling deprecation warnings'
]

{ #category : #obfuscation }
DUFacade class >> disableDragAndDropInWorld [
	"In Pharo it is possible to drag and drop files in the world to file in code. The final users should not be able to do that. Thus we disable this feature."

	<script>
	self execute: [ WorldMorph allowDropFiles: false ] recordedAs: 'Disabling world''s files drop feature'
]

{ #category : #obfuscation }
DUFacade class >> disableEpicea [
	"Epicea record all changes in the Pharo images to be able to replay them. In production we want to disable this."

	<script>
	self execute: [ EpMonitor reset ] recordedAs: 'Disabling Epicea'
]

{ #category : #obfuscation }
DUFacade class >> disableGlobalShortcuts [
	"In production we do not want to let the user open a playground or any other tool. Thus we disable global shortcuts."

	<script>
	self
		execute: [ (KMRepository default globalCategories flatCollect: [ :each | each allEntries keymaps ]) do: #disable ]
		recordedAs: 'Disabling global shortcuts'
]

{ #category : #monticello }
DUFacade class >> disableMonticelloCache [
	<script>
	self execute: [ MCCacheRepository uniqueInstance disable ] recordedAs: 'Disable Monticello cache'
]

{ #category : #obfuscation }
DUFacade class >> disableMorphHalos [
	"When doing a meta click on a morph, it opens an halo to interact with the morph. In delivery we block this because it could let the user access to our source code."

	<script>
	self execute: [ Morph halosEnabled: false ] recordedAs: 'Disabling halos'
]

{ #category : #obfuscation }
DUFacade class >> disableProcessInteruption [
	"In Pharo it is possible to interupt a process with the cmd/alt/ctrl + . shortcut. This method is here to disable it."

	<script>
	self execute: [ UserInterruptHandler cmdDotEnabled: false ] recordedAs: 'Disabling interuption process shortcut (cmd + .)'
]

{ #category : #obfuscation }
DUFacade class >> disableProgressBarInteruptionButton [
	"Disabling progress might messed up with the application. Thus we disable this possibility."

	<script>
	self execute: [ JobProgressBarMorph isInterruptable: false ] recordedAs: 'Disabling progress bar interuption'
]

{ #category : #obfuscation }
DUFacade class >> disableWorldMenu [
	<script>
	self execute: [ WorldState desktopMenuPragmaKeyword: '' ] recordedAs: 'Remove world menu'
]

{ #category : #'public API' }
DUFacade class >> execute: aBlock recordedAs: aString [
	"Make TinyLogger an optional dependancy. We can do better later but for now it will do."

	(self class environment hasClassNamed: #TinyLogger)
		ifTrue: [ super execute: aBlock recordedAs: aString ]
		ifFalse: [ self traceCr: 'Begin: ' , aString.
			aBlock cull: aString.
			self traceCr: 'End: ' , aString ]
]

{ #category : #obfuscation }
DUFacade class >> forceOmissionOfStartupPreferences [
	"In Delivery we block the loading of startup preferences because it can let the user access to our sources."

	<script>
	self execute: [ PharoCommandLineHandler forcePreferencesOmission: true ] recordedAs: 'Force to omit startup preferences'
]

{ #category : #obfuscation }
DUFacade class >> hideTaskbar [
	<script>
	self execute: [ TaskbarMorph showTaskbar: false ] recordedAs: 'Hide taskbar'
]

{ #category : #obfuscation }
DUFacade class >> removeDecompiler [
	<script>
	self execute: [ self removeFromSystemPackagesContaining: 'Flashback' ] recordedAs: 'Unload decompiler'
]

{ #category : #helpers }
DUFacade class >> removeFromSystemPackagesContaining: aString [
	RPackageOrganizer default packages select: [ :p | p name includesSubstring: aString ] thenDo: #removeFromSystem
]

{ #category : #monticello }
DUFacade class >> removeRepositories [
	<script>
	self
		execute: [ MCRepositoryGroup allSubInstancesDo: [ :group | group repositories do: [ :repo | group removeRepository: repo ] ] ]
		recordedAs: 'Removing all repositories from the image'
]

{ #category : #cleaning }
DUFacade class >> removeTestPackages [
	<script>
	self
		execute: [ #('Test' 'Example' 'Mock' 'Demo') do: [ :each | self removeFromSystemPackagesContaining: each ] ]
		recordedAs: 'Remove all tests and examples packages'
]

{ #category : #monticello }
DUFacade class >> resetRepositoryUsersAndPasswords [
	<script>
	self
		execute: [ MCHttpRepository
				allSubInstancesDo: [ :repo | 
					repo
						user: nil;
						password: nil ] ]
		recordedAs: 'Resetting all repository users and passwords'
]

{ #category : #display }
DUFacade class >> setHostWindowNameTo: aString [

	self
		execute: [ 
			SystemVersion current major < 10
				ifTrue: [ DisplayScreen setWindowTitle: aString ]
				ifFalse: [ self currentWorld worldState worldRenderer windowTitle: aString ] ]
		recordedAs: 'Change host window title to: ' , aString
]

{ #category : #'see class side' }
DUFacade >> seeClassSide [
]
