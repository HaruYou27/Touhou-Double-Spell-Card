# How to use

Create a Node2D then assign a C# script from Bullet folder. If you dont see the export variable pop up in the inspector, hit the build button at the top right corner of the screen (make sure you're using Godot Mono x64 build too)

# Let me explain each of these variables:

Shape size: This is optional, in case you need precision collisionshape for the bullet. Otherwise, just assign a texture and my script will use the texture size for the collision size. Note, I use circle and capsule collision shape for bullet since it's very easy to compute and by default, it's capsule shape. Set both x and y to the radius of the circle if you want a cirle shape.

Collide with Areas: If you use Area2D node for hitbox, check this.

Collide with Bodies: If you use KinematicBody2D/RigidBody2D/StaticBody2D node for hitbox, check this.

Collision layer: You may dont want your player to be get hit by their own bullet and so the AI enemies. Godot comes with the physic layer for this problem. Check the layer where this bullet's targets are in and uncheck otherwise. (Dont blame me for the default value, blame Godot api.)

Texture: You MUST fill a texture in there, anything, just put something in there so the script can draw the bullet. Otherwise it will crashes. If you let the shape size variable blank, the script will use the texture size for bullet collision shape, so you probably want to crop all the useless transparent pixel in your texture (So the gpu and the cpu dont have to take these useless pixel into account.)

maxBullet: The maxium number of bullets can possible have. Try to keep this number as low as possible so it wont hurt performance. Exceed the limit and no more bullet will be shoot out until some current active bullets hit something and free the slot. (Warning: Dont set it to some ridiculous value like few thousands, millons, whatever or your computer will crash.)

Fire rate: The number bullets fire out the barrel in second. The maxium value is 60 because the game runs in 60fps. Higher value will cause bullet to overlap. (In CSGO they have to batch these bullet and send them in 1 go, which is kinda messy.)

Speed: Bullet travel speed in pixel per second. You can change it in run time but only new bullet will be affected (You can also do that with other variable, but somes does not have any effect and somes like this.)

Material: This is optional, if you got some cool shader, create a Material resource and assign it here.

Z-index: This is Godot CanvasItem z-index, you should keep this unique for each bullet texture so the engine doesnt have to do too much check for batching all the bullets into a draw call. Greatly improve peformance.

Shoting: Check this and bullets will come out by the firerate you set.

Barrels: This is optional, if you need to share barrel node with other bullet node or can not set the barrel node as a child of this node for any reason. (Note: this variable will override children nodes.) Increase the array size then click on the eyedrop icon and choose NodePath, then the null will change into Assign... Click on it or drag the barrel node in the scene panel and drop it here. (Again, blame Godot if you feel inconvient, type Array in Godot 4 should make thing less troublesome.)

Woa that's quite a lot isn't it? Yes and i have to went though all this mess when making this "System". Making game is hard and this is my best try to keep stuff as simple as possible for you by cover all of this under a level of abstraction. Nerd talk aside, 

# now let's make some barrel (refer to gun barrel) so you can shoot the bullet.

Create a node inherits from Node2D. Seriously, you can just use any 2D-related-Node for the barrel, but i recommend Position2D node since it basically Node2D + a cross in the editor for direction preview.

This tutorial assume you use a Position2D node but as I said, any node inherits from Node2D get the job done.

So in the 2D tab, you should see a cross made by a red line and a green line. By default, the bullet will shoot to the right, which is the bright red line (Im not sure what color it is on your editor, it maybe different if you set it from Editor setting. But by default it's the right because the world is designed for right-handed and so Godot does.)

Now if you want bullet to shoot from another direction, just use Godot rotation tool or set it from the inspector, just read Godot official doc if you dont know what and what in the editor.

Ok now here's important part, you MUST either put these nodes as children of the bullet node or assign it in the barrels variable.

And that's it, run test your scene and see if something bad will happen.

# Report me if you have no idea of what the fuck is this thing about or some strange behavior
Detail tutorial for special bullet coming soon.