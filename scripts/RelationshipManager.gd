extends Node

const AMIZADE_TIERS = ["Desconhecido", "Conhecido", "Amigo", "Próximo", "Confiante", "Inseparável"]

const NPCS: Dictionary = {
	# ── AMIZADES ────────────────────────────────────────────────
	"seu_ze": {
		"nome": "Seu Zé", "emoji": "👴", "tipo": "amizade",
		"descricao": "Dono do boteco. Sabe tudo sobre o bairro e todo mundo nele.",
		"local": "boteco", "regiao_min": 0,
		"beneficio_3": "+R$30 por dia (indica clientes do bairro)",
		"beneficio_5": "Empresta até R$500 em emergências sem juros",
	},
	"marina": {
		"nome": "Marina", "emoji": "📚", "tipo": "amizade",
		"descricao": "Bibliotecária apaixonada por tecnologia. Leu tudo, sabe onde achar o resto.",
		"local": "biblioteca", "regiao_min": 1,
		"beneficio_3": "+15% em ganhos de habilidade criativa",
		"beneficio_5": "Indica você para editoras, podcasts e veículos de mídia",
	},
	"bruno": {
		"nome": "Bruno", "emoji": "💻", "tipo": "amizade",
		"descricao": "Dev freelancer. Divide freelas quando está sobrecarregado.",
		"local": "cafe_wifi", "regiao_min": 1,
		"beneficio_3": "+15% em ganhos de habilidade técnica",
		"beneficio_5": "Parceria em projetos de alto valor — você entra junto",
	},
	"carla": {
		"nome": "Carla", "emoji": "💼", "tipo": "amizade",
		"descricao": "Gerente de RH. Conhece todo mundo no meio corporativo.",
		"local": "coworking", "regiao_min": 2,
		"beneficio_3": "+15% em ganhos de habilidade comercial",
		"beneficio_5": "Abre portas em empresas grandes — reuniões que você não conseguiria sozinho",
	},
	"rafael": {
		"nome": "Rafael", "emoji": "🚀", "tipo": "amizade",
		"descricao": "Cofundador de startup. Já errou o suficiente para saber o que funciona.",
		"local": "startup", "regiao_min": 3,
		"beneficio_3": "+10% em todos os ganhos de habilidade",
		"beneficio_5": "Convida você para co-fundar algo novo",
	},
	"isabela": {
		"nome": "Isabela", "emoji": "🌟", "tipo": "amizade",
		"descricao": "Investidora anjo. Financia ideias que valem a pena.",
		"local": "instituto", "regiao_min": 4,
		"beneficio_3": "+20% em ganhos de fama e impacto",
		"beneficio_5": "Considera investir diretamente na sua empresa",
	},
	# ── ROMANCES ────────────────────────────────────────────────
	"luana": {
		"nome": "Luana", "emoji": "💛", "tipo": "romance",
		"descricao": "Designer freelancer. Criativa, direta e sem papas na língua.",
		"local": "cafe_wifi", "regiao_min": 1,
		"beneficio_3": "+8 humor por dia — você fica animado só de pensar",
		"beneficio_5": "Parceria de vida — suporte mútuo nas crises",
		"tiers": ["Estranha", "Curiosidade", "Admiração", "Crush", "Namorada", "Parceira de Vida"],
	},
	"nico": {
		"nome": "Nico", "emoji": "💙", "tipo": "romance",
		"descricao": "Músico e desenvolvedor. Quieto, observador, surpreende na hora certa.",
		"local": "boteco", "regiao_min": 0,
		"beneficio_3": "+8 humor por dia — você fica animado só de pensar",
		"beneficio_5": "Parceiro de vida — suporte mútuo nas crises",
		"tiers": ["Estranho", "Curiosidade", "Admiração", "Crush", "Namorado", "Parceiro de Vida"],
	},
}

func get_npc(npc_id: String) -> Dictionary:
	return NPCS.get(npc_id, {})

func get_npcs_do_local(local_id: String) -> Array[String]:
	var resultado: Array[String] = []
	for id in NPCS:
		if NPCS[id]["local"] == local_id:
			resultado.append(id)
	return resultado

func get_tier_nome(npc_id: String, nivel: int) -> String:
	var npc = NPCS.get(npc_id, {})
	if npc.get("tipo", "") == "romance":
		var tiers = npc.get("tiers", AMIZADE_TIERS)
		return tiers[clampi(nivel, 0, tiers.size() - 1)]
	return AMIZADE_TIERS[clampi(nivel, 0, AMIZADE_TIERS.size() - 1)]

func get_amizades() -> Array[String]:
	var r: Array[String] = []
	for id in NPCS:
		if NPCS[id]["tipo"] == "amizade":
			r.append(id)
	return r

func get_romances() -> Array[String]:
	var r: Array[String] = []
	for id in NPCS:
		if NPCS[id]["tipo"] == "romance":
			r.append(id)
	return r
