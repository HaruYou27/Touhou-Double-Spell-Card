# How to use
Create a Node2D then assign a C# script from Bullet folder. If you dont see the export variable pop up in the inspector, hit the build button at the top right corner of the screen (make sure you're using Godot Mono x64 build too)

# Let me explain each of these variables:
Shape size: This is optional, in case you need precision collisionshape for the bullet. Otherwise, just assign a texture and my script will use the texture size for the collision size. Note, my script use Circle and Capsule shape.
Collide with Areas: If you use Area2D node for hitbox, check this.

Collide with Bodies: If you use hitbox inherits from PhysicsBody2D, check this.

Collision layer: You may dont want your player to be get hit by their own bullet and so the AI enemies. Godot comes with the physic layer for this problem. Check the layer where this bullet's targets are in and uncheck otherwise. (Dont blame me for the default value, blame Godot api.)

Texture: You MUST fill a texture in there, anything, just put something in there so the script can draw the bullet. Otherwise it will crashes. If you let the shape size variable blank, the script will use the texture size for bullet collision shape, so you probably want to crop all the useless transparent pixel in your texture (So the gpu and the cpu dont have to take these useless pixel into account.)

maxBullet: The maxium number of bullets can possible have. Try to keep this number as low as possible so it wont hurt performance. Exceed the limit and no more bullet will be shoot out until some current active bullets hit something and free the slot. (Warning: Dont set it to some ridiculous value like few thousands, millons, whatever or your computer will crash.)

Grazeable: Set this true and player will be able to graze the bullet

Speed: Bullet travel speed in pixel per second. You can change it in run time but only new bullet will be affected (You can also do that with other variable, but somes does not have any effect and somes like this.)

Material: This is optional, if you got some cool shader, create a Material resource and assign it here.

Z-index: Draw order.

Barrels: This is optional, if you need to share barrel node with other bullet node or can not set the barrel node as a child of this node for any reason. (Note: this variable will override children nodes.) Increase the array size then click on the eyedrop icon and choose NodePath, then the null will change into Assign... Click on it or drag the barrel node in the scene panel and drop it here. (Again, blame Godot if you feel inconvient, type Array in Godot 4 should make thing less troublesome.)

# Now let's make some barrel (refer to gun barrel) so you can shoot the bullet.
Create a node inherits from Node2D, recommend Position2D node since it has a cross in the editor for direction preview.

This tutorial assume you use a Position2D node but any node inherits from Node2D will get the job done.

In the 2D tab, you should see a cross made by a red line and a green line. By default, the bullet will shoot to the right, which is the bright red line (Im not sure what color it is on your editor, it maybe different if you set it from Editor setting. But by default it's the right because the world is designed for right-handed and so Godot does.)

Now if you want bullet to shoot from another direction, just use Godot rotation tool or set it from the inspector, just read Godot official doc if you dont know what and what in the editor.

Ok now here's important part, you MUST either put these nodes as children of the bullet node or assign it in the barrels variable.

Now create a timer node, set the time as you like and connect the signal to the bullet node method ```SpawnBullet()```

And that's it, run test your scene and see if things work.

# Report me if you have no idea of what the fuck is this thing about or some strange behavior
Detail tutorial for special bullet coming soon.
