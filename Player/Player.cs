// Notes: 
// I use the word controller to refer to functions that manages a certain thing, I do have support for actual controllers so i refer to that in any context as joyinputs


using Godot;
using System;

public class Player : KinematicBody2D
{
	//////////////////////////////// Export Variables //////////////////////////
	[Export] float speed = 400;
	[Export] bool Dashing = false;

	//////////////////////////////// Variables ////////////////////////////////
	float DashSpeed = 5000;
	bool controller = false;
	Vector2 facing;
	PackedScene WIND;
	Vector2 DashVelocity;
	float DashTime = 0.1f;
	string CurrentWeapon = "Sword";
	string CurrentElement = "Fire";
	int MaxHealth = 100;
	int Health;

	Sprite Bow;
	Node2D Gauntlets;

/////////////////////////////////////////////////// Built in Functions /////////////////////////////////////////////////
	public override void _Ready()
	{
		Health = MaxHealth;
		WIND = GD.Load<PackedScene>("res://Player/Wind/Wind.tscn");

		Bow = GetNode<Sprite>("Bow");
		Gauntlets = GetNode<Node2D>("Gauntlets");
	}

	public override void _Process(float delta)
	{
		Vector2 velocity = Vector2.Zero;

		if (Dashing) {
			velocity = DashVelocity;
		} else {
			velocity = calculate_velocity();
		}

		MoveAndSlide(velocity);
	}
	
	public override void _Input(InputEvent @event)
	{
		if (Input.IsActionJustPressed("dash") && !Dashing)
		{
			dash();
		}

		if (Input.IsActionJustPressed("switch"))
		{
			if (CurrentWeapon == "Sword") {
				CurrentWeapon = "Bow";

				Bow.Call("SwitchInto");
			} else if (CurrentWeapon == "Bow") {
				CurrentWeapon = "Gauntlets";
				
				Bow.Call("SwitchOut");
				Gauntlets.Call("SwitchInto");
			} else {
				CurrentWeapon = "Sword";

				Gauntlets.Call("SwitchOut");
			}
		}

		if (Input.IsActionJustPressed("switch_element"))
		{
			if (CurrentElement == "Fire") {
				CurrentElement = "Lightning";
			} else if (CurrentElement == "Lightning") {
				CurrentElement = "Ice";
			} else {
				CurrentElement = "Fire";
			}
		}
	}

////////////////////////////////////////// My Functions //////////////////////////////////////////

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
	
	public void dash()
	{
		Vector2 direction = get_direction();
		DashVelocity = direction * DashSpeed;
		GetNode<AnimationPlayer>("AnimationPlayer").Play("Dash");
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

	public void UpdateHealth(int change) {
		Health += change;
		if (Health <= 0) {
			// GD.Print(GetParent().GetNode<Control>("CanvasLayer/HUD").Get("score"));
			// GetTree().ReloadCurrentScene();
		}
	}

///////////////////////////////////////////// Signals //////////////////////////////////////////////////////

	public void OnSwordAreaBodyEntered(KinematicBody2D Body)
	{
		if (Body.HasMethod("UpdateHealth"))
		{
			Body.Call("UpdateHealth", -50);
		}
	}

	public void OnSwordAreaAreaEntered(Area2D Area)
	{
		if (Area.GetParent().HasMethod("reflect"))
		{
			Vector2 direction = (GetGlobalMousePosition() - Position).Normalized();
			Area.GetParent().Call("reflect", direction);
		} else if (Area.GetParent().GetParent().HasMethod("Stun")) {
			Area.GetParent().GetParent().Call("Stun");
		}
	}

	public void OnSpearAreaBodyEntered(KinematicBody2D Body)
	{
		if (Body.HasMethod("UpdateHealth"))
		{
			Body.Call("UpdateHealth", -100);
		}
	}

	public void OnGauntletAreaBodyEntered(KinematicBody2D Body)
	{
		if (Body.HasMethod("UpdateHealth"))
		{
			Body.Call("UpdateHealth", -20);
		}
	}

	public void OnIceFieldBodyEntered(KinematicBody2D Body)
	{
		Body.Set("speed", (float)Body.Get("speed") / 2);
	}
}
