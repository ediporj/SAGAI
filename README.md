# SAGAI — Saga com Inteligência Artificial

Simulador de vida mobile feito em Godot 4 onde você é um jovem de 18 anos que sai de casa com R$ 3.000 e a decisão de mudar de vida usando IA. Aluguel vence. Corpo cansa. Oportunidades aparecem — só pra quem está se movendo.

---

## Por que esse jogo existe

Sou fã de jogos offline com progressão — aqueles onde você pode maratonar horas ou ir fazendo de pouquinho em pouquinho, sem depender de ninguém, sem pagar, sem esperar, sem internet. Jogos que existem inteiros, do começo ao fim, só pra você.

Esses jogos sumiram. Não porque o público sumiu — mas porque não são mais lucrativos num mercado que prefere vender energia, passes de batalha e timers. Então resolvi fazer um.

SAGAI começa como um jogo que eu quero jogar e que não existe mais ninguém fazendo. Se servir pra mais alguém, melhor ainda.

---

## A filosofia

Inteligência artificial não é ferramenta de elite. É a maior alavanca de mobilidade social da história — se você souber usar.

SAGAI coloca esse argumento dentro de um jogo. Você é um jvem  começa num bairro duro, sem diploma, sem rede de contatos, sem segurança. O que você tem é tempo, vontade e acesso às mesmas ferramentas de IA que qualquer pessoa no mundo usa. O que você faz com isso define onde você chega.

O jogo não tem caminho certo. Você escolhe entre riqueza, fama ou impacto — e cada escolha tem custo real. Dormir tem preço. Não dormir também. Relacionamentos importam. Habilidades abrem portas. A cidade se expande conforme você cresce.

**Por que estou criando:** porque esse jovem existe. E porque a ficção é uma forma de treinar a realidade.

Há uma geração que chegou tarde demais pra faculdade valer como antes e cedo demais pra saber o que a IA vai fazer com o mercado. SAGAI é um experimento sobre o que acontece quando você coloca essa geração dentro de uma simulação honesta — com pressão financeira, necessidades físicas, relações humanas e a IA como ferramenta, não como solução mágica.

---

## Gameplay

- Movimentação via joystick virtual (mobile) ou WASD/setas (desktop)
- Tarefas disponíveis em cada local — cada uma consome uma slot do dia e afeta seus atributos
- 5 regiões que se abrem conforme o nível de IA sobe (média das três habilidades)
- Sistema de relacionamentos — amizades e romances com NPCs que oferecem benefícios reais
- Eventos aleatórios com escolhas que mudam o rumo da história
- Lojas para comprar itens que melhoram deslocamento e desempenho
- Consequências reais — humor zerado te prende em casa por 2 dias, saúde zerada te manda pro hospital

### Regiões e desbloqueios

| Região | Nível de IA | Locais |
|---|---|---|
| Bairro Popular | 0 | Espelunca, Boteco, Rua, Mercadinho |
| Centro Comercial | 1 | Biblioteca, Café WiFi, Shopping, Parque |
| Distrito Empresarial | 2 | Co-working, Restaurante, Eletrônicos |
| Hub Tecnológico | 3 | Startup Hub, Tech Store, Bar do Hub |
| Área Nobre | 4 | Hospital, Instituto IA, Galeria, Clube Social |

---

## Stack

- **Godot 4.6** · GDScript
- Mobile-first (720×1280)
- Sem assets externos — tudo procedural em código

## Como rodar

```bash
git clone https://github.com/ediporj/SAGAI.git
```

Abra o Godot, clique em **Import**, selecione a pasta `SAGAI/` e abra o projeto. Pressione **F5** para rodar.

---

## Estrutura do projeto

```
SAGAI/
├── assets/          # Mapa, personagem, ícones
├── scenes/          # StartScreen.tscn, Main.tscn
└── scripts/
    ├── Main.gd                # Loop principal, UI, movimentação
    ├── GameState.gd           # Estado global (atributos, dia, dinheiro)
    ├── TaskManager.gd         # Tarefas por local
    ├── EventManager.gd        # Eventos aleatórios e narrativa
    ├── ItemManager.gd         # Itens e lojas
    ├── RelationshipManager.gd # NPCs, amizades, romances
    ├── Joystick.gd            # Joystick virtual
    └── StoryPanel.gd          # Slides de level-up e narrativa
```

---

## Contribuindo

Contribuições são bem-vindas. Veja [CONTRIBUTING.md](CONTRIBUTING.md).

## Licença

MIT — veja [LICENSE](LICENSE).
