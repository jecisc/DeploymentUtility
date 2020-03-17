"
I am a baseline to define the structure and dependencies of the DeploymentUtility project.
"
Class {
	#name : #BaselineOfDeploymentUtility,
	#superclass : #BaselineOf,
	#category : #BaselineOfDeploymentUtility
}

{ #category : #baseline }
BaselineOfDeploymentUtility >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'DeploymentUtility' ]
]

{ #category : #accessing }
BaselineOfDeploymentUtility >> projectClass [
	^ MetacelloCypressBaselineProject
]
