using Godot;
using System;

public class Main : Node2D
{
    static PackedScene ENEMY = GD.Load<PackedScene>("res://Enemies/Basic/Enemy.tscn");
    static PackedScene MELEEENEMY = GD.Load<PackedScene>("res://Enemies/Melee/Melee_Enemy.tscn");

    Godot.Collections.Array<PackedScene> Enemies = new Godot.Collections.Array<PackedScene>(ENEMY, MELEEENEMY);

    public override void _Ready()
    {
        
    }


    public void OnTimerTimeout()
    {
        SpawnEnemy();
    }

    public void SpawnEnemy()
    {
        Enemies.Shuffle();
        PackedScene Enemy = Enemies[0];
        KinematicBody2D Enemy_instance = Enemy.Instance<KinematicBody2D>();

        AddChild(Enemy_instance);
    }

}
