extends Node

signal dia_avancou(dia: int)
signal status_atualizado
signal conquista_desbloqueada(nome: String)
signal humor_zerou
signal saude_zerou

var dia: int = 1
var idade: int = 18

var dinheiro: float = 3000.0
var aluguel_mensal: float = 1000.0

var riqueza: float = 10.0
var fama: float = 0.0
var impacto: float = 0.0
var humor: float = 70.0
var saude: float = 80.0

var habilidade_criativo: float = 0.0
var habilidade_tecnico: float = 0.0
var habilidade_comercial: float = 0.0

var tarefas_completadas_hoje: int = 0
var max_tarefas_dia: int = 4
var tarefas_feitas_hoje: Array[String] = []

var transporte_atual: int = 0

var conquistas_desbloqueadas: Array[String] = []
var itens_possuidos: Array[String] = []
var relacionamentos: Dictionary = {}

func avancar_dia() -> void:
	dia += 1
	tarefas_completadas_hoje = 0
	tarefas_feitas_hoje.clear()
	_cobrar_custo_diario()
	_decair_relacionamentos()
	dia_avancou.emit(dia)
	_verificar_barras()
	status_atualizado.emit()
	_verificar_conquistas()

func _cobrar_custo_diario() -> void:
	# Housing: R$1000/month ≈ R$33/day; free if owns quitinete
	if "quitinete" not in itens_possuidos:
		dinheiro -= aluguel_mensal / 30.0
	# Phone plan: R$60/month ≈ R$2/day
	dinheiro -= 2.0
	# Health decay: 3 days without eating/sleeping → zeroes from 80
	var saude_delta = -28.0
	if "panela" in itens_possuidos:
		saude_delta += 12.0
	saude = clampf(saude + saude_delta, 0.0, 100.0)
	# Mood decay: activities and sleep/food must counteract this
	var humor_delta = -8.0
	if _nivel_rel("luana") >= 3 or _nivel_rel("nico") >= 3:
		humor_delta += 8.0
	humor = clampf(humor + humor_delta, 0.0, 100.0)
	if _nivel_rel("seu_ze") >= 3:
		dinheiro += 30.0

func comprar_item(item_id: String, preco: float) -> bool:
	if dinheiro < preco or item_id in itens_possuidos:
		return false
	dinheiro -= preco
	itens_possuidos.append(item_id)
	match item_id:
		"fone": max_tarefas_dia += 1
		"quitinete": aluguel_mensal = 0.0
	status_atualizado.emit()
	return true

func tem_item(item_id: String) -> bool:
	return item_id in itens_possuidos

func get_fator_velocidade() -> float:
	if "carro" in itens_possuidos: return 3.0
	if "scooter" in itens_possuidos: return 2.0
	if "tenis" in itens_possuidos: return 1.5
	return 1.0

func get_multiplicador_skill(campo: String) -> float:
	var m = 1.0
	if "caderno" in itens_possuidos: m *= 1.20
	if "ia_premium" in itens_possuidos: m *= 1.25
	if campo == "habilidade_tecnico" and "laptop" in itens_possuidos: m *= 1.30
	if campo == "habilidade_criativo" and "camera" in itens_possuidos: m *= 1.30
	if campo == "habilidade_criativo" and _nivel_rel("marina") >= 3: m *= 1.15
	if campo == "habilidade_tecnico" and _nivel_rel("bruno") >= 3: m *= 1.15
	if campo == "habilidade_comercial" and _nivel_rel("carla") >= 3: m *= 1.15
	if campo.begins_with("habilidade_") and _nivel_rel("rafael") >= 3: m *= 1.10
	return m

func modificar_status(campo: String, valor: float) -> void:
	if campo.begins_with("relacionamento_"):
		var npc_id = campo.substr("relacionamento_".length())
		adicionar_pontos_relacionamento(npc_id, valor)
		return
	var v = valor
	if campo.begins_with("habilidade_") and valor > 0.0:
		v *= get_multiplicador_skill(campo)
	match campo:
		"dinheiro": dinheiro = maxf(-9999.0, dinheiro + v)
		"riqueza": riqueza = clampf(riqueza + v, 0.0, 100.0)
		"fama": fama = clampf(fama + v, 0.0, 100.0)
		"impacto": impacto = clampf(impacto + v, 0.0, 100.0)
		"humor": humor = clampf(humor + v, 0.0, 100.0)
		"saude": saude = clampf(saude + v, 0.0, 100.0)
		"habilidade_criativo": habilidade_criativo = clampf(habilidade_criativo + v, 0.0, 100.0)
		"habilidade_tecnico": habilidade_tecnico = clampf(habilidade_tecnico + v, 0.0, 100.0)
		"habilidade_comercial": habilidade_comercial = clampf(habilidade_comercial + v, 0.0, 100.0)
	status_atualizado.emit()

func _verificar_barras() -> void:
	if saude <= 0.0:
		saude = 0.0
		saude_zerou.emit()
	if humor <= 0.0:
		humor = 0.0
		humor_zerou.emit()

func _verificar_conquistas() -> void:
	_checar_conquista("Primeiro Milhão", riqueza >= 100.0)
	_checar_conquista("Influenciador", fama >= 100.0)
	_checar_conquista("Agente de Mudança", impacto >= 100.0)
	_checar_conquista("Equilibrista", riqueza >= 30.0 and fama >= 30.0 and impacto >= 30.0)

func _checar_conquista(nome: String, condicao: bool) -> void:
	if condicao and nome not in conquistas_desbloqueadas:
		conquistas_desbloqueadas.append(nome)
		conquista_desbloqueada.emit(nome)

func nivel_ia() -> int:
	var media = (habilidade_criativo + habilidade_tecnico + habilidade_comercial) / 3.0
	return int(media / 20.0)

func pode_fazer_tarefa() -> bool:
	return tarefas_completadas_hoje < max_tarefas_dia

func registrar_tarefa(tarefa_id: String) -> void:
	tarefas_completadas_hoje += 1
	if tarefa_id not in tarefas_feitas_hoje:
		tarefas_feitas_hoje.append(tarefa_id)

func tarefa_ja_feita(tarefa_id: String) -> bool:
	return tarefa_id in tarefas_feitas_hoje

func nivel_criativo() -> int:
	return mini(int(habilidade_criativo / 20.0), 5)

func nivel_tecnico() -> int:
	return mini(int(habilidade_tecnico / 20.0), 5)

func nivel_comercial() -> int:
	return mini(int(habilidade_comercial / 20.0), 5)

func get_relacionamento(npc_id: String) -> Dictionary:
	if npc_id not in relacionamentos:
		relacionamentos[npc_id] = {"pontos": 0.0, "nivel": 0}
	return relacionamentos[npc_id]

func nivel_relacionamento(npc_id: String) -> int:
	return get_relacionamento(npc_id)["nivel"]

func adicionar_pontos_relacionamento(npc_id: String, pontos: float) -> void:
	var rel = get_relacionamento(npc_id)
	rel["pontos"] = clampf(rel["pontos"] + pontos, 0.0, 100.0)
	rel["nivel"] = mini(int(rel["pontos"] / 20.0), 5)
	relacionamentos[npc_id] = rel
	status_atualizado.emit()

func _decair_relacionamentos() -> void:
	for npc_id in relacionamentos:
		var rel = relacionamentos[npc_id]
		rel["pontos"] = maxf(0.0, rel["pontos"] - 1.0)
		rel["nivel"] = mini(int(rel["pontos"] / 20.0), 5)
		relacionamentos[npc_id] = rel

func _nivel_rel(npc_id: String) -> int:
	if npc_id not in relacionamentos:
		return 0
	return relacionamentos[npc_id]["nivel"]
