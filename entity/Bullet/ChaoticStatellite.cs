using Godot;

public class ChaoticStatellite : Seeker {
    private struct Bullet {
        public Transform2D transform;
        public Vector2 velocity;
        public Node2D target;
        public readonly RID sprite;
        public Bullet(in float speed, in Transform2D trans, in RID canvas) {
            transform = trans;
            sprite = canvas;
            velocity = new Vector2(speed, 0).Rotated(trans.Rotation);
            target = null;
        }
    }
}
