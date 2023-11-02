using Godot;
using System;

public class Gauntlets : Node2D
{
    KinematicBody2D Player;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        Player = GetParent<KinematicBody2D>();
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        if (Player.Get("CurrentWeapon") == this) {
            GauntletController();
        }
    }

    public void GauntletController() {
        Show();
        Position = (GetGlobalMousePosition() - Player.Position).Normalized() * 50;
        Rotation = Player.GetAngleTo(GetGlobalMousePosition()) + (float)(Math.PI / 2);


        if (Input.IsActionPressed("attack")) {
            GetNode<AnimationPlayer>("AnimationPlayer").Play("Attack");
        }

        if (Input.IsActionPressed("block")) {
            
        }
    }

    public void SwitchInto() {
        Show();
    }

    public void SwitchOut() {
        Hide();
    }

}
