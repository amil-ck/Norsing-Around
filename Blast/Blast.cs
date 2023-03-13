using Godot;
using System;

public class Blast : KinematicBody2D
{
    /////////////////////////////////////// Variables ////////////////////////////////////
    Vector2 start_point;
    Vector2 end_point;
    Vector2 direction;
    float speed = 500;
    Vector2 velocity;

    //////////////////////////////////////// Main /////////////////////////////////////////

    public override void _Ready()
    {
        direction = (end_point - start_point).Normalized();
        velocity = direction * speed;

        Position = start_point;
    }

    public override void _Process(float delta)
    {
        MoveAndSlide(velocity);
    }

    //////////////////////////////////////////// Functions /////////////////////////////////////////////////

    public void reflect(Vector2 new_direction)
    {
        direction = new_direction;
        velocity = new_direction * speed;

        Area2D Area = GetNode<Area2D>("Area2D");
        Area.CollisionLayer = 4;
        Area.CollisionMask = 2;
    }

    ///////////////////////////// Signals /////////////////////////////////////////

    public void OnArea2DBodyEntered(KinematicBody2D Body)
    {
        if (Body.HasMethod("update_health"))
        {
            Body.Call("update_health", -50);
        }
    }
}
