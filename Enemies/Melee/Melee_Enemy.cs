using Godot;
using System;

public class Melee_Enemy : KinematicBody2D
{
    KinematicBody2D Player;
    Control HUD;
    float speed = 100;
    int max_health = 100;
    int health;
    int KnockbackDistance = 2000;
    bool stunned = false;

    [Signal]
    public delegate void ScoreUpdate(int score);

//////////////////////////////////////////// Main //////////////////////////////

    public override void _Ready()
    {
        health = max_health;

        Player = GetParent().GetNode<KinematicBody2D>("Player");
        HUD = GetParent().GetNode<Control>("CanvasLayer/HUD");

        Connect("ScoreUpdate", HUD, "_score_update");
    }
    public override void _Process(float delta)
    {
        Vector2 Velocity = CalculateVelocity();
        MoveAndSlide(Velocity);
    }

/////////////////////////////////////////// Functions //////////////////////////////////////////////
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

    public async void stun()
    {
        SetProcess(false);
        GetNode<Sprite>("Sprite").Modulate = new Color("f31919");
        stunned = true;

        await ToSignal(GetTree().CreateTimer(3), "timeout");

        SetProcess(true);
        GetNode<Sprite>("Sprite").Modulate = new Color("3af063");
        stunned = false;       
    }

    ////////////////////////////// Signals /////////////////////////////////////
    
    public void OnArea2DAreaEntered(Area2D Area)
    {
        stun();
    }

    public void OnArea2DBodyEntered(KinematicBody2D Body)
    {
        
    }

    public void OnCooldownTimeout()
    {
        AnimatedSprite AttackSprite = GetNode<AnimatedSprite>("AnimatedSprite");
        AttackSprite.Position = GetToPlayer() * 25;
        AttackSprite.LookAt(Player.Position);

        GetNode<AnimationPlayer>("Anim").Play("Melee");
    }

}
