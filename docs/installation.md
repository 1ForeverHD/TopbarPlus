#### Take the model
{recommended}

1. Take the [TopbarPlus model](https://create.roblox.com/store/asset/92368439343389/TopbarPlus).
2. Open the toolbox and navigate to Inventory -> My Models.
3. Click TopbarPlus to insert into your game and place anywhere within ``ReplicatedStorage`` or ``Workspace``. 
4. TopbarPlus is a package so you can update it instantly (instead of re-adding) by right-clicking the Icon module and selecting an option such as 'Get Latest Package':

    <a><img src="https://i.imgur.com/kIZdT83.png" width="50%"/></a>

5. You can receive automatic updates by enabling 'AutoUpdate' within the PackageLink:

    <a><img src="https://i.imgur.com/2hGbjTS.png" width="50%"/></a>

!!! info
    All v3 updates will be backwards compatible so you don't need to worry about updates interfering with your code.

!!! warning
    Try not to modify any code within the Icon package otherwise it will break the package link.

!!! important
    As of 7th June 2025 public packages haven't been rolled out by Roblox. Only after their full release will you be able to benefit from easily installable updates. For the time being, attempting to use 'Get Latest Package' and other package features will throw an error.

-------------------------------------

#### Download from Releases
1. Visit the [latest release](https://github.com/1ForeverHD/TopbarPlus/releases/latest).
2. Under *Assets*, download ``TopbarPlus.rbxm``.
3. Within studio, navigate to MODEL -> Model and insert the file anywhere within ``ReplicatedStorage``. 

-------------------------------------

#### With Rojo
1. Setup with [Rojo](https://rojo.space/).
2. Visit the [TopbarPlus repository](https://github.com/1ForeverHD/TopbarPlus).
3. Click *Fork* in the top right corner.
4. Clone this fork into your local repository.
5. Modify the ``serve.project.json`` file to your desired location (by default TopbarPlus is built directly into ``Workspace``).
6. Call ``rojo serve`` (terminal or VSC plugin) and connect to the rojo studio plugin.

-------------------------------------

#### With Wally
TopbarPlus is now on Wally! You can find it [here](https://wally.run/package/1foreverhd/topbarplus).