using Godot;
using System;

public class Player : KinematicBody2D
{
    //////////////////////////////// Variables ////////////////////////////////
    float speed = 400;
    float DashSpeed = 50000;
    bool controller = false;
    Vector2 facing;
    PackedScene WIND;
    PackedScene ARROW;
    bool Dashing = false;
    Vector2 DashVelocity;
    float DashTime = 0.3f;

/////////////////////////////////////////////////// Built in Functions /////////////////////////////////////////////////
    public override void _Ready()
    {
        WIND = GD.Load<PackedScene>("res://Player/Wind/Wind.tscn");
        ARROW = GD.Load<PackedScene>("res://Player/Arrow/Arrow.tscn");
    }

    public override void _Process(float delta)
    {
        if (Dashing)
        {
            DashFrame(DashVelocity);
            return;
        }

        Vector2 velocity = calculate_velocity();
        MoveAndSlide(velocity);
    }

    public override void _Input(InputEvent @event)
    {
        BowController();

        if (Input.IsActionJustPressed("attack"))
        {
            sword_swing();
        }

        if (Input.IsActionJustPressed("special"))
        {
            special();
        }

        if (Input.IsActionJustPressed("dash") && !Dashing)
        {
            dash();
        }
    }

////////////////////////////////////////// My Functions //////////////////////////////////////////

    public void CheckController()
    {
        
    }

    public void BowController()
    {
        Vector2 BowPosition = (GetGlobalMousePosition() - Position).Normalized() * 100;
        Sprite BowSprite = GetNode<Sprite>("Bow");
        BowSprite.Position = BowPosition;
        BowSprite.Rotation = GetAngleTo(GetGlobalMousePosition()) + Mathf.Pi / 2;

        if (Input.IsActionPressed("attack"))
        {
            if (BowSprite.Frame == 0)
            {
                GetNode<AnimationPlayer>("Bow/Bow Anim").Play("Charge");
            }
        }
        
        if (Input.IsActionJustReleased("attack"))
        {
            GetNode<AnimationPlayer>("Bow/Bow Anim").Play("Reset");
            KinematicBody2D Arrow = ARROW.Instance<KinematicBody2D>();
            Arrow.Set("start_point", BowSprite.GlobalPosition);
            Arrow.Set("end_point", GetGlobalMousePosition());
            GetParent().AddChild(Arrow);
        }

    }

    public Vector2 get_direction()
    {
        Vector2 direction = new Vector2(
            Input.GetActionStrength("right") - Input.GetActionStrength("left"),
            Input.GetActionStrength("down") - Input.GetActionStrength("up")
        ).Normalized();

        return direction;
    }

    public Vector2 calculate_velocity()
    {
        Vector2 direction = get_direction();
        Vector2 velocity = direction * speed;

        return velocity;
    }

    public void sword_swing()
    {
        Sprite sword = GetNode<Sprite>("Sword");
        AnimationPlayer sword_anim = GetNode<AnimationPlayer>("Sword/Sword Anim");

        sword.Position = (GetGlobalMousePosition() - Position).Normalized() * 30;
        sword.LookAt(GetGlobalMousePosition());
        sword_anim.Play("Sword Anim");
    }

    public void special()
        {
            bool criteria_met = false;
            Area2D stunned_attack = GetNode<Area2D>("Stunned Attack");
            AnimationPlayer spear_anim = GetNode<AnimationPlayer>("Spear/Spear Anim");
            KinematicBody2D Target = null;
            

            foreach (KinematicBody2D body in stunned_attack.GetOverlappingBodies())
            {
                if (body.IsInGroup("Melee Enemies") && (bool)body.Get("stunned"))
                {
                    criteria_met = true;
                    Target = body;
                }
            }
            
            if (criteria_met)
            {
                Vector2 tpPosition = Target.Position;
                Target.Call("update_health", -100);
                Position = tpPosition;
                spear_anim.Play("Spear Anim");
            }
        }
    
    public async void dash()
    {
        Vector2 direction = get_direction();
        DashVelocity = direction * DashSpeed;
        
        Dashing = true;

        Vector2 pos1 = Position;

        GetNode<CollisionShape2D>("CollisionShape2D").Disabled = true;

        await ToSignal(GetTree().CreateTimer(DashTime), "timeout");

        GetNode<CollisionShape2D>("CollisionShape2D").Disabled = false;

        Vector2 pos2 = Position;

        MakeWind(pos1, pos2);

        Dashing = false;
    }

    public void MakeWind(Vector2 StartPoint, Vector2 EndPoint)
    {
        Sprite Wind = WIND.Instance<Sprite>();

        Wind.Set("start_point", StartPoint);
        Wind.Set("end_point", EndPoint);

        GetParent().AddChild(Wind);
    }

    public void DashFrame(Vector2 DashVelocity)
    {
        MoveAndSlide(DashVelocity * GetProcessDeltaTime());
    }

///////////////////////////////////////////// Signals //////////////////////////////////////////////////////

    public void OnSwordAreaBodyEntered(KinematicBody2D Body)
    {
        if (Body.HasMethod("update_health"))
        {
            Body.Call("update_health", -50);
        }
    }

    public void OnSwordAreaAreaEntered(Area2D Area)
    {
        if (Area.GetParent().HasMethod("reflect"))
        {
            Vector2 direction = (GetGlobalMousePosition() - Position).Normalized();
            Area.GetParent().Call("reflect", direction);
        }
    }

    public void OnSpearAreaBodyEntered(KinematicBody2D Body)
    {
        if (Body.HasMethod("update_health"))
        {
            Body.Call("update_health", -100);
        }
    }
    

}
