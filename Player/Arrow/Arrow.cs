using Godot;
using System;

public class Arrow : KinematicBody2D
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

        Rotation = GetAngleTo(end_point) + Mathf.Pi / 2;
    }

    public override void _Process(float delta)
    {
        MoveAndSlide(velocity);
    }
}
