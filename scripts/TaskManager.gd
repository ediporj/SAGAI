extends Node

func get_tarefas_para_local(location_id: String) -> Array[Dictionary]:
	var todas = _todas_as_tarefas()
	var resultado: Array[Dictionary] = []
	for t in todas:
		if t["local"] == location_id:
			resultado.append(t)
	return resultado

func _todas_as_tarefas() -> Array[Dictionary]:
	var tarefas: Array[Dictionary] = []
	var nc = GameState.nivel_criativo()
	var nt = GameState.nivel_tecnico()
	var nco = GameState.nivel_comercial()
	var nivel = GameState.nivel_ia()
	var rel_luana = GameState.nivel_relacionamento("luana")
	var rel_nico  = GameState.nivel_relacionamento("nico")

	# ── ESPELUNCA ──────────────────────────────────────────────
	tarefas.append({
		"id": "dormir", "local": "espelunca",
		"nome": "Dormir", "emoji": "😴",
		"descricao": "Descansar e recuperar energia",
		"duracao": 2.0,
		"efeitos": {"saude": 40.0, "humor": 25.0},
		"narrativa": "Você fecha os olhos numa cama dura e acorda bem melhor.",
	})
	tarefas.append({
		"id": "estudar_celular", "local": "espelunca",
		"nome": "Estudar pelo celular", "emoji": "📱",
		"descricao": "Vídeos e tutoriais de IA no celular",
		"duracao": 2.0,
		"efeitos": {"habilidade_criativo": 4.0, "habilidade_tecnico": 4.0, "habilidade_comercial": 1.0, "humor": 2.0, "dinheiro": -2.0},
		"narrativa": "Deitado na cama, você assiste tutoriais até o celular esquentar. Cada vídeo faz mais sentido.",
	})
	if nc >= 1:
		tarefas.append({
			"id": "curso_design", "local": "espelunca",
			"nome": "Curso online de Design", "emoji": "🎨",
			"descricao": "Curso focado em criatividade com IA",
			"duracao": 2.5,
			"efeitos": {"habilidade_criativo": 12.0, "humor": 3.0},
			"narrativa": "Você pratica composição visual, cores e narrativa. Sua visão começa a mudar.",
		})
	if nt >= 1:
		tarefas.append({
			"id": "praticar_automacao", "local": "espelunca",
			"nome": "Praticar automação no PC", "emoji": "🤖",
			"descricao": "Exercícios práticos de automação",
			"duracao": 2.5,
			"efeitos": {"habilidade_tecnico": 12.0, "humor": 3.0},
			"narrativa": "Você monta scripts, quebra, conserta. Cada erro ensina mais do que qualquer tutorial.",
		})
	if nco >= 1:
		tarefas.append({
			"id": "estudar_negocios", "local": "espelunca",
			"nome": "Estudar cases de negócios", "emoji": "📊",
			"descricao": "Analisar como empresas usam IA para crescer",
			"duracao": 2.5,
			"efeitos": {"habilidade_comercial": 12.0, "humor": 3.0},
			"narrativa": "Você lê sobre startups que faturaram com IA. Começa a ver onde pode se encaixar.",
		})

	# ── BOTECO (lazer) ─────────────────────────────────────────
	tarefas.append({
		"id": "comer", "local": "boteco",
		"nome": "Comer", "emoji": "🍽️",
		"descricao": "Comer o básico no boteco da esquina",
		"duracao": 1.5,
		"efeitos": {"saude": 25.0, "humor": 8.0, "dinheiro": -15.0},
		"narrativa": "Um prato simples. Não tem gosto de nada, mas seu corpo agradece.",
	})
	tarefas.append({
		"id": "cerveja_boteco", "local": "boteco",
		"nome": "Tomar uma cerveja", "emoji": "🍺",
		"descricao": "Descomprimir depois de um dia pesado",
		"duracao": 1.5,
		"efeitos": {"humor": 25.0, "saude": -8.0, "dinheiro": -12.0},
		"narrativa": "Uma gelada. O barulho da rua lá fora. Você respira. Não tá tudo perdido.",
	})
	tarefas.append({
		"id": "sinuca", "local": "boteco",
		"nome": "Jogar sinuca", "emoji": "🎱",
		"descricao": "Papo e sinuca com o pessoal do bairro",
		"duracao": 2.0,
		"efeitos": {"humor": 18.0, "habilidade_comercial": 2.0},
		"narrativa": "Você perde três partidas mas aprende os nomes de todo mundo. Conexões valem mais.",
	})
	tarefas.append({
		"id": "conversar_seu_ze", "local": "boteco",
		"nome": "Papo com Seu Zé", "emoji": "👴",
		"descricao": "Conversa com o dono do boteco — ele sabe de tudo",
		"duracao": 1.5,
		"efeitos": {"relacionamento_seu_ze": 8.0, "humor": 8.0},
		"narrativa": "Seu Zé te conta do bairro com a sabedoria de décadas. Uma hora com ele vale mais do que muita aula.",
	})
	tarefas.append({
		"id": "date_nico_boteco", "local": "boteco",
		"nome": "Encontro com Nico", "emoji": "💙",
		"descricao": "Rolar um papo com Nico no boteco",
		"duracao": 2.0,
		"efeitos": {"relacionamento_nico": 10.0, "humor": 14.0, "saude": -5.0, "dinheiro": -15.0},
		"narrativa": "Nico pega o violão e toca alguma coisa enquanto vocês conversam. O tempo para completamente.",
	})

	# ── RUA ────────────────────────────────────────────────────
	tarefas.append({
		"id": "trabalho_bracal", "local": "rua",
		"nome": "Trabalho braçal", "emoji": "📦",
		"descricao": "Panfletagem e carregar caixas",
		"duracao": 3.5,
		"efeitos": {"dinheiro": 80.0, "humor": -8.0, "saude": -12.0},
		"narrativa": "Horas distribuindo panfletos no sol. Cansativo. Mas o dinheiro caiu.",
	})
	tarefas.append({
		"id": "explorar", "local": "rua",
		"nome": "Explorar a cidade", "emoji": "🚶",
		"descricao": "Caminhar e conhecer as oportunidades",
		"duracao": 2.0,
		"efeitos": {"humor": 15.0, "fama": 2.0, "habilidade_criativo": 2.0},
		"narrativa": "Você caminha sem destino fixo. Cada esquina é um pedaço novo de mundo.",
	})
	tarefas.append({
		"id": "procurar_emprego", "local": "rua",
		"nome": "Procurar emprego", "emoji": "💼",
		"descricao": "Bater de porta em porta",
		"duracao": 2.5,
		"efeitos": {"humor": -5.0, "riqueza": 3.0, "habilidade_comercial": 6.0},
		"narrativa": "Metade pede experiência que você não tem. Mas você aprende como o jogo funciona.",
	})
	if nco >= 1:
		tarefas.append({
			"id": "networking", "local": "rua",
			"nome": "Fazer networking", "emoji": "🤝",
			"descricao": "Conversar com pessoas da área",
			"duracao": 2.0,
			"efeitos": {"habilidade_comercial": 8.0, "fama": 4.0, "dinheiro": 30.0, "humor": 5.0},
			"narrativa": "Uma conversa virou um contato. Um contato virou uma oportunidade.",
		})
	if nc >= 1 or nt >= 1:
		tarefas.append({
			"id": "meetup_ia", "local": "rua",
			"nome": "Meetup de IA", "emoji": "🎤",
			"descricao": "Evento mensal da comunidade de IA",
			"duracao": 2.5,
			"efeitos": {"fama": 8.0, "humor": 10.0, "habilidade_criativo": 3.0, "habilidade_tecnico": 3.0},
			"narrativa": "Você ouve palestras, troca ideia com devs e criadores. Sai inspirado.",
		})

	# ── PARQUE (lazer, region 1) ───────────────────────────────
	if nivel >= 1:
		tarefas.append({
			"id": "caminhada_parque", "local": "parque",
			"nome": "Caminhada no parque", "emoji": "🌳",
			"descricao": "Ar livre e cabeça no lugar",
			"duracao": 1.5,
			"efeitos": {"humor": 15.0, "saude": 8.0},
			"narrativa": "Você anda sem destino, fone no ouvido, pensando. A cidade parece menor daqui.",
		})
		tarefas.append({
			"id": "piquenique", "local": "parque",
			"nome": "Piquenique", "emoji": "🧺",
			"descricao": "Relaxar com comida e natureza",
			"duracao": 2.0,
			"efeitos": {"humor": 20.0, "saude": 12.0, "dinheiro": -25.0},
			"narrativa": "Uma hora de paz. Você lembra por que saiu de casa. Ainda vale a pena.",
		})
		if rel_luana >= 1:
			tarefas.append({
				"id": "date_luana_parque", "local": "parque",
				"nome": "Passeio com Luana", "emoji": "💛",
				"descricao": "Tarde no parque com Luana",
				"duracao": 2.0,
				"efeitos": {"relacionamento_luana": 12.0, "humor": 18.0},
				"narrativa": "Luana aponta detalhes de design em cada coisa ao redor. Você começa a ver o mundo com outros olhos.",
			})

	# ── RESTAURANTE (lazer, region 2) ──────────────────────────
	if nivel >= 2:
		tarefas.append({
			"id": "jantar_especial", "local": "restaurante",
			"nome": "Jantar especial", "emoji": "🍴",
			"descricao": "Uma refeição de verdade",
			"duracao": 1.5,
			"efeitos": {"humor": 28.0, "saude": 12.0, "dinheiro": -80.0},
			"narrativa": "Você senta, pede o prato, mastiga devagar. Isso é luxo. Você merece.",
		})
		tarefas.append({
			"id": "happy_hour", "local": "restaurante",
			"nome": "Happy Hour profissional", "emoji": "🍷",
			"descricao": "Networking descontraído com clientes",
			"duracao": 2.0,
			"efeitos": {"humor": 22.0, "saude": -5.0, "habilidade_comercial": 5.0, "dinheiro": -50.0},
			"narrativa": "Entre drinks, você fecha um acordo informal. O negócio começa nas mesas.",
		})
		if rel_luana >= 2:
			tarefas.append({
				"id": "date_luana_restaurante", "local": "restaurante",
				"nome": "Jantar com Luana", "emoji": "💛",
				"descricao": "Um jantar especial com Luana",
				"duracao": 2.0,
				"efeitos": {"relacionamento_luana": 15.0, "humor": 20.0, "dinheiro": -80.0},
				"narrativa": "A conversa vai fundo. Luana ri de um jeito que você não esperava. A conta parece barata perto disso.",
			})
		if rel_nico >= 2:
			tarefas.append({
				"id": "date_nico_restaurante", "local": "restaurante",
				"nome": "Jantar com Nico", "emoji": "💙",
				"descricao": "Um jantar especial com Nico",
				"duracao": 2.0,
				"efeitos": {"relacionamento_nico": 15.0, "humor": 20.0, "dinheiro": -80.0},
				"narrativa": "Nico chegou com a atenção de quem realmente quer estar ali. A conta não importou.",
			})

	# ── BAR DO HUB (lazer, region 3) ───────────────────────────
	if nivel >= 3:
		tarefas.append({
			"id": "cerveja_hub", "local": "bar_hub",
			"nome": "Cerveja artesanal", "emoji": "🍻",
			"descricao": "Descomprimir com a galera do Hub",
			"duracao": 1.5,
			"efeitos": {"humor": 22.0, "saude": -10.0, "dinheiro": -35.0},
			"narrativa": "Você ri pela primeira vez em dias. A comunidade aqui é diferente.",
		})
		tarefas.append({
			"id": "papo_fundadores", "local": "bar_hub",
			"nome": "Papo com fundadores", "emoji": "💡",
			"descricao": "Histórias reais de quem já errou muito",
			"duracao": 2.0,
			"efeitos": {"humor": 15.0, "habilidade_comercial": 6.0, "habilidade_tecnico": 4.0},
			"narrativa": "Um fundador te conta o erro que quase fechou a empresa. Você anota tudo.",
		})
		if rel_nico >= 1:
			tarefas.append({
				"id": "date_nico_hub", "local": "bar_hub",
				"nome": "Noite com Nico", "emoji": "💙",
				"descricao": "Cerveja artesanal e boa conversa com Nico",
				"duracao": 2.0,
				"efeitos": {"relacionamento_nico": 12.0, "humor": 18.0, "saude": -8.0, "dinheiro": -40.0},
				"narrativa": "Entre músicas ao vivo e risadas, algo entre vocês fica mais claro. Você não quer ir embora.",
			})

	# ── CLUBE SOCIAL (lazer, region 4) ─────────────────────────
	if nivel >= 4:
		tarefas.append({
			"id": "evento_exclusivo", "local": "clube",
			"nome": "Evento exclusivo", "emoji": "🎭",
			"descricao": "Arte, design e conversas de alto nível",
			"duracao": 2.0,
			"efeitos": {"humor": 28.0, "fama": 10.0, "dinheiro": -150.0},
			"narrativa": "Você circula entre pessoas que constroem coisas reais. Seu nome já circula.",
		})
		tarefas.append({
			"id": "reuniao_negocios", "local": "clube",
			"nome": "Reunião de negócios", "emoji": "🤝",
			"descricao": "Encontro estratégico com parceiros",
			"duracao": 2.5,
			"efeitos": {"habilidade_comercial": 8.0, "fama": 6.0, "dinheiro": -100.0},
			"narrativa": "Você apresenta sua visão. Eles escutam de verdade. Algo vai acontecer.",
		})
		if rel_luana >= 3:
			tarefas.append({
				"id": "date_luana_clube", "local": "clube",
				"nome": "Noite com Luana", "emoji": "💛",
				"descricao": "Evento exclusivo com Luana",
				"duracao": 2.5,
				"efeitos": {"relacionamento_luana": 20.0, "humor": 28.0, "saude": -5.0, "dinheiro": -150.0},
				"narrativa": "Luana de vestido, você de terno. O evento era bom — mas vocês dois foram o destaque real.",
			})
		if rel_nico >= 3:
			tarefas.append({
				"id": "date_nico_clube", "local": "clube",
				"nome": "Noite com Nico", "emoji": "💙",
				"descricao": "Evento exclusivo com Nico",
				"duracao": 2.5,
				"efeitos": {"relacionamento_nico": 20.0, "humor": 28.0, "saude": -5.0, "dinheiro": -150.0},
				"narrativa": "Nico de smoking, você elegante. Entre gente que constrói coisas, vocês constroem algo entre si.",
			})

	# ── INSTITUTO IA (estudo, region 4) ────────────────────────
	if nivel >= 4:
		tarefas.append({
			"id": "workshop_avancado", "local": "instituto",
			"nome": "Workshop Avançado", "emoji": "🔬",
			"descricao": "Imersão com pesquisadores de IA",
			"duracao": 3.5,
			"efeitos": {"habilidade_criativo": 12.0, "habilidade_tecnico": 12.0, "habilidade_comercial": 8.0},
			"narrativa": "Você aprende em 4 horas o que levaria meses por conta. A fronteira mudou.",
		})
		tarefas.append({
			"id": "conferencia_ia", "local": "instituto",
			"nome": "Conferência de IA", "emoji": "🏅",
			"descricao": "Palestra e networking com referências da área",
			"duracao": 4.0,
			"efeitos": {"fama": 20.0, "impacto": 10.0, "habilidade_criativo": 5.0, "habilidade_tecnico": 5.0, "dinheiro": -200.0},
			"narrativa": "Você apresenta um projeto. Duzentas pessoas aplaudem. Isso é real.",
		})
		tarefas.append({
			"id": "conversar_isabela", "local": "instituto",
			"nome": "Reunião com Isabela", "emoji": "🌟",
			"descricao": "Papo com a investidora anjo — ela financia ideias que valem",
			"duracao": 2.0,
			"efeitos": {"relacionamento_isabela": 8.0, "humor": 10.0, "fama": 5.0, "impacto": 5.0},
			"narrativa": "Isabela te faz perguntas que ninguém te fez antes. Você percebe que sua ideia tem mais substância do que pensava.",
		})

	# ── BIBLIOTECA ─────────────────────────────────────────────
	if nivel >= 1:
		tarefas.append({
			"id": "estudar_ia", "local": "biblioteca",
			"nome": "Estudar IA (geral)", "emoji": "💡",
			"descricao": "Aprender pelo laptop — cursos gratuitos",
			"duracao": 3.0,
			"efeitos": {"habilidade_criativo": 8.0, "habilidade_tecnico": 8.0, "humor": 5.0},
			"narrativa": "Você passa horas nos tutoriais. Começa a fazer muito mais sentido do que ontem.",
		})
		tarefas.append({
			"id": "curso_criativo_ia", "local": "biblioteca",
			"nome": "Curso: Criatividade com IA", "emoji": "🎨",
			"descricao": "Foco em geração de conteúdo e arte",
			"duracao": 3.0,
			"efeitos": {"habilidade_criativo": 15.0, "fama": 3.0},
			"narrativa": "Você aprende a usar IA como ferramenta criativa. O resultado surpreende até você.",
		})
		tarefas.append({
			"id": "curso_tecnico_ia", "local": "biblioteca",
			"nome": "Curso: Programação com IA", "emoji": "💻",
			"descricao": "Foco em código, scripts e automações",
			"duracao": 3.0,
			"efeitos": {"habilidade_tecnico": 15.0},
			"narrativa": "Python, APIs, prompts estruturados. Cada linha de código fica mais natural.",
		})
		tarefas.append({
			"id": "curso_marketing_ia", "local": "biblioteca",
			"nome": "Curso: Marketing Digital", "emoji": "📣",
			"descricao": "Foco em vendas, alcance e persuasão",
			"duracao": 3.0,
			"efeitos": {"habilidade_comercial": 15.0, "fama": 3.0},
			"narrativa": "Você entende funis, copy e como vender sem parecer vendedor.",
		})
		tarefas.append({
			"id": "conversar_marina", "local": "biblioteca",
			"nome": "Papo com Marina", "emoji": "📚",
			"descricao": "Conversa com a bibliotecária apaixonada por tecnologia",
			"duracao": 1.5,
			"efeitos": {"relacionamento_marina": 8.0, "humor": 8.0, "habilidade_criativo": 3.0},
			"narrativa": "Marina te indica referências que mudam como você pensa criatividade. Você sai com a cabeça a mil.",
		})

	# ── CAFÉ WIFI ──────────────────────────────────────────────
	if nivel >= 1:
		tarefas.append({
			"id": "freela_post", "local": "cafe_wifi",
			"nome": "Criar posts com IA", "emoji": "✨",
			"descricao": "Vender posts para pequenos negócios",
			"duracao": 3.0,
			"efeitos": {"dinheiro": 120.0, "habilidade_criativo": 3.0, "fama": 3.0, "riqueza": 3.0},
			"narrativa": "Você usa IA para criar posts para uma loja local. O dono ficou satisfeito.",
		})
		if nc >= 2:
			tarefas.append({
				"id": "freela_video", "local": "cafe_wifi",
				"nome": "Criar vídeos curtos com IA", "emoji": "🎬",
				"descricao": "Reels e Shorts para clientes",
				"duracao": 3.0,
				"efeitos": {"dinheiro": 180.0, "habilidade_criativo": 5.0, "fama": 8.0, "riqueza": 4.0},
				"narrativa": "O vídeo ficou bom. O cliente mandou pra família inteira. Seu nome começa a circular.",
			})
		if nco >= 2:
			tarefas.append({
				"id": "prospectar_clientes", "local": "cafe_wifi",
				"nome": "Prospectar clientes", "emoji": "📧",
				"descricao": "Cold email e DMs para potenciais clientes",
				"duracao": 2.5,
				"efeitos": {"dinheiro": 100.0, "habilidade_comercial": 5.0, "riqueza": 4.0},
				"narrativa": "De 50 mensagens, 3 responderam. Uma marcou reunião. Isso é progresso.",
			})
		tarefas.append({
			"id": "conversar_bruno", "local": "cafe_wifi",
			"nome": "Papo com Bruno", "emoji": "💻",
			"descricao": "Trocar ideia com o dev freelancer",
			"duracao": 1.5,
			"efeitos": {"relacionamento_bruno": 8.0, "humor": 8.0, "habilidade_tecnico": 3.0},
			"narrativa": "Bruno te mostra um atalho de código que te salva horas de trabalho. É assim que freelas funcionam.",
		})
		tarefas.append({
			"id": "date_luana_cafe", "local": "cafe_wifi",
			"nome": "Café com Luana", "emoji": "💛",
			"descricao": "Um café descontraído com Luana",
			"duracao": 1.5,
			"efeitos": {"relacionamento_luana": 10.0, "humor": 14.0, "dinheiro": -20.0},
			"narrativa": "Luana mostra o portfólio no celular, animadíssima. Você escuta de verdade. Ela percebe.",
		})

	# ── CO-WORKING ─────────────────────────────────────────────
	if nivel >= 2:
		tarefas.append({
			"id": "freela_automacao", "local": "coworking",
			"nome": "Freela de automação", "emoji": "⚙️",
			"descricao": "Automatizar processos com IA",
			"duracao": 4.0,
			"efeitos": {"dinheiro": 320.0, "habilidade_tecnico": 5.0, "riqueza": 6.0, "impacto": 3.0},
			"narrativa": "Você automatiza o atendimento de um cliente. Ele economiza 3 horas por dia.",
		})
		if nco >= 2:
			tarefas.append({
				"id": "pitch_servicos", "local": "coworking",
				"nome": "Pitch de serviços de IA", "emoji": "🎯",
				"descricao": "Apresentar proposta para empresas",
				"duracao": 3.0,
				"efeitos": {"dinheiro": 250.0, "habilidade_comercial": 4.0, "riqueza": 6.0, "fama": 5.0},
				"narrativa": "Você apresenta com confiança. Um deles pede orçamento. Outro quer reunião na semana.",
			})
		if nt >= 2:
			tarefas.append({
				"id": "pesquisa_produto", "local": "coworking",
				"nome": "Pesquisa e desenvolvimento", "emoji": "🔬",
				"descricao": "Investigar tecnologias e validar ideias",
				"duracao": 3.5,
				"efeitos": {"habilidade_tecnico": 6.0, "impacto": 5.0, "riqueza": 3.0},
				"narrativa": "Você testa três abordagens diferentes. Duas falham. A terceira abre uma janela.",
			})
		tarefas.append({
			"id": "conversar_carla", "local": "coworking",
			"nome": "Papo com Carla", "emoji": "💼",
			"descricao": "Conversa com a gerente de RH — ela abre portas",
			"duracao": 1.5,
			"efeitos": {"relacionamento_carla": 8.0, "humor": 8.0, "habilidade_comercial": 3.0},
			"narrativa": "Carla te explica como as grandes empresas pensam. De repente você entende como entrar pela porta certa.",
		})

	# ── STARTUP ────────────────────────────────────────────────
	if nivel >= 3:
		tarefas.append({
			"id": "construir_produto", "local": "startup",
			"nome": "Construir produto com IA", "emoji": "🚀",
			"descricao": "Criar uma ferramenta própria",
			"duracao": 5.0,
			"efeitos": {"habilidade_tecnico": 6.0, "habilidade_criativo": 4.0, "riqueza": 4.0, "impacto": 5.0},
			"narrativa": "Você passa horas construindo algo totalmente seu. Ainda não gera dinheiro. Mas vai.",
		})
		if nco >= 3:
			tarefas.append({
				"id": "buscar_investidor", "local": "startup",
				"nome": "Buscar investidor anjo", "emoji": "💰",
				"descricao": "Apresentar para fundos e angels",
				"duracao": 4.0,
				"efeitos": {"riqueza": 12.0, "fama": 10.0, "habilidade_comercial": 5.0, "humor": -5.0},
				"narrativa": "Dois 'não' e um 'talvez'. O 'talvez' vale mais do que parece.",
			})
		if nc >= 3 and nt >= 3:
			tarefas.append({
				"id": "hackathon", "local": "startup",
				"nome": "Hackathon de IA", "emoji": "🏆",
				"descricao": "Competição de 24h para criar produto com IA",
				"duracao": 5.0,
				"efeitos": {"fama": 15.0, "impacto": 10.0, "dinheiro": 500.0, "humor": -8.0, "habilidade_criativo": 5.0, "habilidade_tecnico": 5.0},
				"narrativa": "48h sem dormir. Seu time ficou em 2º lugar. A comunidade inteira te conhece agora.",
			})
		tarefas.append({
			"id": "conversar_rafael", "local": "startup",
			"nome": "Mentoria com Rafael", "emoji": "🚀",
			"descricao": "Sessão de mentoria com o cofundador experiente",
			"duracao": 2.0,
			"efeitos": {"relacionamento_rafael": 8.0, "humor": 10.0, "habilidade_criativo": 4.0, "habilidade_tecnico": 4.0, "habilidade_comercial": 4.0},
			"narrativa": "Rafael te mostra onde você está errando e por quê isso é normal. Você sai diferente de quando entrou.",
		})

	# ── HOSPITAL ───────────────────────────────────────────────
	if nivel >= 4:
		tarefas.append({
			"id": "consulta_medica", "local": "hospital",
			"nome": "Consulta médica", "emoji": "🏥",
			"descricao": "Cuidar da saúde preventivamente",
			"duracao": 1.5,
			"efeitos": {"saude": 35.0, "dinheiro": -250.0, "humor": 5.0},
			"narrativa": "Exames em dia, medicação certa. Caro, mas você sai de lá se sentindo uma pessoa nova.",
		})

	return tarefas
