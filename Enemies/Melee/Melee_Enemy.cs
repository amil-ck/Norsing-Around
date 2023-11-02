using Godot;
using System;

public class Melee_Enemy : KinematicBody2D
{
    KinematicBody2D Player;
    Control HUD;
    float speed = 300;
    int max_health = 100;
    int health;
    int KnockbackDistance = 2000;
    bool stunned = false;
    Timer VarTim;

    [Signal]
    public delegate void ScoreUpdate(int score);

    [Signal]
    public delegate void StunnedPointer(bool add, Vector2 direction);

//////////////////////////////////////////// Main //////////////////////////////

    public override void _Ready()
    {
        health = max_health;

        VarTim = GetNode<Timer>("VarTim");

        Player = GetParent().GetNode<KinematicBody2D>("Player");
        HUD = GetParent().GetNode<Control>("CanvasLayer/HUD");

        Connect("ScoreUpdate", HUD, "_score_update");
    }
    public override void _Process(float delta)
    {
        if (!stunned)
        {
            Vector2 Velocity = CalculateVelocity();
            if (Velocity.x < 0) {
                GetNode<Sprite>("Sprite").SetFlipH(false);
            } else if (Velocity.x > 0) {
                GetNode<Sprite>("Sprite").SetFlipH(true);
            }

            MoveAndSlide(Velocity);
        }
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

    public void UpdateHealth(int change)
    {
        health += change;
        Knockback();

        if (health <= 0)
        {
            EmitSignal("ScoreUpdate", 50);
            QueueFree();
        }
    }

    public void Knockback()
    {
        Vector2 Direction = -1 * GetToPlayer();
        Vector2 Velocity = Direction * KnockbackDistance;

        MoveAndSlide(Velocity);
    }

    public async void Stun()
    {
        GetNode<Sprite>("Sprite").Modulate = new Color("f31919");
        stunned = true;

        VarTim.Start(3); await ToSignal(VarTim, "timeout");

        GetNode<Sprite>("Sprite").Modulate = new Color("3af063");
        stunned = false;       
    }

    ////////////////////////////// Signals /////////////////////////////////////

    public void OnArea2DBodyEntered(KinematicBody2D Body)
    {
        if (Body.HasMethod("UpdateHealth")) {
            Body.Call("UpdateHealth", -50);
        }
    }

    public void OnCooldownTimeout()
    {
        AnimatedSprite AttackSprite = GetNode<AnimatedSprite>("AnimatedSprite");
        AttackSprite.Position = GetToPlayer() * 25;
        AttackSprite.LookAt(Player.Position);

        GetNode<AnimationPlayer>("Anim").Play("Melee");
    }

}
