using Godot;
using System;

public class HUD : Control
{
    int score = 0;

    public void _score_update(int change)
    {
        score += change;
        GetNode<Label>("Score").Set("text", score.ToString());
    }

}
