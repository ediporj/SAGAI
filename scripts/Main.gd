extends Control

# === CONSTANTS ===
const MAP_W          = 720.0
const MAP_H          = 1280.0
const STATUS_H       = 120.0
const PANEL_CLOSED_H = 54.0
const PANEL_OPEN_H   = 420.0
const JOY_SIZE       = 144.0
const JOY_MARGIN     = 20.0
const DETECT_RADIUS  = 0.068  # normalized map units

# Transport speeds in px/sec
const SPEEDS = {0: 150.0, 1: 210.0, 2: 280.0, 3: 360.0, 4: 440.0, 5: 540.0}

# Icon atlas: 1024x1536, 2 cols x 4 rows → each cell 512x384
const ICON_W = 512.0
const ICON_H = 384.0

# Locations: pos is normalized (0-1) top-left origin on map
const LOCATIONS: Dictionary = {
	# ── BAIRRO POPULAR (region 0) ──────────────────────────────
	"espelunca":  {"nome":"Espelunca",       "emoji":"🏠", "icon":Vector2i(0,0), "pos":Vector2(0.48,0.92), "regiao":0, "tipo":"estudo"},
	"boteco":     {"nome":"Boteco",          "emoji":"🍺", "icon":Vector2i(1,0), "pos":Vector2(0.30,0.80), "regiao":0, "tipo":"lazer"},
	"rua":        {"nome":"Rua",             "emoji":"📦", "icon":Vector2i(1,3), "pos":Vector2(0.68,0.82), "regiao":0, "tipo":"trabalho"},
	"mercadinho": {"nome":"Mercadinho",      "emoji":"🛒",                       "pos":Vector2(0.50,0.75), "regiao":0, "tipo":"loja"},
	# ── CENTRO COMERCIAL (region 1) ────────────────────────────
	"biblioteca": {"nome":"Biblioteca",      "emoji":"💡", "icon":Vector2i(1,1), "pos":Vector2(0.25,0.62), "regiao":1, "tipo":"estudo"},
	"cafe_wifi":  {"nome":"Café WiFi",       "emoji":"☕", "icon":Vector2i(0,3), "pos":Vector2(0.65,0.60), "regiao":1, "tipo":"trabalho"},
	"mall":       {"nome":"Shopping Center", "emoji":"🏬",                       "pos":Vector2(0.48,0.67), "regiao":1, "tipo":"loja"},
	"parque":     {"nome":"Parque",          "emoji":"🌳",                       "pos":Vector2(0.80,0.68), "regiao":1, "tipo":"lazer"},
	# ── DISTRITO EMPRESARIAL (region 2) ────────────────────────
	"coworking":        {"nome":"Co-working",    "emoji":"💼", "icon":Vector2i(1,2), "pos":Vector2(0.38,0.44), "regiao":2, "tipo":"trabalho"},
	"loja_eletronicos": {"nome":"Eletrônicos",   "emoji":"🖥️",                       "pos":Vector2(0.72,0.42), "regiao":2, "tipo":"loja"},
	"restaurante":      {"nome":"Restaurante",   "emoji":"🍴",                       "pos":Vector2(0.15,0.40), "regiao":2, "tipo":"lazer"},
	# ── HUB TECNOLÓGICO (region 3) ─────────────────────────────
	"startup":    {"nome":"Startup Hub",     "emoji":"🚀", "icon":Vector2i(0,1), "pos":Vector2(0.63,0.28), "regiao":3, "tipo":"trabalho"},
	"tech_store": {"nome":"Tech Store",      "emoji":"⚡",                       "pos":Vector2(0.18,0.28), "regiao":3, "tipo":"loja"},
	"bar_hub":    {"nome":"Bar do Hub",      "emoji":"🍻",                       "pos":Vector2(0.82,0.33), "regiao":3, "tipo":"lazer"},
	# ── ÁREA NOBRE (region 4) ──────────────────────────────────
	"hospital":  {"nome":"Hospital",         "emoji":"🏥", "icon":Vector2i(0,2), "pos":Vector2(0.28,0.12), "regiao":4, "tipo":"saude"},
	"instituto": {"nome":"Instituto IA",     "emoji":"🔬",                       "pos":Vector2(0.55,0.07), "regiao":4, "tipo":"estudo"},
	"galeria":   {"nome":"Galeria Premium",  "emoji":"🛍️",                       "pos":Vector2(0.78,0.16), "regiao":4, "tipo":"loja"},
	"clube":     {"nome":"Clube Social",     "emoji":"🎭",                       "pos":Vector2(0.10,0.04), "regiao":4, "tipo":"lazer"},
}

# Regions from top to bottom (normalized y boundaries)
const REGIONS = [
	{"nome": "Área Nobre",           "top": 0.00, "bot": 0.22, "unlock_level": 4},
	{"nome": "Hub Tecnológico",      "top": 0.22, "bot": 0.37, "unlock_level": 3},
	{"nome": "Distrito Empresarial", "top": 0.37, "bot": 0.53, "unlock_level": 2},
	{"nome": "Centro Comercial",     "top": 0.53, "bot": 0.72, "unlock_level": 1},
	{"nome": "Bairro Popular",       "top": 0.72, "bot": 1.00, "unlock_level": 0},
]

const TIER_NAMES = ["Leigo", "Iniciante", "Aprendiz", "Avançado", "Expert", "Mestre"]

const SKILL_TIERS = {
	"criativo": {
		"emoji": "🎨", "nome": "Criativo", "var": "habilidade_criativo",
		"cor": Color(0.95, 0.65, 0.25),
		"tiers": [
			{"pts": 0,   "nome": "Leigo",    "desc": "Estudar pelo celular · Explorar a cidade"},
			{"pts": 20,  "nome": "Iniciante", "desc": "Curso Design (espelunca) · Thumbnails (café)"},
			{"pts": 40,  "nome": "Aprendiz",  "desc": "Vídeos Curtos (café) · Pitch Criativo"},
			{"pts": 60,  "nome": "Avançado",  "desc": "Conteúdo Viral · Hackathon (startup)"},
			{"pts": 80,  "nome": "Expert",    "desc": "Direção Criativa · Projetos de Alto Impacto"},
			{"pts": 100, "nome": "Mestre",    "desc": "Tudo desbloqueado"},
		]
	},
	"tecnico": {
		"emoji": "💻", "nome": "Técnico", "var": "habilidade_tecnico",
		"cor": Color(0.35, 0.80, 1.0),
		"tiers": [
			{"pts": 0,   "nome": "Leigo",    "desc": "Estudar pelo celular"},
			{"pts": 20,  "nome": "Iniciante", "desc": "Automação no PC (espelunca) · Curso Prog. (bib.)"},
			{"pts": 40,  "nome": "Aprendiz",  "desc": "Pesquisa e Desenvolvimento (coworking)"},
			{"pts": 60,  "nome": "Avançado",  "desc": "Produtos Escaláveis · Hackathon (startup)"},
			{"pts": 80,  "nome": "Expert",    "desc": "Arquitetura de Sistemas · MVP Próprio"},
			{"pts": 100, "nome": "Mestre",    "desc": "Tudo desbloqueado"},
		]
	},
	"comercial": {
		"emoji": "💼", "nome": "Comercial", "var": "habilidade_comercial",
		"cor": Color(0.45, 1.0, 0.55),
		"tiers": [
			{"pts": 0,   "nome": "Leigo",    "desc": "Procurar Emprego"},
			{"pts": 20,  "nome": "Iniciante", "desc": "Networking (rua) · Curso Marketing (bib.)"},
			{"pts": 40,  "nome": "Aprendiz",  "desc": "Prospectar Clientes (café) · Pitch (coworking)"},
			{"pts": 60,  "nome": "Avançado",  "desc": "Buscar Investidor (startup)"},
			{"pts": 80,  "nome": "Expert",    "desc": "Parcerias Corporativas · Contratos grandes"},
			{"pts": 100, "nome": "Mestre",    "desc": "Tudo desbloqueado"},
		]
	},
}

# === UI REFERENCES ===
var player_node: TextureRect
var location_nodes: Dictionary = {}
var region_overlays: Array[Control] = []
var joystick: Control
var icon_atlas: Texture2D

var label_dia: Label
var label_dinheiro: Label
var nivel_label: Label
var status_bars: Dictionary = {}
var skill_bars: Dictionary = {}
var skill_tier_labels: Dictionary = {}
var label_tarefas: Label

var skills_panel: Control
var skills_content: VBoxContainer

var contatos_panel: Control
var contatos_content: VBoxContainer

var task_panel: PanelContainer
var task_location_label: Label
var task_container: VBoxContainer
var progress_bar: ProgressBar
var label_progress: Label
var botao_proximo_dia: Button
var label_sem_local: Label

# === GAME STATE ===
var player_pos: Vector2 = Vector2(0.48, 0.86)
var player_direction: Vector2 = Vector2.ZERO
var active_location_id: String = ""
var tarefa_em_curso: bool = false
var tween_progress: Tween
var panel_tween: Tween
var estado_especial: String = ""
var locked_near_id: String = ""

# ============================================================
func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	icon_atlas = load("res://assets/icones_em_grade.png")
	_criar_mapa()
	_criar_overlays_regiao()
	_criar_marcadores_locais()
	_criar_player()
	_criar_joystick()
	_criar_status_overlay()
	_criar_task_panel()
	_criar_skills_panel()
	_criar_contatos_panel()
	_conectar_sinais()
	_atualizar_ui()
	_atualizar_posicao_player()
	_verificar_desbloqueios()

# ============================================================
func _criar_mapa() -> void:
	var map_tex = TextureRect.new()
	map_tex.texture = load("res://assets/Mapa_cidade.png")
	map_tex.stretch_mode = TextureRect.STRETCH_SCALE
	map_tex.set_anchors_preset(Control.PRESET_FULL_RECT)
	map_tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(map_tex)

func _criar_overlays_regiao() -> void:
	for i in REGIONS.size():
		var r = REGIONS[i]
		if r["unlock_level"] == 0:
			continue
		var overlay = ColorRect.new()
		overlay.color = Color(0.0, 0.0, 0.0, 0.72)
		overlay.position = Vector2(0, r["top"] * MAP_H)
		overlay.size = Vector2(MAP_W, (r["bot"] - r["top"]) * MAP_H)
		overlay.name = "Overlay_" + str(i)
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(overlay)
		region_overlays.append(overlay)

		var lbl_lock = Label.new()
		lbl_lock.text = "🔒  %s\n    Nível %d" % [r["nome"], r["unlock_level"]]
		lbl_lock.add_theme_font_size_override("font_size", 18)
		lbl_lock.add_theme_color_override("font_color", Color(0.8, 0.8, 0.9, 0.85))
		lbl_lock.set_anchors_preset(Control.PRESET_CENTER)
		lbl_lock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl_lock.mouse_filter = Control.MOUSE_FILTER_IGNORE
		overlay.add_child(lbl_lock)

func _criar_marcadores_locais() -> void:
	for loc_id in LOCATIONS:
		var loc = LOCATIONS[loc_id]
		var marker = _criar_marcador(loc)
		marker.position = _loc_to_screen(loc["pos"]) - Vector2(28, 28)
		add_child(marker)
		location_nodes[loc_id] = marker

func _criar_marcador(loc: Dictionary) -> Control:
	var container = Control.new()
	container.size = Vector2(52, 52)
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var bg = Panel.new()
	bg.position = Vector2(0, 0)
	bg.size = Vector2(52, 52)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0.92)
	style.set_corner_radius_all(8)
	style.set_border_width_all(2)
	style.border_color = Color(0.3, 0.3, 0.4, 0.8)
	bg.add_theme_stylebox_override("panel", style)
	container.add_child(bg)

	if loc.has("icon"):
		var icon_ctrl = TextureRect.new()
		icon_ctrl.texture = _get_icon_texture(loc["icon"])
		icon_ctrl.stretch_mode = TextureRect.STRETCH_SCALE
		icon_ctrl.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_ctrl.position = Vector2(4, 4)
		icon_ctrl.size = Vector2(44, 44)
		icon_ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		container.add_child(icon_ctrl)
	else:
		var emoji_lbl = Label.new()
		emoji_lbl.text = loc["emoji"]
		emoji_lbl.add_theme_font_size_override("font_size", 26)
		emoji_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
		emoji_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		emoji_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		emoji_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		container.add_child(emoji_lbl)

	return container

func _get_icon_texture(cell: Vector2i) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = icon_atlas
	atlas.region = Rect2(cell.x * ICON_W, cell.y * ICON_H, ICON_W, ICON_H)
	return atlas

func _criar_player() -> void:
	player_node = TextureRect.new()
	player_node.texture = load("res://assets/personagem.png")
	player_node.stretch_mode = TextureRect.STRETCH_SCALE
	player_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	player_node.size = Vector2(52, 78)
	player_node.z_index = 15
	player_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(player_node)

func _criar_joystick() -> void:
	var joy_script = load("res://scripts/Joystick.gd")
	joystick = Control.new()
	joystick.set_script(joy_script)
	joystick.position = Vector2(JOY_MARGIN, MAP_H - JOY_SIZE - JOY_MARGIN - PANEL_CLOSED_H)
	joystick.custom_minimum_size = Vector2(JOY_SIZE, JOY_SIZE)
	joystick.z_index = 20
	add_child(joystick)
	joystick.direction_changed.connect(_on_joystick_direction)

func _criar_status_overlay() -> void:
	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_TOP_WIDE)
	panel.custom_minimum_size = Vector2(0, STATUS_H)
	panel.z_index = 30
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.1, 0.82)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	margin.add_child(vbox)

	# Linha 1: dia + dinheiro
	var row1 = HBoxContainer.new()
	vbox.add_child(row1)
	label_dia = _lbl("Dia 1  |  18 anos", 15, Color.WHITE)
	row1.add_child(label_dia)
	var sp1 = Control.new()
	sp1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row1.add_child(sp1)
	nivel_label = _lbl("IA Nv.0", 15, Color(0.6, 0.6, 0.75))
	row1.add_child(nivel_label)
	var sp2 = Control.new()
	sp2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row1.add_child(sp2)
	label_dinheiro = _lbl("R$ 3.000", 15, Color(0.3, 0.9, 0.45))
	row1.add_child(label_dinheiro)

	# Linha 2: barras de status
	var row2 = HBoxContainer.new()
	row2.add_theme_constant_override("separation", 10)
	vbox.add_child(row2)

	var bars_cfg = [
		["humor",   "😄", Color(1.0, 0.85, 0.2)],
		["saude",   "❤️", Color(0.9, 0.3, 0.35)],
		["riqueza", "💰", Color(0.3, 0.9, 0.45)],
		["fama",    "🌟", Color(0.65, 0.4, 1.0)],
		["impacto", "🌍", Color(0.3, 0.7, 1.0)],
	]
	for cfg in bars_cfg:
		var col = VBoxContainer.new()
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row2.add_child(col)
		col.add_child(_lbl(cfg[1], 11, Color(0.85, 0.85, 0.9)))
		var bar = ProgressBar.new()
		bar.min_value = 0.0
		bar.max_value = 100.0
		bar.value = 60.0
		bar.show_percentage = false
		bar.custom_minimum_size = Vector2(0, 10)
		var fill = StyleBoxFlat.new()
		fill.bg_color = cfg[2]
		fill.set_corner_radius_all(3)
		bar.add_theme_stylebox_override("fill", fill)
		var bg = StyleBoxFlat.new()
		bg.bg_color = Color(0.2, 0.2, 0.28)
		bg.set_corner_radius_all(3)
		bar.add_theme_stylebox_override("background", bg)
		col.add_child(bar)
		status_bars[cfg[0]] = bar

	# Linha 3: habilidades de IA
	var row3 = HBoxContainer.new()
	row3.add_theme_constant_override("separation", 10)
	vbox.add_child(row3)

	var skills_cfg = [
		["habilidade_criativo",  "🎨 Criativo",  Color(0.95, 0.65, 0.25)],
		["habilidade_tecnico",   "💻 Técnico",   Color(0.35, 0.80, 1.0)],
		["habilidade_comercial", "💼 Comercial", Color(0.45, 1.0, 0.55)],
	]
	for sc in skills_cfg:
		var scol = VBoxContainer.new()
		scol.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row3.add_child(scol)
		var tier_lbl = _lbl(sc[1], 10, Color(0.70, 0.70, 0.82))
		scol.add_child(tier_lbl)
		skill_tier_labels[sc[0]] = tier_lbl
		var sbar = ProgressBar.new()
		sbar.min_value = 0.0
		sbar.max_value = 100.0
		sbar.value = 0.0
		sbar.show_percentage = false
		sbar.custom_minimum_size = Vector2(0, 8)
		var sf = StyleBoxFlat.new()
		sf.bg_color = sc[2]
		sf.set_corner_radius_all(2)
		sbar.add_theme_stylebox_override("fill", sf)
		var sbg = StyleBoxFlat.new()
		sbg.bg_color = Color(0.15, 0.15, 0.22)
		sbg.set_corner_radius_all(2)
		sbar.add_theme_stylebox_override("background", sbg)
		scol.add_child(sbar)
		skill_bars[sc[0]] = sbar

func _criar_skills_panel() -> void:
	# Botão flutuante para abrir
	var btn_abrir = Button.new()
	btn_abrir.text = "📊"
	btn_abrir.custom_minimum_size = Vector2(44, 32)
	btn_abrir.position = Vector2(MAP_W - 104, STATUS_H + 6)
	btn_abrir.z_index = 22
	btn_abrir.add_theme_font_size_override("font_size", 18)
	btn_abrir.pressed.connect(func():
		_atualizar_skills_panel()
		skills_panel.visible = true)
	add_child(btn_abrir)

	# Overlay escuro
	skills_panel = Control.new()
	skills_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	skills_panel.z_index = 50
	skills_panel.visible = false
	add_child(skills_panel)

	var bg = ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.88)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	skills_panel.add_child(bg)

	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.offset_top = 70
	panel.offset_bottom = -20
	panel.offset_left = 16
	panel.offset_right = -16
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.07, 0.12, 0.98)
	style.set_corner_radius_all(16)
	panel.add_theme_stylebox_override("panel", style)
	skills_panel.add_child(panel)

	var vbox_outer = VBoxContainer.new()
	vbox_outer.add_theme_constant_override("separation", 0)
	panel.add_child(vbox_outer)

	# Cabeçalho
	var header = HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 54)
	var mh = MarginContainer.new()
	mh.add_theme_constant_override("margin_left", 20)
	mh.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(mh)
	mh.add_child(_lbl("📊  Árvore de Habilidades", 18, Color.WHITE))
	var btn_fechar = Button.new()
	btn_fechar.text = "✕"
	btn_fechar.custom_minimum_size = Vector2(54, 54)
	btn_fechar.add_theme_font_size_override("font_size", 18)
	btn_fechar.pressed.connect(func(): skills_panel.visible = false)
	header.add_child(btn_fechar)
	vbox_outer.add_child(header)

	var div = ColorRect.new()
	div.color = Color(0.3, 0.3, 0.4, 0.5)
	div.custom_minimum_size = Vector2(0, 1)
	div.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox_outer.add_child(div)

	# Scroll
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox_outer.add_child(scroll)

	var mc = MarginContainer.new()
	mc.add_theme_constant_override("margin_left", 20)
	mc.add_theme_constant_override("margin_right", 20)
	mc.add_theme_constant_override("margin_top", 14)
	mc.add_theme_constant_override("margin_bottom", 14)
	mc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(mc)

	skills_content = VBoxContainer.new()
	skills_content.add_theme_constant_override("separation", 18)
	skills_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mc.add_child(skills_content)

func _criar_contatos_panel() -> void:
	var btn_abrir = Button.new()
	btn_abrir.text = "👥"
	btn_abrir.custom_minimum_size = Vector2(44, 32)
	btn_abrir.position = Vector2(MAP_W - 54, STATUS_H + 6)
	btn_abrir.z_index = 22
	btn_abrir.add_theme_font_size_override("font_size", 18)
	btn_abrir.pressed.connect(func():
		_atualizar_contatos_panel()
		contatos_panel.visible = true)
	add_child(btn_abrir)

	contatos_panel = Control.new()
	contatos_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	contatos_panel.z_index = 50
	contatos_panel.visible = false
	add_child(contatos_panel)

	var bg = ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.88)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	contatos_panel.add_child(bg)

	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.offset_top = 70
	panel.offset_bottom = -20
	panel.offset_left = 16
	panel.offset_right = -16
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.07, 0.12, 0.98)
	style.set_corner_radius_all(16)
	panel.add_theme_stylebox_override("panel", style)
	contatos_panel.add_child(panel)

	var vbox_outer = VBoxContainer.new()
	vbox_outer.add_theme_constant_override("separation", 0)
	panel.add_child(vbox_outer)

	var header = HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 54)
	var mh = MarginContainer.new()
	mh.add_theme_constant_override("margin_left", 20)
	mh.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(mh)
	mh.add_child(_lbl("👥  Contatos & Relacionamentos", 18, Color.WHITE))
	var btn_fechar = Button.new()
	btn_fechar.text = "✕"
	btn_fechar.custom_minimum_size = Vector2(54, 54)
	btn_fechar.add_theme_font_size_override("font_size", 18)
	btn_fechar.pressed.connect(func(): contatos_panel.visible = false)
	header.add_child(btn_fechar)
	vbox_outer.add_child(header)

	var div = ColorRect.new()
	div.color = Color(0.3, 0.3, 0.4, 0.5)
	div.custom_minimum_size = Vector2(0, 1)
	div.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox_outer.add_child(div)

	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox_outer.add_child(scroll)

	var mc = MarginContainer.new()
	mc.add_theme_constant_override("margin_left", 20)
	mc.add_theme_constant_override("margin_right", 20)
	mc.add_theme_constant_override("margin_top", 14)
	mc.add_theme_constant_override("margin_bottom", 14)
	mc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(mc)

	contatos_content = VBoxContainer.new()
	contatos_content.add_theme_constant_override("separation", 14)
	contatos_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mc.add_child(contatos_content)

func _atualizar_contatos_panel() -> void:
	if not is_instance_valid(contatos_content):
		return
	for c in contatos_content.get_children():
		c.queue_free()

	var sec_a = _lbl("👥  Amizades", 17, Color(0.65, 0.85, 1.0))
	contatos_content.add_child(sec_a)
	for npc_id in RelationshipManager.get_amizades():
		_adicionar_npc_card(npc_id)

	var sep = ColorRect.new()
	sep.color = Color(0.25, 0.25, 0.35, 0.6)
	sep.custom_minimum_size = Vector2(0, 1)
	sep.mouse_filter = Control.MOUSE_FILTER_IGNORE
	contatos_content.add_child(sep)

	var sec_r = _lbl("💕  Romances", 17, Color(1.0, 0.65, 0.85))
	contatos_content.add_child(sec_r)
	for npc_id in RelationshipManager.get_romances():
		_adicionar_npc_card(npc_id)

func _adicionar_npc_card(npc_id: String) -> void:
	var npc = RelationshipManager.get_npc(npc_id)
	var rel = GameState.get_relacionamento(npc_id)
	var pontos: float = rel["pontos"]
	var nivel: int = rel["nivel"]
	var tier_nome = RelationshipManager.get_tier_nome(npc_id, nivel)
	var cor_tipo = Color(0.65, 0.85, 1.0) if npc["tipo"] == "amizade" else Color(1.0, 0.75, 0.88)

	var card = VBoxContainer.new()
	card.add_theme_constant_override("separation", 4)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	contatos_content.add_child(card)

	var hdr = HBoxContainer.new()
	card.add_child(hdr)
	var lnome = _lbl("%s  %s" % [npc["emoji"], npc["nome"]], 15, Color.WHITE)
	lnome.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hdr.add_child(lnome)
	hdr.add_child(_lbl(tier_nome, 12, cor_tipo))

	var bar = ProgressBar.new()
	bar.min_value = 0
	bar.max_value = 100
	bar.value = pontos
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(0, 8)
	var fs = StyleBoxFlat.new()
	fs.bg_color = cor_tipo
	fs.set_corner_radius_all(3)
	bar.add_theme_stylebox_override("fill", fs)
	var bs = StyleBoxFlat.new()
	bs.bg_color = Color(0.15, 0.15, 0.22)
	bs.set_corner_radius_all(3)
	bar.add_theme_stylebox_override("background", bs)
	card.add_child(bar)

	var loc_id = npc.get("local", "")
	var loc_nome = LOCATIONS.get(loc_id, {}).get("nome", loc_id)
	card.add_child(_lbl("📍 %s  ·  %.0f / 100 pts" % [loc_nome, pontos], 11, Color(0.55, 0.65, 0.75)))

	if nivel >= 3:
		var ben = npc.get("beneficio_3", "")
		if ben != "":
			card.add_child(_lbl("✨ " + ben, 11, Color(0.65, 1.0, 0.65)))
	if nivel >= 5:
		var ben = npc.get("beneficio_5", "")
		if ben != "":
			card.add_child(_lbl("💎 " + ben, 11, Color(1.0, 0.85, 0.3)))

func _atualizar_skills_panel() -> void:
	if not is_instance_valid(skills_content):
		return
	for c in skills_content.get_children():
		c.queue_free()

	var skill_vals = {
		"criativo": GameState.habilidade_criativo,
		"tecnico": GameState.habilidade_tecnico,
		"comercial": GameState.habilidade_comercial,
	}
	var keys = ["criativo", "tecnico", "comercial"]

	for ki in keys.size():
		var key = keys[ki]
		var info = SKILL_TIERS[key]
		var pts = skill_vals[key]
		var tier_idx = mini(int(pts / 20.0), 5)

		var section = VBoxContainer.new()
		section.add_theme_constant_override("separation", 8)
		section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		skills_content.add_child(section)

		# Nome + pts
		var hdr = HBoxContainer.new()
		section.add_child(hdr)
		var lnome = _lbl("%s  %s — %s" % [info["emoji"], info["nome"], info["tiers"][tier_idx]["nome"]], 16, info["cor"])
		lnome.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hdr.add_child(lnome)
		hdr.add_child(_lbl("%.0f / 100" % pts, 13, Color(0.65, 0.65, 0.75)))

		# Barra de progresso
		var bar = ProgressBar.new()
		bar.min_value = 0
		bar.max_value = 100
		bar.value = pts
		bar.show_percentage = false
		bar.custom_minimum_size = Vector2(0, 12)
		var fs = StyleBoxFlat.new()
		fs.bg_color = info["cor"]
		fs.set_corner_radius_all(4)
		bar.add_theme_stylebox_override("fill", fs)
		var bs = StyleBoxFlat.new()
		bs.bg_color = Color(0.15, 0.15, 0.22)
		bs.set_corner_radius_all(4)
		bar.add_theme_stylebox_override("background", bs)
		section.add_child(bar)

		# Lista de tiers
		for i in info["tiers"].size():
			var tier = info["tiers"][i]
			var icone: String
			var cor_txt: Color
			if i < tier_idx:
				icone = "✅"
				cor_txt = Color(0.55, 0.85, 0.55)
			elif i == tier_idx:
				icone = "🔓"
				cor_txt = Color.WHITE
			else:
				icone = "🔒"
				cor_txt = Color(0.42, 0.42, 0.52)

			var txt = "%s  %dpts · %s" % [icone, tier["pts"], tier["nome"]]
			if tier["desc"] != "":
				txt += "\n         %s" % tier["desc"]
			var lbl = _lbl(txt, 13 if i == tier_idx else 12, cor_txt)
			lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			section.add_child(lbl)

		# Separador (exceto após o último)
		if ki < keys.size() - 1:
			var sep = ColorRect.new()
			sep.color = Color(0.25, 0.25, 0.35, 0.6)
			sep.custom_minimum_size = Vector2(0, 1)
			sep.mouse_filter = Control.MOUSE_FILTER_IGNORE
			skills_content.add_child(sep)

func _criar_task_panel() -> void:
	task_panel = PanelContainer.new()
	task_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	task_panel.offset_top = -PANEL_CLOSED_H
	task_panel.z_index = 25
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.13, 0.96)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	task_panel.add_theme_stylebox_override("panel", style)
	add_child(task_panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 14)
	task_panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	# Handle bar (drag indicator)
	var handle = ColorRect.new()
	handle.color = Color(0.5, 0.5, 0.6, 0.5)
	handle.custom_minimum_size = Vector2(50, 4)
	handle.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(handle)

	task_location_label = _lbl("Em trânsito...", 18, Color(0.85, 0.85, 0.95))
	vbox.add_child(task_location_label)

	label_tarefas = _lbl("", 13, Color(0.6, 0.6, 0.7))
	vbox.add_child(label_tarefas)

	task_container = VBoxContainer.new()
	task_container.add_theme_constant_override("separation", 8)
	vbox.add_child(task_container)

	progress_bar = ProgressBar.new()
	progress_bar.min_value = 0.0
	progress_bar.max_value = 100.0
	progress_bar.custom_minimum_size = Vector2(0, 20)
	progress_bar.show_percentage = false
	progress_bar.visible = false
	vbox.add_child(progress_bar)

	label_progress = _lbl("", 13, Color(0.8, 0.8, 0.85))
	label_progress.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_progress.visible = false
	vbox.add_child(label_progress)

	botao_proximo_dia = Button.new()
	botao_proximo_dia.text = "Próximo Dia →"
	botao_proximo_dia.custom_minimum_size = Vector2(0, 50)
	botao_proximo_dia.add_theme_font_size_override("font_size", 17)
	botao_proximo_dia.visible = false
	botao_proximo_dia.pressed.connect(_on_proximo_dia)
	vbox.add_child(botao_proximo_dia)

# ============================================================
func _conectar_sinais() -> void:
	GameState.status_atualizado.connect(_atualizar_ui)
	GameState.dia_avancou.connect(_on_dia_avancou)
	GameState.conquista_desbloqueada.connect(_on_conquista)
	GameState.humor_zerou.connect(_on_humor_zerou)
	GameState.saude_zerou.connect(_on_saude_zerou)

# ============================================================
func _process(delta: float) -> void:
	var kb = Vector2.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		kb.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		kb.y += 1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		kb.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		kb.x += 1
	if kb != Vector2.ZERO:
		kb = kb.normalized()

	var dir = player_direction if kb == Vector2.ZERO else kb
	if dir == Vector2.ZERO or tarefa_em_curso or estado_especial != "":
		return

	var speed = SPEEDS.get(GameState.transporte_atual, 150.0) * GameState.get_fator_velocidade()
	var move = dir * speed * delta
	player_pos.x = clampf(player_pos.x + move.x / MAP_W, 0.02, 0.98)
	player_pos.y = clampf(player_pos.y + move.y / MAP_H, 0.02, 0.98)

	_atualizar_posicao_player()
	_checar_proximidade_local()

func _atualizar_posicao_player() -> void:
	var screen_pos = _loc_to_screen(player_pos)
	player_node.position = screen_pos - Vector2(26, 39)

func _checar_proximidade_local() -> void:
	var mais_proximo = ""
	var menor_dist = DETECT_RADIUS
	var mais_proximo_locked = ""
	var menor_dist_locked = DETECT_RADIUS

	for loc_id in LOCATIONS:
		var loc = LOCATIONS[loc_id]
		var dist = player_pos.distance_to(loc["pos"])
		if _regiao_desbloqueada(loc["regiao"]):
			if dist < menor_dist:
				menor_dist = dist
				mais_proximo = loc_id
		else:
			if dist < menor_dist_locked:
				menor_dist_locked = dist
				mais_proximo_locked = loc_id

	if mais_proximo != active_location_id:
		active_location_id = mais_proximo
		locked_near_id = ""
		_atualizar_painel_tarefas()
	elif mais_proximo == "" and mais_proximo_locked != locked_near_id:
		locked_near_id = mais_proximo_locked
		if locked_near_id != "":
			_mostrar_local_bloqueado(locked_near_id)
		else:
			_atualizar_painel_tarefas()

func _regiao_desbloqueada(regiao: int) -> bool:
	return GameState.nivel_ia() >= regiao

func _verificar_desbloqueios() -> void:
	var nivel = GameState.nivel_ia()
	for i in region_overlays.size():
		var overlay = region_overlays[i]
		var unlock = int(overlay.name.split("_")[1])
		if unlock < region_overlays.size():
			var r = REGIONS[unlock]
			overlay.visible = nivel < r["unlock_level"]

# ============================================================
func _atualizar_painel_tarefas() -> void:
	for child in task_container.get_children():
		child.queue_free()
	botao_proximo_dia.visible = false
	progress_bar.visible = false
	label_progress.visible = false

	if active_location_id == "":
		task_location_label.text = "Em trânsito..."
		label_tarefas.text = "Chegue a um local para ver as tarefas"
		_fechar_painel()
		return

	var loc = LOCATIONS[active_location_id]
	task_location_label.text = "%s  %s" % [loc["emoji"], loc["nome"]]

	if loc.get("tipo", "") == "loja":
		_mostrar_loja(active_location_id)
		return

	if not GameState.pode_fazer_tarefa():
		label_tarefas.text = "Tarefas do dia concluídas"
		botao_proximo_dia.visible = true
		_abrir_painel()
		return

	label_tarefas.text = "%d/%d tarefas hoje" % [GameState.tarefas_completadas_hoje, GameState.max_tarefas_dia]

	var tarefas = TaskManager.get_tarefas_para_local(active_location_id)
	if tarefas.is_empty():
		if active_location_id == "hospital":
			label_tarefas.text = "Você está no hospital. Descanse."
		else:
			label_tarefas.text = "Nenhuma tarefa disponível aqui ainda"
		_abrir_painel()
		return

	for tarefa in tarefas:
		var ja_feita = GameState.tarefa_ja_feita(tarefa["id"])
		var btn = Button.new()
		btn.text = "%s  %s%s" % [tarefa["emoji"], tarefa["nome"], "  ✓" if ja_feita else ""]
		btn.tooltip_text = tarefa["descricao"]
		btn.custom_minimum_size = Vector2(0, 54)
		btn.add_theme_font_size_override("font_size", 15)
		btn.disabled = ja_feita
		if not ja_feita:
			btn.pressed.connect(_on_tarefa_selecionada.bind(tarefa))
		task_container.add_child(btn)

	_abrir_painel()

func _abrir_painel() -> void:
	if panel_tween:
		panel_tween.kill()
	panel_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	panel_tween.tween_property(task_panel, "offset_top", -PANEL_OPEN_H, 0.3)
	panel_tween.parallel().tween_property(joystick, "position:y",
		MAP_H - PANEL_OPEN_H - JOY_SIZE - JOY_MARGIN, 0.3)

func _fechar_painel() -> void:
	if panel_tween:
		panel_tween.kill()
	panel_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	panel_tween.tween_property(task_panel, "offset_top", -PANEL_CLOSED_H, 0.25)
	panel_tween.parallel().tween_property(joystick, "position:y",
		MAP_H - JOY_SIZE - JOY_MARGIN - PANEL_CLOSED_H, 0.25)

func _mostrar_local_bloqueado(loc_id: String) -> void:
	if tarefa_em_curso:
		return
	for child in task_container.get_children():
		child.queue_free()
	botao_proximo_dia.visible = false
	progress_bar.visible = false
	label_progress.visible = false

	var loc = LOCATIONS[loc_id]
	var nivel_necessario = loc["regiao"]
	var nivel_atual = GameState.nivel_ia()
	var media = (GameState.habilidade_criativo + GameState.habilidade_tecnico + GameState.habilidade_comercial) / 3.0
	var pts_faltam = maxi(int(nivel_necessario * 20.0 - media), 0)

	task_location_label.text = "🔒  %s  %s" % [loc["emoji"], loc["nome"]]
	label_tarefas.text = "Nível %d de IA necessário — você está no Nível %d" % [nivel_necessario, nivel_atual]

	var dica = _lbl("Faltam ~%d pontos de habilidade para desbloquear." % pts_faltam, 13, Color(0.65, 0.65, 0.82))
	dica.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	task_container.add_child(dica)
	_abrir_painel()

func _mostrar_loja(loc_id: String) -> void:
	if tarefa_em_curso:
		return
	for child in task_container.get_children():
		child.queue_free()
	botao_proximo_dia.visible = false
	progress_bar.visible = false
	label_progress.visible = false

	var itens = ItemManager.get_itens_da_loja(loc_id)
	if itens.is_empty():
		label_tarefas.text = "Sem estoque no momento."
		_abrir_painel()
		return

	label_tarefas.text = "O que deseja comprar?"

	for item in itens:
		var adquirido = GameState.tem_item(item["id"])
		var pode = GameState.dinheiro >= item["preco"] and not adquirido

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		task_container.add_child(row)

		var info = VBoxContainer.new()
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(info)
		info.add_child(_lbl("%s  %s" % [item["emoji"], item["nome"]], 15, Color.WHITE))
		info.add_child(_lbl(item["descricao"], 12, Color(0.65, 0.65, 0.78)))

		var btn = Button.new()
		if adquirido:
			btn.text = "✓ Tenho"
			btn.disabled = true
		else:
			btn.text = "R$ %.0f" % item["preco"]
			btn.disabled = not pode
			btn.pressed.connect(_on_comprar_item.bind(item, loc_id))
		btn.custom_minimum_size = Vector2(100, 50)
		btn.add_theme_font_size_override("font_size", 14)
		row.add_child(btn)

	_abrir_painel()

func _on_comprar_item(item: Dictionary, loc_id: String) -> void:
	if GameState.comprar_item(item["id"], item["preco"]):
		task_location_label.text = "✅  %s %s adquirido!" % [item["emoji"], item["nome"]]
	else:
		task_location_label.text = "❌  Dinheiro insuficiente."
	await get_tree().create_timer(1.5).timeout
	if active_location_id == loc_id:
		_mostrar_loja(loc_id)

# ============================================================
func _on_joystick_direction(dir: Vector2) -> void:
	player_direction = dir

func _on_tarefa_selecionada(tarefa: Dictionary) -> void:
	if tarefa_em_curso or estado_especial != "":
		return
	tarefa_em_curso = true

	for child in task_container.get_children():
		child.disabled = true

	label_progress.text = "Executando: %s %s..." % [tarefa["emoji"], tarefa["nome"]]
	label_progress.visible = true
	progress_bar.value = 0.0
	progress_bar.visible = true

	if tween_progress:
		tween_progress.kill()
	tween_progress = create_tween()
	tween_progress.tween_property(progress_bar, "value", 100.0, tarefa["duracao"])
	tween_progress.tween_callback(_on_tarefa_completada.bind(tarefa))

func _on_tarefa_completada(tarefa: Dictionary) -> void:
	var prev_nc  = GameState.nivel_criativo()
	var prev_nt  = GameState.nivel_tecnico()
	var prev_nco = GameState.nivel_comercial()
	var prev_ia  = GameState.nivel_ia()

	progress_bar.visible = false
	label_progress.visible = false
	tarefa_em_curso = false

	for campo in tarefa.get("efeitos", {}):
		GameState.modificar_status(campo, tarefa["efeitos"][campo])

	task_location_label.text = tarefa.get("narrativa", "Concluído.")
	GameState.registrar_tarefa(tarefa["id"])

	var slides: Array = []
	if GameState.nivel_criativo() > prev_nc:
		slides.append_array(_get_levelup_slides_skill("criativo", GameState.nivel_criativo()))
	if GameState.nivel_tecnico() > prev_nt:
		slides.append_array(_get_levelup_slides_skill("tecnico", GameState.nivel_tecnico()))
	if GameState.nivel_comercial() > prev_nco:
		slides.append_array(_get_levelup_slides_skill("comercial", GameState.nivel_comercial()))
	if GameState.nivel_ia() > prev_ia:
		slides.append_array(_get_levelup_slides_ia(GameState.nivel_ia()))

	if not slides.is_empty():
		_mostrar_story_panel(slides, _apos_levelup_story)
	else:
		_apos_levelup_story()

func _apos_levelup_story() -> void:
	var evento = EventManager.tentar_evento()
	if not evento.is_empty():
		_mostrar_evento(evento)
	else:
		_atualizar_painel_tarefas()

func _mostrar_story_panel(slides: Array, callback: Callable) -> void:
	var StoryPanelScript = load("res://scripts/StoryPanel.gd")
	var panel = StoryPanelScript.new()
	add_child(panel)
	panel.iniciar(slides)
	panel.fechou.connect(callback, CONNECT_ONE_SHOT)

func _mostrar_evento(evento: Dictionary) -> void:
	for child in task_container.get_children():
		child.queue_free()

	task_location_label.text = "⚡ " + evento.get("titulo", "Evento")

	var lbl = _lbl(evento.get("texto", ""), 14, Color(1.0, 0.92, 0.6))
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	task_container.add_child(lbl)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	task_container.add_child(hbox)

	if evento.get("escolha", false):
		var btn_sim = Button.new()
		btn_sim.text = "Aceitar"
		btn_sim.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_sim.pressed.connect(_on_escolha.bind(evento, true))
		hbox.add_child(btn_sim)
		var btn_nao = Button.new()
		btn_nao.text = "Recusar"
		btn_nao.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_nao.pressed.connect(_on_escolha.bind(evento, false))
		hbox.add_child(btn_nao)
	else:
		for campo in evento.get("efeitos", {}):
			GameState.modificar_status(campo, evento["efeitos"][campo])
		var btn_ok = Button.new()
		btn_ok.text = "OK"
		btn_ok.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_ok.pressed.connect(_fechar_evento)
		hbox.add_child(btn_ok)

func _on_escolha(evento: Dictionary, aceitou: bool) -> void:
	var chave = "efeitos_aceita" if aceitou else "efeitos_recusa"
	for campo in evento.get(chave, {}):
		GameState.modificar_status(campo, evento[chave][campo])
	var txt = evento.get("texto_aceita" if aceitou else "texto_recusa", "")
	if txt != "":
		task_location_label.text = txt
	_fechar_evento()

func _fechar_evento() -> void:
	_atualizar_painel_tarefas()

# ============================================================
func _on_proximo_dia() -> void:
	botao_proximo_dia.visible = false
	botao_proximo_dia.text = "Próximo Dia →"
	estado_especial = ""
	GameState.avancar_dia()
	_verificar_desbloqueios()
	_atualizar_painel_tarefas()

func _on_dia_avancou(dia: int) -> void:
	task_location_label.text = "Dia %d. O sol nasce. Você ainda está aqui." % dia

func _on_conquista(nome: String) -> void:
	task_location_label.text = "🏆 CONQUISTA: %s!" % nome

func _on_humor_zerou() -> void:
	estado_especial = "humor"
	tarefa_em_curso = false
	task_location_label.text = "Você colapsou emocionalmente."
	label_tarefas.text = "Trancado no quarto jogando no celular...\n📱 (O jogo é sobre um jovem que saiu de casa pra fazer sucesso com IA. Parece familiar?)"
	for child in task_container.get_children():
		child.queue_free()
	GameState.dia += 2
	GameState.humor = 35.0
	GameState.tarefas_completadas_hoje = GameState.max_tarefas_dia
	GameState.status_atualizado.emit()
	botao_proximo_dia.text = "Sair da toca →"
	botao_proximo_dia.visible = true
	_abrir_painel()

func _on_saude_zerou() -> void:
	estado_especial = "saude"
	tarefa_em_curso = false
	player_pos = Vector2(0.28, 0.12)
	_atualizar_posicao_player()
	task_location_label.text = "Você desmaiou na rua."
	label_tarefas.text = "Acordou no pronto-socorro. 5 dias internado."
	for child in task_container.get_children():
		child.queue_free()
	GameState.dia += 4
	GameState.saude = 30.0
	GameState.dinheiro -= 450.0
	GameState.tarefas_completadas_hoje = GameState.max_tarefas_dia
	GameState.status_atualizado.emit()
	botao_proximo_dia.text = "Receber alta →"
	botao_proximo_dia.visible = true
	_abrir_painel()

# ============================================================
func _atualizar_ui() -> void:
	var nivel = GameState.nivel_ia()
	var anos_extras = int(GameState.dia / 365)
	label_dia.text = "Dia %d  |  %d anos" % [GameState.dia, 18 + anos_extras]

	var din = GameState.dinheiro
	label_dinheiro.text = "R$ %s" % ("%.0f" % din if din >= 0 else "-%.0f" % abs(din))
	label_dinheiro.add_theme_color_override("font_color",
		Color(0.3, 0.9, 0.45) if din >= 300 else Color(1.0, 0.35, 0.35))

	status_bars["humor"].value   = GameState.humor
	status_bars["saude"].value   = GameState.saude
	status_bars["riqueza"].value = GameState.riqueza
	status_bars["fama"].value    = GameState.fama
	status_bars["impacto"].value = GameState.impacto

	skill_bars["habilidade_criativo"].value  = GameState.habilidade_criativo
	skill_bars["habilidade_tecnico"].value   = GameState.habilidade_tecnico
	skill_bars["habilidade_comercial"].value = GameState.habilidade_comercial

	skill_tier_labels["habilidade_criativo"].text  = "🎨 %s" % TIER_NAMES[GameState.nivel_criativo()]
	skill_tier_labels["habilidade_tecnico"].text   = "💻 %s" % TIER_NAMES[GameState.nivel_tecnico()]
	skill_tier_labels["habilidade_comercial"].text = "💼 %s" % TIER_NAMES[GameState.nivel_comercial()]

	if is_instance_valid(skills_panel) and skills_panel.visible:
		_atualizar_skills_panel()
	if is_instance_valid(contatos_panel) and contatos_panel.visible:
		_atualizar_contatos_panel()

	var nivel_cores = [
		Color(0.60, 0.60, 0.75),
		Color(0.30, 0.90, 0.45),
		Color(0.30, 0.70, 1.00),
		Color(0.80, 0.40, 1.00),
		Color(1.00, 0.85, 0.20),
		Color(1.00, 0.55, 0.10),
	]
	nivel_label.text = "IA Nv.%d" % nivel
	nivel_label.add_theme_color_override("font_color", nivel_cores[nivel])

	_verificar_desbloqueios()

# ============================================================
func _get_levelup_slides_skill(skill: String, nivel: int) -> Array:
	var dados = {
		"criativo": {
			"emoji": "🎨", "cor": Color(0.28, 0.10, 0.04),
			"tiers": [
				["Iniciante", "Você aprendeu a enxergar padrões visuais.\nCurso de design e thumbnails desbloqueados."],
				["Aprendiz",  "Sua criatividade tem forma.\nVídeos curtos com IA no Café WiFi disponíveis."],
				["Avançado",  "Você produz conteúdo que para o scroll.\nHackathon ao alcance."],
				["Expert",    "Direção criativa de verdade.\nProjetos de alto impacto. Você opera em outro nível."],
				["Mestre",    "Você é referência em criatividade com IA.\nToda a árvore criativa desbloqueada."],
			]
		},
		"tecnico": {
			"emoji": "💻", "cor": Color(0.04, 0.10, 0.28),
			"tiers": [
				["Iniciante", "Você entende o básico de código e automação.\nPrática de automação no PC desbloqueada."],
				["Aprendiz",  "Scripts e APIs fazem sentido para você.\nPesquisa e desenvolvimento no co-working disponível."],
				["Avançado",  "Você constrói produtos escaláveis.\nHackathon ao alcance."],
				["Expert",    "Arquitetura de sistemas. MVPs em dias, não meses."],
				["Mestre",    "Você é o dev que todos querem no time.\nToda a árvore técnica desbloqueada."],
			]
		},
		"comercial": {
			"emoji": "💼", "cor": Color(0.04, 0.20, 0.06),
			"tiers": [
				["Iniciante", "Você entende como o dinheiro se move.\nNetworking e curso de marketing desbloqueados."],
				["Aprendiz",  "Você prospecta e fecha pequenos negócios.\nPitch de serviços no co-working disponível."],
				["Avançado",  "Você fecha contratos com confiança.\nInvestidor anjo na mira."],
				["Expert",    "Parcerias corporativas. Contratos grandes.\nVocê negocia em outro patamar."],
				["Mestre",    "Você lidera mercados.\nToda a árvore comercial desbloqueada."],
			]
		},
	}
	if skill not in dados or nivel < 1 or nivel > 5:
		return []
	var d = dados[skill]
	var t = d["tiers"][nivel - 1]
	return [{"emoji": d["emoji"], "titulo": "%s — %s!" % [d["emoji"] + " " + ({"criativo":"Criativo","tecnico":"Técnico","comercial":"Comercial"}[skill]), t[0]], "texto": t[1], "cor": d["cor"]}]

func _get_levelup_slides_ia(nivel: int) -> Array:
	var infos = [
		["⬆️", Color(0.06, 0.18, 0.06), "IA Nível 1 — Centro Comercial!",
			"A cidade abre portas para você.\nBiblioteca, Café WiFi, Shopping e Parque agora acessíveis."],
		["⬆️", Color(0.04, 0.10, 0.22), "IA Nível 2 — Distrito Empresarial!",
			"Você chegou no mundo dos negócios.\nCo-working, Restaurante e Loja de Eletrônicos desbloqueados."],
		["⬆️", Color(0.18, 0.06, 0.28), "IA Nível 3 — Hub Tecnológico!",
			"O ecossistema de startups está ao seu alcance.\nStartup Hub, Bar do Hub e Tech Store disponíveis."],
		["⬆️", Color(0.28, 0.18, 0.04), "IA Nível 4 — Área Nobre!",
			"Você chegou onde poucos chegam.\nHospital, Instituto IA, Clube Social e Galeria Premium desbloqueados."],
		["🏆", Color(0.28, 0.10, 0.04), "IA Nível 5 — Mestre da IA!",
			"Você dominou a inteligência artificial.\nA cidade inteira é sua. Tudo desbloqueado."],
	]
	if nivel < 1 or nivel > 5:
		return []
	var info = infos[nivel - 1]
	return [{"emoji": info[0], "titulo": info[2], "texto": info[3], "cor": info[1]}]

# ============================================================
func _loc_to_screen(pos: Vector2) -> Vector2:
	return Vector2(pos.x * MAP_W, pos.y * MAP_H)

func _lbl(texto: String, size: int, cor: Color) -> Label:
	var l = Label.new()
	l.text = texto
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", cor)
	return l
