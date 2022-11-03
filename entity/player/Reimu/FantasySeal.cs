using Godot;
using System.Collections.Generic;

public class FantasySeal : Node {
    [Signal] delegate void Done();
    protected PackedScene orbScene = GD.Load<PackedScene>("res://entity/player/Reimu/seal-orb.scn");
    protected class SealOrb {
        protected Particles2D visual;
        protected Vector2 localPos = Vector2.Zero;
        protected Vector2 velocity;
        public SealOrb(in Particles2D node, in uint i) {
            visual = node;
            velocity = new Vector2(127, 0).Rotated(Mathf.Pi / 2 * i);
        }
        public void Move(in float delta, in float phi) {
            localPos += velocity * delta;
            localPos = localPos.Rotated(phi);
            visual.GlobalPosition = localPos;
            velocity = velocity.Rotated(phi);
        }
        public void Seek(in float delta) {

        }
    }
    protected Stack<SealOrb> orbs = new Stack<SealOrb>(4);
    protected SealOrb currentOrb;
    protected SceneTree tree;
    protected Node2D target;

    public override void _Ready() {
        for (uint i = 0; i != 4; i++) {
            Particles2D visual = orbScene.Instance<Particles2D>();
            AddChild(visual);
            SealOrb orb = new SealOrb(visual, i);
            orbs.Push(orb);
        }
        SetPhysicsProcess(false);
        target = (Node2D) GetNode("/root/Global").Get("boss");
        tree = GetTree();
        tree.CreateTimer(1).Connect("timeout", GetNode(GetPath()), "Attack");

    }
    public virtual void Attack() {
        SetPhysicsProcess(true);
        currentOrb = orbs.Pop();
    }
    public override void _Process(float delta) {
        float phi = delta * Mathf.Tau;
        foreach (SealOrb orb in orbs) {
            orb.Move(delta, phi);
        }
    }
    public override void _PhysicsProcess(float delta) {
        
    }
}
