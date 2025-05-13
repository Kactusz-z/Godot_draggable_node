# ==========================================================
# RadiusPanelContainer
# 类型：自定义容器
# 概述：现代化UI系列，实现基础的圆角面板元素
# 巽星石
# 创建时间2025年1月3日13:45:32
# 最后修改时间：2025年1月3日17:54:39
# ==========================================================
@tool
class_name  Testnodetest extends Container

# =============================== 参数 ===============================

#@export var padding:=10: ## 内边距
	#set(val):
		#padding = val
		#queue_redraw()
#
#@export_range(0.0,1.0,0.1) var opacity=1.0: ## 透明度
	#set(val):
		#opacity = val
		#if val:
			#self_modulate = Color(1.0,1.0,1.0,val)
		#queue_redraw()
#
#@export_group("background")
#@export var bg_color:=Color.WHITE: ## 背景颜色
	#set(val):
		#bg_color = val
		#queue_redraw()
#
#@export var bg_texture:Texture2D: ## 背景图片
	#set(val):
		#bg_texture = val
		#queue_redraw()
#
#@export_group("border")
#@export var border_color:=Color.WHITE: ## 边框颜色
	#set(val):
		#border_color = val
		#queue_redraw()
#
#
#@export var border_radius:=5: ## 圆角半径
	#set(val):
		#border_radius = val
		#queue_redraw()
#
#
#@export var border_width:=0:## 边线宽度
	#set(val):
		#border_width = val
		#queue_redraw()
#
#
## =============================== 虚函数 ===============================
#func _init() -> void:
	#clip_contents = true
#
#func _draw() -> void:
	#var rect = get_rect() * get_transform()
	#var pots = round_rect(rect,border_radius,border_width/2.0)
	## 绘制背景
	#if bg_texture:
		#var uvs:PackedVector2Array
		#for pot in pots: # 计算UV坐标
			#uvs.append(pot/rect.size)
		## 绘制圆角矩形
		#draw_colored_polygon(pots,bg_color,uvs,bg_texture)
	#else:
		#draw_polygon(pots,[bg_color])
	## 绘制边线
	#draw_polyline(pots,border_color,border_width)
	## 重排子元素
	#queue_sort()
#
#func _notification(what: int) -> void:
	#var rect = get_rect() * get_transform()
	#rect.position += Vector2.ONE * padding
	#rect.size -= Vector2.ONE * padding * 2
	#match what:
		#NOTIFICATION_SORT_CHILDREN:
			#if get_child_count()>0:
				#fit_child_in_rect(get_children()[0],rect)
#
## =============================== 自定义函数 ===============================
## 求圆弧点集
#func arc(c:Vector2,r:float,start_angle:float,end_angle:float,steps:=10) -> PackedVector2Array:
	#var arr:PackedVector2Array
	#var v1 = Vector2.RIGHT * r
	#var ang = deg_to_rad(end_angle - start_angle)/float(steps)
	#for i in range(steps+1):
		#arr.append(v1.rotated(ang * float(i) + deg_to_rad(start_angle)) + c)
	#return arr
#
## 获取圆角矩形
#func round_rect(rect:Rect2,r:float,offset:float) -> PackedVector2Array:
	#var arr:PackedVector2Array
	#var pots:PackedVector2Array = get_rect2_points(rect) # 矩形顶点
	#var vec = Vector2.ONE * (r + offset)  # 圆角偏移向量
	#arr.append_array(arc(pots[0] + vec,r,180,270))
	#arr.append_array(arc(pots[1] + Transform2D.FLIP_X * vec,r,270,360))
	#arr.append_array(arc(pots[2] + vec * -1,r,0,90))
	#arr.append_array(arc(pots[3] + Transform2D.FLIP_Y * vec,r,90,180))
	#arr.append(pots[0] + vec - Vector2(r,0))
	#return arr
#
## 获取Rect对应的点集合
#func get_rect2_points(rect:Rect2) -> PackedVector2Array:
	#var arr:PackedVector2Array
	#var pos = rect.position
	#var end = rect.end
	#var w = rect.size.x
	#arr.append(pos)
	#arr.append(pos + Vector2.RIGHT * w)
	#arr.append(end)
	#arr.append(end - Vector2.RIGHT * w)
	#return arr
