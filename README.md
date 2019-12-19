# Worlds
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

For comments in the world file: If a line starts with a `#`, it is ignored.

### Additional notes
Bedrock blocks cannot be destroyed by the player.

Leave the plane with y-coordinate 0 as bedrock layer so that players don't fall into the void.

### List of structures with explanation
- artengis: a single blue wool block (Todo: the specified bedrock blocks just overwrite original bedrock blocks)
- bridge: a line of water blocks with a single blue wool block on each side to indicate the place where the bridge should start
- bridge_error: a copy of bridge with a typo. Should produce an error when loading.
