using Godot;
using System;

public class HUD : Control
{
    int score = 0;
    PackedScene Pointer = GD.Load<PackedScene>("res://Pointer.tscn");

    public override void _Process(float delta)
    {
        Vector2 Middle = GetViewport().Size / 2;

        KinematicBody2D NearestStunned = null;
        Vector2 PlayerPos = GetParent().GetParent().GetNode<KinematicBody2D>("Player").Position;

        foreach (KinematicBody2D Body in GetTree().GetNodesInGroup("Melee Enemies"))
        {
            if ((bool)Body.Get("stunned"))
            {
                if (NearestStunned == null)
                {
                    NearestStunned = Body;
                } else if (Body.Position.DistanceTo(PlayerPos) < NearestStunned.Position.DistanceTo(PlayerPos))
                {
                    NearestStunned = Body;
                }
            }
        }

        if (NearestStunned != null)
        {
            Sprite Pointer = GetNode<Sprite>("Pointer");
            Pointer.Position = Middle + (NearestStunned.Position - PlayerPos).Normalized() * 80; 
            Pointer.Rotation = PlayerPos.AngleToPoint(NearestStunned.Position) - Mathf.Pi / 2;
        }

    }

    public override void _Input(InputEvent @event)
    {
        if (Input.IsActionJustPressed("switch_element")) {
            Sprite icon = GetNode<Sprite>("element");

            if (icon.Texture.ResourcePath == "res://Player/Fire.png") {
                icon.Texture = (Texture)GD.Load("res://Player/lightning.png");
            } else if (icon.Texture.ResourcePath == "res://Player/lightning.png") {
                icon.Texture = (Texture)GD.Load("res://Player/ice.png");
            } else if (icon.Texture.ResourcePath == "res://Player/ice.png") {
                icon.Texture = (Texture)GD.Load("res://Player/Fire.png");
        }
    }}

    public void _score_update(int change)
    {
        score += change;
        GetNode<Label>("Score").Set("text", score.ToString());
    }

    public void _StunnedPointer(bool add, Vector2 direction)
    {
    //    GD.Print("amogus");
    }

}
