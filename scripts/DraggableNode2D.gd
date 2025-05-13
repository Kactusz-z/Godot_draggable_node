## DraggableNode2D
@tool
class_name  DraggableNode2D extends Node2D

## 需要一个 Area2d 子结点

@export var drag_area_path: NodePath

var drag_area: Area2D

var dragging: bool = false  # 标志是否正在拖拽
var mouse_entered_select_area: bool = false

var drag_offset = Vector2.ZERO # 拖拽偏移量

func _ready() -> void:
	if not drag_area_path:
		printerr("The drag_area_path cannot be found")
	else:
		drag_area = get_node(drag_area_path)
		drag_area.mouse_entered.connect(_mouse_enter_select_area)
		drag_area.mouse_exited.connect(_mouse_exited_select_area)
		
		drag_area.input_pickable = true # 确保 Area2D 可以接收输入事件
	

func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() + drag_offset # 设置节点位置为： 全局鼠标位置 + 拖拽偏移量

func _unhandled_input(event):
#func _input(event):
	if event is InputEventMouseButton: # 检查事件是否是鼠标按钮事件
		if event.button_index == MOUSE_BUTTON_LEFT: # 检查是否是鼠标左键
			if event.pressed : # 鼠标按下 且 点击位置在 Area2D 区域内
				if mouse_entered_select_area :
					dragging = true # 开始拖拽
					drag_offset = position - event.position # 计算拖拽偏移量 (节点位置 - 鼠标点击位置)
			else:
				if dragging:
					dragging = false # 停止拖拽

func _mouse_enter_select_area() -> void:
	print("mouse enter")
	mouse_entered_select_area = true

func _mouse_exited_select_area() -> void:
	print("mouse exited")
	mouse_entered_select_area = false
