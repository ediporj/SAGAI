extends Control

const MAP_W = 720.0
const MAP_H = 1280.0

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_criar_ui()

func _criar_ui() -> void:
	# Background
	var bg = ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.04, 0.04, 0.08)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Thin accent bar at top
	var top_bar = ColorRect.new()
	top_bar.color = Color(0.35, 0.15, 0.65, 0.6)
	top_bar.size = Vector2(MAP_W, 5)
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(top_bar)

	# Center container
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 18)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(vbox)

	# Robot emoji
	var em = Label.new()
	em.text = "🤖"
	em.add_theme_font_size_override("font_size", 90)
	em.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(em)

	# Title
	var title = Label.new()
	title.text = "SAGAI"
	title.add_theme_font_size_override("font_size", 68)
	title.add_theme_color_override("font_color", Color.WHITE)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# Tagline
	var sub = Label.new()
	sub.text = "Da espelunca ao topo\ncom inteligência artificial."
	sub.add_theme_font_size_override("font_size", 16)
	sub.add_theme_color_override("font_color", Color(0.55, 0.55, 0.72))
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(sub)

	# Spacer
	var sp = Control.new()
	sp.custom_minimum_size = Vector2(0, 52)
	vbox.add_child(sp)

	# Start button
	var btn_start = Button.new()
	btn_start.text = "▶   Nova Jornada"
	btn_start.custom_minimum_size = Vector2(300, 66)
	btn_start.add_theme_font_size_override("font_size", 20)
	btn_start.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn_start.pressed.connect(_on_nova_jornada)
	vbox.add_child(btn_start)

	# Load button (disabled)
	var btn_load = Button.new()
	btn_load.text = "📂   Continuar"
	btn_load.custom_minimum_size = Vector2(300, 54)
	btn_load.add_theme_font_size_override("font_size", 17)
	btn_load.disabled = true
	btn_load.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(btn_load)

	# Version
	var ver = Label.new()
	ver.text = "v0.1 · demo"
	ver.add_theme_font_size_override("font_size", 12)
	ver.add_theme_color_override("font_color", Color(0.28, 0.28, 0.38))
	ver.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(ver)

func _on_nova_jornada() -> void:
	var StoryPanelScript = load("res://scripts/StoryPanel.gd")
	var panel = StoryPanelScript.new()
	add_child(panel)
	panel.iniciar(_intro_slides())
	panel.fechou.connect(_on_intro_fechou, CONNECT_ONE_SHOT)

func _on_intro_fechou() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _intro_slides() -> Array:
	return [
		{
			"emoji": "🏠",
			"titulo": "18 anos. Uma mochila.",
			"texto": "R$ 3.000 guardados a duras penas. Você saiu de casa decidido a provar que consegue — sem diploma, sem padrinho, sem rede de apoio.",
			"cor": Color(0.18, 0.06, 0.28),
		},
		{
			"emoji": "🤖",
			"titulo": "A IA está mudando tudo.",
			"texto": "Quem aprende a usar vai na frente. Quem ignora fica pra trás. O mercado não espera. As oportunidades estão aí — só para quem está pronto.",
			"cor": Color(0.05, 0.10, 0.28),
		},
		{
			"emoji": "🏚️",
			"titulo": "A espelunca não é bonita.",
			"texto": "O bairro é duro. O aluguel pesa. E o corpo cobra quando você esquece de comer ou dormir. Cuide de si mesmo enquanto cresce.",
			"cor": Color(0.22, 0.07, 0.05),
		},
		{
			"emoji": "🎯",
			"titulo": "Três caminhos. Um destino.",
			"texto": "Riqueza. Fama. Impacto. Você decide onde quer chegar. Mas lembre: o tempo passa, o aluguel vence e cada escolha importa.\n\nBoa sorte.",
			"cor": Color(0.05, 0.18, 0.10),
		},
	]
