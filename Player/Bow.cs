using Godot;
using System;

public class Bow : Sprite
{
    PackedScene ARROW;
    PackedScene ICE_ARROW;

    KinematicBody2D Player;
    AnimationPlayer BowAnim;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        ARROW = GD.Load<PackedScene>("res://Player/Arrow/Arrow.tscn");
        ICE_ARROW = GD.Load<PackedScene>("res://Player/Arrow/Ice Arrow.tscn");
        Player = GetParent<KinematicBody2D>();
        BowAnim = GetNode<AnimationPlayer>("Bow Anim");
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        if (Player.Get("CurrentWeapon") == this) {
            BowController();
        }
    }

    public void BowController()
        {
            Position = (GetGlobalMousePosition() - Player.Position).Normalized() * 100;
            Rotation = Player.GetAngleTo(GetGlobalMousePosition()) + Mathf.Pi / 2;

            switch (Player.Get("CurrentElement")) {
                case "Ice": 
                    IceBow();
                break;
                        
                case "Fire":
                    FireBow();
                break;

                case "Lightning":
                    LightningBow();
                break;
            }
        }

    
    private void FireBow() {
        if (Input.IsActionPressed("attack")) {
            if (Frame == 0) {
                BowAnim.Play("Charge");
            }
        }
        
        else if (Input.IsActionJustReleased("attack")) {

            BowAnim.Play("Reset");

            KinematicBody2D Arrow = ARROW.Instance<KinematicBody2D>();
            Arrow.Set("start_point", GlobalPosition);
            Arrow.Set("end_point", GetGlobalMousePosition());
            Arrow.Set("element", "Fire");
            GetTree().CurrentScene.AddChild(Arrow);
        }
    }

    private void IceBow() {
        if (Input.IsActionPressed("attack")) {
            if (Frame == 0) {
                BowAnim.Play("Ice Charge");
            }
        }
        
        else if (Input.IsActionJustReleased("attack")) {

            BowAnim.Play("Reset");

            KinematicBody2D Arrow = ICE_ARROW.Instance<KinematicBody2D>();
            Arrow.Set("start_point", GlobalPosition);
            Arrow.Set("end_point", GetGlobalMousePosition());
            Arrow.Set("element", "Ice");
            GetTree().CurrentScene.AddChild(Arrow);
        }
    }

    private void LightningBow() {
        if (Input.IsActionPressed("attack")) {
            BowAnim.Play("Reset");
            KinematicBody2D Arrow = ARROW.Instance<KinematicBody2D>();
            Arrow.Set("start_point", GlobalPosition);
            Arrow.Set("end_point", GetGlobalMousePosition());
            GetTree().CurrentScene.AddChild(Arrow);
        }
    }

    public void SwitchInto() {
      Show();
    }

    public void SwitchOut() {
        Hide();
    }
}
