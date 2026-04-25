extends Node

const LOJAS: Dictionary = {
	"mercadinho": [
		{"id":"tenis",  "nome":"Tênis Confortável",    "emoji":"👟", "preco":120.0,  "descricao":"+50% velocidade ao andar"},
		{"id":"panela", "nome":"Panela + Mantimentos",  "emoji":"🍲", "preco":80.0,   "descricao":"Você cozinha em casa: +12 saúde por dia"},
	],
	"mall": [
		{"id":"fone",    "nome":"Fone de Ouvido",       "emoji":"🎧", "preco":350.0,  "descricao":"+1 tarefa disponível por dia"},
		{"id":"caderno", "nome":"Caderno de Estudos",   "emoji":"📓", "preco":200.0,  "descricao":"+20% em ganhos de habilidade"},
	],
	"loja_eletronicos": [
		{"id":"laptop", "nome":"Laptop Gamer",          "emoji":"💻", "preco":1200.0, "descricao":"+30% em ganhos de habilidade técnica"},
		{"id":"camera", "nome":"Câmera Profissional",   "emoji":"📷", "preco":900.0,  "descricao":"+30% em ganhos de habilidade criativa"},
	],
	"tech_store": [
		{"id":"ia_premium", "nome":"Assinatura IA Plus", "emoji":"🤖", "preco":1500.0, "descricao":"+25% em todos os ganhos de habilidade"},
		{"id":"scooter",    "nome":"Scooter Elétrico",   "emoji":"🛵", "preco":2000.0, "descricao":"Velocidade de deslocamento ×2"},
	],
	"galeria": [
		{"id":"quitinete", "nome":"Quitinete Própria",  "emoji":"🏠", "preco":12000.0, "descricao":"Elimina o aluguel mensal"},
		{"id":"carro",     "nome":"Carro",              "emoji":"🚗", "preco":25000.0, "descricao":"Velocidade de deslocamento ×3"},
	],
}

func get_itens_da_loja(loc_id: String) -> Array:
	return LOJAS.get(loc_id, [])
