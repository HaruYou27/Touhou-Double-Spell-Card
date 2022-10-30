# Labeled Z index
Lost track of your Z Index ? This plugin allow you to assign name to Z index just like Physics/Render layer in Godot.

This is an 3.x plugin. I will update this plugin if Godot 4 still doesnt have Z Index naming feature.

# Installation
Download or clone this repository into your ```res://addons/ folder.```

Go to your __Project Setting -> Plugins__ and enable this plugin.

# Assign name to your Z Index
Just like how you would assign name to your Physics/Render layer, go to __Project Setting -> General -> Layer Names -> Z Index__

Now add your Z Index number of choice into the Z Index dictionary. Keep in mind that the key must be a **String** and the value must be an **Integer**.

Otherwise the plugin will ignore it.

![Screenshot_20221028_233029](https://user-images.githubusercontent.com/68549456/198691268-15696c75-8a17-4916-9670-47713e84dc2b.jpg)

# Set Z Index
The Z Index property is located in CanvasItem category in the inspector. If you assigned the name correctly, a list of Z Index should drop down. Pick one and see if the Z Index property in your Node2D changed. If not, please open an issue.

![Screenshot_20221028_233626](https://user-images.githubusercontent.com/68549456/198691298-e91ffc23-61d4-4699-b507-89e2de26641e.jpg)

# Known issue
Control nodes Z Index only work in the editor:

Control node also inherits from CanvasItem so it's possible to set Z Index at run time with

```
VisualServer.canvas_item_set_z_index(rid, z_index)
```

## License
[MIT](https://choosealicense.com/licenses/mit/)
