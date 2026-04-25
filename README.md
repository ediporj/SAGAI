# SAGAI

**SAGAI** é um jogo de simulação de vida onde você começa com 18 anos, R$ 3.000 e uma ambição: dominar a inteligência artificial e subir na vida.

Explore uma cidade dividida em 5 regiões — do Bairro Popular à Área Nobre — desenvolvendo habilidades em três trilhas: Criativo, Técnico e Comercial. Cada decisão custa tempo e energia. Gerencie humor, saúde, dinheiro, fama e impacto enquanto desbloqueia novos espaços, conhece pessoas e constrói sua trajetória.

Feito em **Godot 4.6**, otimizado para mobile (720×1280).

---

## Gameplay

- **Movimentação** via joystick virtual (mobile) ou WASD/setas (desktop)
- **Tarefas** disponíveis em cada local desbloqueado — cada uma consome uma slot do dia e afeta seus atributos
- **5 regiões** que se abrem conforme o nível de IA sobe (média das três habilidades)
- **Sistema de relacionamentos** — amizades e romances com NPCs que oferecem benefícios
- **Eventos aleatórios** com escolhas que mudam o rumo da história
- **Lojas** para comprar itens que melhoram deslocamento e desempenho
- **Consequências reais** — humor zerado te prende em casa por 2 dias, saúde zerada te manda pro hospital

### Regiões e desbloqueios

| Região | Nível de IA | Locais |
|---|---|---|
| Bairro Popular | 0 | Espelunca, Boteco, Rua, Mercadinho |
| Centro Comercial | 1 | Biblioteca, Café WiFi, Shopping, Parque |
| Distrito Empresarial | 2 | Co-working, Restaurante, Eletrônicos |
| Hub Tecnológico | 3 | Startup Hub, Tech Store, Bar do Hub |
| Área Nobre | 4 | Hospital, Instituto IA, Galeria, Clube Social |

---

## Requisitos

- [Godot 4.6](https://godotengine.org/download/) (Forward+)

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
    ├── Main.gd              # Loop principal, UI, movimentação
    ├── GameState.gd         # Estado global (atributos, dia, dinheiro)
    ├── TaskManager.gd       # Tarefas por local
    ├── EventManager.gd      # Eventos aleatórios e narrativa
    ├── ItemManager.gd       # Itens e lojas
    ├── RelationshipManager.gd  # NPCs, amizades, romances
    ├── Joystick.gd          # Joystick virtual
    └── StoryPanel.gd        # Slides de level-up e narrativa
```

---

## Contribuindo

Contribuições são bem-vindas. Veja [CONTRIBUTING.md](CONTRIBUTING.md) para saber como começar.

---

## Licença

MIT — veja [LICENSE](LICENSE).
