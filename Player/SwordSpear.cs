using Godot;
using System;
using System.Diagnostics;

public class SwordSpear : Node2D
{
    KinematicBody2D Player;
    Sprite sword; 
    AnimationPlayer sword_anim; 
    Area2D stunned_attack;
    AnimationPlayer spear_anim; 
    CollisionShape2D Collision;

    public override void _Ready()
    {
        Player = GetParent<KinematicBody2D>();
        sword = GetNode<Sprite>("Sword");
        sword_anim = GetNode<AnimationPlayer>("Sword/Sword Anim");
        stunned_attack = GetNode<Area2D>("Stunned Attack");
        spear_anim = GetNode<AnimationPlayer>("Spear/Spear Anim");
        Collision = Player.GetNode<CollisionShape2D>("CollisionShape2D");   
    }

    public override void _Input(InputEvent @event) {
        if (Input.IsActionJustPressed("attack"))
        {
            if (Player.Get("CurrentWeapon") == this) {
                sword_swing();
            }
        }

        if (Input.IsActionJustPressed("special"))
        {
            Special();
        }
    }

    public void sword_swing()
    {
        sword.Position = (GetGlobalMousePosition() - Player.Position).Normalized() * 50;
        sword.LookAt(GetGlobalMousePosition());
        sword_anim.Play("Sword Anim");
    }
    
    public void Special()
    {
        (bool criteria_met, KinematicBody2D Target) = SpecialCheck();

        if (criteria_met)
        {
            Collision.Disabled = true;

            Vector2 tpPosition = Target.Position;
            Target.Call("UpdateHealth", -100);
            Player.Position = tpPosition;
            spear_anim.Play("Spear Anim");

            Collision.Disabled = false;
        }
    }

    private (bool, KinematicBody2D) SpecialCheck() {
        bool CriteriaMet = false;
        KinematicBody2D Target = null;

        foreach (KinematicBody2D body in GetTree().GetNodesInGroup("Melee Enemies"))
        {
            if ((bool)body.Get("stunned"))
            {
                CriteriaMet = true;
                Target = body;
            }
        }

        return (CriteriaMet, Target);
    }

    public void SwitchInto() {
    
    }

    public void SwitchOut() {

    }

}
