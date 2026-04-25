extends Node

var eventos: Array[Dictionary] = []

func _ready() -> void:
	_carregar_eventos()

func _carregar_eventos() -> void:
	eventos = [
		{
			"id": "vizinho_barulhento",
			"titulo": "Vizinho barulhento",
			"texto": "Seu vizinho de quarto passou a madrugada inteira ouvindo música. Você dormiu mal.",
			"chance": 0.15,
			"requer_nivel": 0,
			"efeitos": {"saude": -8.0, "humor": -12.0},
		},
		{
			"id": "chuva_sem_guarda",
			"titulo": "Chuva sem guarda-chuva",
			"texto": "Você saiu sem guarda-chuva e encharcou. Chegou em casa com o pé no chão.",
			"chance": 0.12,
			"requer_nivel": 0,
			"efeitos": {"saude": -10.0, "humor": -8.0},
		},
		{
			"id": "cliente_satisfeito",
			"titulo": "Indicação espontânea",
			"texto": "Um cliente satisfeito te indicou para um amigo sem você pedir. Sua reputação cresce devagar, mas cresce.",
			"chance": 0.12,
			"requer_nivel": 1,
			"efeitos": {"fama": 8.0, "humor": 10.0, "riqueza": 3.0},
		},
		{
			"id": "limite_ia_gratuita",
			"titulo": "Limite da IA gratuita",
			"texto": "Sua conta gratuita atingiu o limite do mês. Você fica sem a ferramenta principal por alguns dias.",
			"chance": 0.10,
			"requer_nivel": 1,
			"efeitos": {"humor": -18.0, "habilidade_tecnico": -2.0},
		},
		{
			"id": "post_viral",
			"titulo": "Post viraliza localmente!",
			"texto": "Um post que você criou viralizou em grupos locais. Pessoas na rua te reconhecem pelo apelido online.",
			"chance": 0.06,
			"requer_nivel": 1,
			"efeitos": {"fama": 18.0, "humor": 20.0, "riqueza": 5.0},
		},
		{
			"id": "oportunidade_duvidosa",
			"titulo": "Proposta suspeita",
			"texto": "Uma empresa oferece bom dinheiro para você criar conteúdo enganoso com IA. O valor é tentador.",
			"chance": 0.06,
			"requer_nivel": 1,
			"escolha": true,
			"texto_aceita": "Você aceita. O dinheiro entra. Mas você evita olhar para o próprio reflexo por uns dias.",
			"texto_recusa": "Você recusa. A empresa insiste. Você bloqueia o contato. Parece que foi a coisa certa.",
			"efeitos_aceita": {"dinheiro": 600.0, "riqueza": 10.0, "impacto": -25.0, "humor": -10.0},
			"efeitos_recusa": {"impacto": 15.0, "fama": 8.0, "humor": 15.0},
		},
		{
			"id": "encontra_mentor",
			"titulo": "Encontrou um mentor",
			"texto": "Você conheceu alguém mais experiente numa comunidade online. Ele aceita responder suas dúvidas de vez em quando.",
			"chance": 0.05,
			"requer_nivel": 1,
			"efeitos": {"habilidade_tecnico": 8.0, "habilidade_comercial": 5.0, "humor": 15.0},
		},
		{
			"id": "cliente_difícil",
			"titulo": "Cliente impossível",
			"texto": "Um cliente rejeitou todo o trabalho sem explicação. Você refez três vezes. Não valeu a pena.",
			"chance": 0.10,
			"requer_nivel": 1,
			"efeitos": {"humor": -20.0, "dinheiro": -50.0},
		},
	]

func tentar_evento() -> Dictionary:
	var nivel = GameState.nivel_ia()
	var candidatos: Array[Dictionary] = []

	for evento in eventos:
		if nivel >= evento.get("requer_nivel", 0):
			candidatos.append(evento)

	for evento in candidatos:
		if randf() < evento.get("chance", 0.0):
			return evento

	return {}
