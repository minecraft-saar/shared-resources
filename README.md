**Work in progress, not finished yet**

# Adding new scenarios
To add a new scenario <scenario1\> you have to add the following files:

1. ```src/main/resources/de/saar/minecraft/domains```:
- <scenario1\>.init: file needed to run the minecraft server
- <scenario1\>.lisp: the domain of the scenario
- <scenario1\>-p01.lisp: the problem of the scenario
- <scenario1\>-block.plan: a plan for the problem with the abstraction level block
- <scenario1\>-medium.plan: a plan for the problem with the abstraction level medium
- <scenario1\>-highlevel.plan: a plan for the problem with the abstraction level highlevel

2. ```src/main/resources/de/saar/minecraft/questionnaires```:
- <scenario1\>.txt: a questionnaire for the player after the scenario was finished successfully

3. ```src/main/resources/de/saar/minecraft/worlds```:
- <scenario1\>.csv: predefined structures in the minecraft world

# 1. Domains
## Generate the plans
Run the [Jshop-Planner](https://github.com/minecraft-saar/jshop) on the according abstraction level using the files <scenario1\>.lisp as DOMAINFILE and <scenario1\>-p01.lisp as PROBLEMFILE.

The end of the output of the planner will have a form like this:
```
********* PLAN *******
( (instruction_1  ) cost_of_instruction_1 ... (instruction_n  ) cost_of_instruction_n  )
```
Now you can copy the instructions inside the outer brackets (without copying the outer brackets as well!) and paste it into the according plan file. Afterwards you have to insert line breaks after the cost of each instruction. The .plan file should look like the following:
```
(instruction_1  ) cost_of_instruction_1
...
(instruction_n  ) cost_of_instruction_n
```
Example:

- Planner output:
```
********* PLAN *******
( (!place-block stone 7.0 66.0 6.0 100.0 100.0 100.0  ) 2.0 (!place-block stone 9.0 66.0 6.0 7.0 66.0 6.0  ) 2.0  )
```
- .plan file:
```
(!place-block stone 7.0 66.0 6.0 100.0 100.0 100.0  ) 2.0
(!place-block stone 9.0 66.0 6.0 7.0 66.0 6.0  ) 2.0
```

## Create the .init file
The problem files have a general form like this:
```
(defproblem problem-<scenario1\> build-<scenario1\> ( 
  (last-placed 100 100 100) ...
  ) 
 
((build-<scenario1\> x ... z)) 
 )
```
You have to paste the following part into the .init file:
```
build-<scenario1\> x ... z

```

# 2. Questionnaires
**TODO**

# 3. Worlds
This repository contains files of predefined structures for Minecraft worlds.

### Format
The .csv-files have four columns:

- x-coordinate
- y-coordinate
- z-coordinate
- Material

Example: 

```
3,2,3,BLUE_WOOL
4,2,3,BLUE_WOOL
1,1,4,WATER
```

The Material is written as specified in the enum org.bukkit.Material from the spigot API.

For comments in the world file: If a line starts with a #, it is ignored.

### Additional notes
Bedrock blocks cannot be destroyed by the player.

Leave the plan with y-coordinate 0 as bedrock layer so that players don't fall into the void.

### List of structures with explanation
**TODO**
