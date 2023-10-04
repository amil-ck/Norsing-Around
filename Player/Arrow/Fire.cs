using Godot;
using System;

public class Fire : Light2D
{
    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        Energy -= delta * 3;
        if (Energy <= 0) {
            QueueFree();
        }
    }
}
