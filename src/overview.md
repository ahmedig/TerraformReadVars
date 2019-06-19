# Terraform vars into VSTS vars

[![Build Status](https://ahmedig.visualstudio.com/Azure%20Devops%20Extensions/_apis/build/status/ahmedig.TerraformReadVars?branchName=master)](https://ahmedig.visualstudio.com/Azure%20Devops%20Extensions/_build/latest?definitionId=5&branchName=master)

To contribute to this extension, please visit [this repository](https://github.com/ahmedig/TerraformReadVars).

## Introduction

 A lot of people use Terraform for infrastructure as code, and they save their values in tfvar files, for every environment.
In addition, when running builds and releases, sometimes you may need those values to pass them to other build tasks. This task is handy in such situation, where you would like to extract a tfvar value so easily into an Azure Devops variable $(something). It also supports the lookup option where there is a root key.
The below examples should explain more.

## How to use the task
These are the supported two scenarios on how to use the task.

> Output Variable Name: the name of the vsts variable that you can use later on like $(MyVstsVariableName) 

### Scenario 1:
When you have a direct key and value declared in a tfvar file like the below example:
```sh
Akey = "a value"
```
In this case, your properties in your task should look like that: (notice that the root key is left blank)

![Without Root key](https://image.ibb.co/caZ2BL/Screenshot-Without-Root-Key.png)

### Scenario 2:
When you have a root key, a key and value declared in a tfvar file like the below example. This is known as a lookup variable:
```sh
RootKey {
  key1 = "value1"
  key2 = "value2"
}
```
In this case, your properties in your task should look like that:

![With Root key](https://image.ibb.co/hEJ7d0/Screenshot-With-Root-Key.png)