## Third Player Controller
### Structure
- Create new scene from **CharacterBody3D** and this structure
```
CharacterBody3D
|-> CollisionShape3D
|-> Node3D(Visuals)
|   |-> *3DModel(.glb)*
|   |-> AnimationPlayer
|
|-> Node3D(CameraMount)
|   |-> Camera3D
```

### Controller and View 
The code below is written to **Player.gd**.

```python
# will be defined above
@onready var camera_mount = $CameraMount
@onready var visuals = $Visuals

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
    # clicked any button in the game window
    # ui_canceled == esc
    if event is InputEventMouseButton:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    elif event.is_action_pressed("ui_cancel"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event):
    if event is InputEventMouseMotion:
        rotate_y(deg_to_rad(event.relative.x))
        visuals.rotate_y(deg_to_rad(event.relative.x * sense_horizontal))
        camera_mount.rotate_x(deg_to_rad(-event.relative.y * sense_vertical))
```

