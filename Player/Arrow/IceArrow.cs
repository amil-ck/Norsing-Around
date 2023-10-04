using Godot;
using System;

public class IceArrow : KinematicBody2D
{
    /////////////////////////////////////// Variables ////////////////////////////////////
    Vector2 start_point;
    Vector2 end_point;
    Vector2 direction;
    float speed = 2000;
    Vector2 velocity;
    int PierceCount = 3;
    PackedScene Fire;

    //////////////////////////////////////// Main /////////////////////////////////////////

    public override void _Ready()
    {
        direction = (end_point - start_point).Normalized();
        velocity = direction * speed;

        Position = start_point;
        
        Rotation = GetAngleTo(end_point) + Mathf.Pi / 2;

        GetNode<AnimatedSprite>("AnimatedSprite").Play();
    }

    public override void _Process(float delta)
    {
        MoveAndSlide(velocity);

        if (Position.DistanceTo(GetParent<Node2D>().Position) > 5000) {
            QueueFree();
        }
    }

    //////////////////////////////////////////// Signals ////////////////////////////////////////////////

    public void OnArea2DBodyEntered(KinematicBody2D Body)
    {
        if (Body.HasMethod("UpdateHealth"))
        {
            Body.Call("UpdateHealth", -50);
            PierceCount--;
            if (PierceCount == 0)
            {
                QueueFree();
            }
        }
    }
}
