using Godot;
using System;

public class Enemy : KinematicBody2D
{
    KinematicBody2D Player;
    Control HUD;
    PackedScene BLAST;
    float speed = 100;
    int max_health = 100;
    int health;
    int KnockbackDistance = 2000;

    [Signal]
    public delegate void ScoreUpdate(int score);
    
    /////////////////////////////////////////// Main ///////////////////////////////////////////
    
    public override void _Ready()
    {
        health = max_health;

        Player = GetParent().GetNode<KinematicBody2D>("Player");
        HUD = GetParent().GetNode<Control>("CanvasLayer/HUD");

        BLAST = GD.Load<PackedScene>("res://Blast/Blast.tscn");

        Connect("ScoreUpdate", HUD, "_score_update");
    }
    public override void _Process(float delta)
    {
        Vector2 Velocity = CalculateVelocity();
        MoveAndSlide(Velocity);
    }

    //////////////////////////// Functions ///////////////////////////////////

    public Vector2 GetToPlayer()
    {
        Vector2 ToPlayer = (Player.Position - Position).Normalized();
        return ToPlayer;
    }

    public Vector2 CalculateVelocity()
    {
        Vector2 Direction = GetToPlayer();
        Vector2 Velocity = Direction * speed;

        return Velocity;
    }

    public void update_health(int change)
    {
        health += change;
        knockback();

        if (health <= 0)
        {
            EmitSignal("ScoreUpdate", 50);
            QueueFree();
        }
    }

    public void knockback()
    {
        Vector2 Direction = -1 * GetToPlayer();
        Vector2 Velocity = Direction * KnockbackDistance;

        MoveAndSlide(Velocity);
    }


    ////////////////////////////////// Signals ////////////////////////////
    public void OnCooldownTimeout()
    {
        KinematicBody2D Blast = BLAST.Instance<KinematicBody2D>();

        Blast.Set("start_point", Position);
        Blast.Set("end_point", Player.Position);

        GetParent().AddChild(Blast);
    }
}
