using Godot;

public class SineAlpha : BulletBasic {
    //Bullet that change it's alpha value by sine wave.

    protected override void BulletConstructor(){
        VisualServer.CanvasItemSetModulate(sprites[activeIndex], new Color(1, 1, 1, Mathf.Abs(Mathf.Sin(Time.GetTicksMsec()))));
    }
}
