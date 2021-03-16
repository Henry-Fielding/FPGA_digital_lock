## ELEC5566M Written Assignment Repository - State Machine Based Digital Lock 

This repository contains the Verilog HDL files required for the Statemachine Based Digital Lock.
The included files and project heirarchy are as follows

# 1st level

| Filename 				| Descriptions                 			 |
|--------------------|---------------------------------------|
| digitalLock.v     	| top level module for the digital lock |

# 2nd level

| Filename 						| Descriptions                 			|
|--------------------------|--------------------------------------|
| lockStateMachine.v 		| submodule containing the heirachrical FSM controlling the locking function of the digital lock - instantiated in digitalLock.v |
| displayStateMachine.v 	| submodule containing the Moore FSM used to control the 7 segement display outputs - instantiated in digitalLock.v |

# 3rd level

| Filename 						| Descriptions                 			|
|--------------------------|--------------------------------------|
|hexTo7SegmentNBit.v			| submodule containing the N bit wide 7 segment encoder module - instantiated in displayStateMachine.v |

# 4th level

| Filename 						| Descriptions                 			|
|--------------------------|--------------------------------------|
|hexTo7Segment.v				| submodule containing the 1 bit wide 7 segment encoder module - instantiated in hexTo7SegmentNBit.v	|

# Test benches

| Filename 						| Descriptions                 			|
|--------------------------|--------------------------------------|
| digitalLock_tb.v 			| test bench for 1st level module digitalLock.v |