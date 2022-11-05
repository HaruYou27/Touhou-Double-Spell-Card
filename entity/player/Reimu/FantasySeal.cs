using Godot;
using System.Collections.Generic;

public class FantasySeal : Node {
	[Signal] delegate void done();
	protected PackedScene orbScene = GD.Load<PackedScene>("res://entity/player/Reimu/seal-orb.scn");
	protected class SealOrb {
		public Particles2D visual;
		protected Vector2 localPos = Vector2.Zero;
		protected Vector2 velocity;
		protected Node2D parent;
		public SealOrb(in Particles2D node, in uint i, in Node2D root) {
			visual = node;
			visual.GlobalPosition = root.GlobalPosition;
			velocity = new Vector2(127, 0).Rotated(Mathf.Pi / 2 * i);
			parent = root;
		}
		public void Move(in float delta, in float phi) {
			localPos += velocity * delta;
			localPos = localPos.Rotated(phi);
			visual.GlobalPosition = localPos + parent.GlobalPosition;
			velocity = velocity.Rotated(phi);
		}
	}
	protected Stack<SealOrb> orbs = new Stack<SealOrb>(4);
	protected Particles2D currentOrb;
	protected SceneTree tree;
	protected World2D world;
	protected Node2D Global;
	protected ItemManager itemManager;

	protected Node2D target;
	protected Physics2DShapeQueryParameters query = new Physics2DShapeQueryParameters();
	protected RID shape = Physics2DServer.CircleShapeCreate();

	public override void _Ready() {
		Node2D parent = GetParent<Node2D>();
		for (uint i = 0; i != 4; i++) {
			Particles2D visual = orbScene.Instance<Particles2D>();
			AddChild(visual);
			SealOrb orb = new SealOrb(visual, i, parent);
			orbs.Push(orb);
		}
		SetPhysicsProcess(false);

		Global = GetNode<Node2D>("/root/Global");
		itemManager = GetNode<ItemManager>("/root/ItemManager");
		target = (Node2D) Global.Get("boss");
		tree = GetTree();
		tree.CreateTimer(1).Connect("timeout", this, "Attack");
		world = Global.GetWorld2d();

		Physics2DServer.ShapeSetData(shape, 55);
		query.ShapeRid = shape;
		query.CollideWithAreas = true;
		query.CollideWithBodies = false;
		query.CollisionLayer = 2;

	}
	public virtual void Attack() {
		SetPhysicsProcess(true);
		currentOrb = orbs.Pop().visual;
	}
	public override void _Process(float delta) {
		float phi = delta * Mathf.Tau;
		foreach (SealOrb orb in orbs) {
			orb.Move(delta, phi);
		}
	}
	protected virtual void Move(in float delta) {
		currentOrb.GlobalPosition += (target.GlobalPosition - currentOrb.GlobalPosition).Normalized() * delta * 727;
	}
	protected virtual void Impact() {
		currentOrb.Emitting = true;
		currentOrb.GetNode<Particles2D>("trail").Emitting = false;
		currentOrb.GetNode<Node>("orb").QueueFree();
	}
	public override void _PhysicsProcess(float delta) {
		Move(delta);
		query.Transform = currentOrb.Transform;

		if (world.DirectSpaceState.GetRestInfo(query).Count == 0) {
			return;
		}

		Global.EmitSignal("impact");
		itemManager.autoCollect = true;
		OS.DelayMsec(15);

		Impact();
		target.Call("_spell_hit", 0.25);
		if (orbs.Count > 0) {
			currentOrb = orbs.Pop().visual;
			return;
		}

		SetPhysicsProcess(false);
		SetProcess(false);
		tree.CreateTimer(2).Connect("timeout", this, "_Timeout");

	}
	public virtual void _Timeout() {
		EmitSignal("done");
		QueueFree();
	}
}
