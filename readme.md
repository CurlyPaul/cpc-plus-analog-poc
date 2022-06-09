# gx4000-analog-demo

## Introduction

A simple POC showing how the analog inputs of the Amstrad Plus range of computers could be used. The port has been barely used so far, and while it looks like it's a normal db15 port, it's wired differently compared the easier to find PC analog sticks. If willing to sacrifice it, it's possible to rewire the more common PC sticks to work. 

Large parts of this are lifted directly from the tutorials and examples found at https://cpctech.cpc-live.com/ and with information found on https://www.cpcwiki.eu/index.php/Analog_Joysticks 

## Building and Running

Built using RASM, and a crude script to build and launch is provided with build.ps1. There is a flag to change between a debug build or to output a cpr


### Prerequisites 

Download and extract WinApe from http://www.winape.net/

Download and install RASM from https://github.com/EdouardBERGE/rasm/releases 

Add RASM to your path

either run build.ps1, or:

rasm debug.asm

or 

resm release.asm