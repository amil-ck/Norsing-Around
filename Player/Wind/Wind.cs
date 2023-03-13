using Godot;
using System;

public class Wind : Sprite
{
    Vector2 start_point;
    Vector2 end_point;

    float FadeSpeed = 0.7f;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        Position = (start_point + end_point) / 2;
        Rotation = start_point.AngleToPoint(end_point);
    }

    public override void _Process(float delta)
    {
        float NewA = Modulate.a - FadeSpeed * delta;

        if (NewA <= 0)
        {
            QueueFree();
        }
        else
        {
            Modulate = Modulate with {a = NewA};
        }
    }
}
