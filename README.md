![Project Sloth GitHub Project PS-OBJECTSPAWNER Banner](https://user-images.githubusercontent.com/91661118/176777941-9f3dfa83-0da6-47e4-8cc9-5add55e198bc.png)

### ps-objectspawner
A well thought out simplistic user-friendly experience for spawning objects around your server.

![Project Sloth Buttons 2](https://user-images.githubusercontent.com/91661118/176778087-bd5285aa-09ac-4c5f-83d8-53687fab84a9.png)

### Dependencies:
* [qb-core](https://github.com/qbcore-framework/qb-core)
* [qb-target](https://github.com/BerkieBb/qb-target)
* [oxmysql](https://github.com/overextended/oxmysql)

### ⚠️Important:
First, run the included sql file to create the `objects` table in your database. Also, the `/object` command will only work for players with `god` permissions, by default.
If you have no permission to use the object command. Go to admin menu > Player Management > Select Player > Permission > Set Group to God > Confirm. Try again entering this command.

<br>

![Project Sloth GitHub Project PS-OBJECTSPAWNER Install Banner](https://user-images.githubusercontent.com/91661118/176777943-37417e7f-0f77-4afb-92ec-fb3fab2e6543.png)

### Instructions:
After creating the `objects` table and ensuring you have the `god` permission, use the `/object` command to open the spawning/management menu. In the Create menu, you can name and search for objects you would like to place in the world. You can also specify a spawning distance, that will determine when the object becomes visible to the player; this is specified in standard FiveM distance units. Finally, can add a type of target that the object will hold. We have provided an example (ex `container`) event/target that will create an inventory stash for the spawned object, but more can be added through the client code.

In the Manage menu, you will see all the objects you have added and information about each. You can also teleport to the objects and delete them, if needed.

Finally, the object hashes within the Search list are maintained in the included `objectlist` file.

<br>

![Project Sloth GitHub Project PS-OBJECTSPAWNER Features Banner](https://user-images.githubusercontent.com/91661118/176777942-becd37e0-3186-498f-ae00-ad5281bc2019.png)


#### Some features to mention within this ps-objectspawner:
* Spawn objects
* Manage objects
* Render distance for optimization
* Teleport to objects placed

<br>

![Project Sloth GitHub Project PS-OBJECTSPAWNER Showcase Banner](https://user-images.githubusercontent.com/91661118/176777945-9f072499-f1d5-41d4-ac56-c06b5064ecc2.png)


### Time to show you what it looks like!
Here's a few showcased examples while using ps-objectspawner.

#### Spawn object:
![unknown (4)](https://user-images.githubusercontent.com/91661118/176781258-063b432c-4f71-40d5-baf8-f74d3d01f6a6.png)

#### Place object:
![unknown (3)](https://user-images.githubusercontent.com/91661118/176781276-f33162bd-58d2-4ad9-977f-0da1ae03e758.png)

#### Manage objects:
![unknown (5)](https://user-images.githubusercontent.com/91661118/176781300-d4f717c8-9b44-43ea-b609-6a3846cb8006.png)

#### Search for object:
![unknown](https://user-images.githubusercontent.com/91661118/176781358-9907494d-2288-4b00-a15b-4d68620f707f.png)

### Credits:
Inspiration and some code snippets from [Svelte & Lua Boilerplate](https://github.com/project-error/svelte-lua-boilerplate) by [Project Error](https://github.com/project-error)

##### Copyright © 2022 Project Sloth. All rights reserved.
