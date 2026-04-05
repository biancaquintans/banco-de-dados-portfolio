# banco-de-dados-portfolio
Projeto desenvolvido para a disciplina de Banco de Dados. Simula o backend de uma plataforma de streaming com gerenciamento de usuários, planos de assinatura, catálogo de conteúdos, histórico de visualizações e filmes e séries favoritas.
Escolhemos esse tema porque vivemos na era dos streamings e há muitos serviços desse tipo no cotidiano. É interessante abordar o alto volume de dados de usuários, como cadastros, logins e avaliações, e aplicar conceitos práticos de banco de dados.

Tema Escolhido: Plataforma de Streaming de Filmes e séries — inspirada em serviços como Netflix e Prime Video. O projeto simula um serviço de streaming de filmes e séries, armazenando informações de usuários, catálogo, episódios planos pagos e categorias. Os dados são organizados para permitir consultas, recomendações de conteúdo e listagem por gênero. 


Estrutura do Repositório


banco-de-dados-portfolio/
│
├── README.md
├── docs/
│   └── dicionario_dados.md
├── modelagem/
│   └── diagrama_er.png
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   ├── 03_constraints.sql
│   └── 04_updates_deletes.sql
├── procedures_triggers/
│   └── 01_triggers.sql
├── views/
│   └── 01_views.sql
├── dados_teste/
│   └── 01_insere_dados.sql
├── scripts_instalacao/
│   └── 01_setup_banco.sql
├── consultas_avancadas/
│   └── consultas_streaming.sql
└── reflexoes/
    └── aprendizados.md



 Diagrama ER

> Ver arquivo `/modelagem/diagrama_er.png`

Entidades principais:
- `planos` → tipos de assinatura disponíveis
- `usuarios` → assinantes da plataforma
- `catalogo` → filmes e séries disponíveis
- `historico_visualizacao` → o que cada usuário assistiu
- `favoritos` → lista de favoritos por usuário
- `logs_sistema` → auditoria automática de eventos


Como Instalar o Banco

Pré-requisitos
- MySQL 8.0+
- MySQL Workbench ou terminal

Passo a passo

```bash
# 1. Abra o MySQL
mysql -u root -p

# 2. Execute o script de criação do banco
SOURCE scripts_instalacao/01_setup_banco.sql;

# 3. Execute a criação das tabelas
SOURCE sql/01_create_tables.sql;

# 4. Execute as constraints
SOURCE sql/03_constraints.sql;

# 5. Insira os dados de teste
SOURCE dados_teste/01_insere_dados.sql;

# 6. Crie as views
SOURCE views/01_views.sql;

# 7. Crie procedures e triggers
SOURCE procedures_triggers/01_triggers.sql;
```

---

Como Rodar os Scripts

Execute os arquivos na seguinte ordem no MySQL Workbench
(File > Open SQL Script) ou pelo terminal:

| Ordem | Arquivo | O que faz |
|-------|---------|-----------|
| 1º | `scripts_instalacao/01_setup_banco.sql` | Cria o banco de dados |
| 2º | `sql/01_create_tables.sql` | Cria todas as tabelas |
| 3º | `sql/03_constraints.sql` | Adiciona as constraints |
| 4º | `dados_teste/01_insere_dados.sql` | Insere os dados de teste |
| 5º | `views/01_views.sql` | Cria as views |
| 6º | `procedures_triggers/01_triggers.sql` | Cria triggers e procedures |
| 7º | `consultas_avancadas/consultas_streaming.sql` | Consultas prontas para uso |

---

Exemplos de Consultas

 Usuários com seus planos
```sql
SELECT u.nome, u.email, p.tipo_plano, p.valor
FROM usuarios u
INNER JOIN planos p ON u.id_plano = p.id_plano;
```

Conteúdos mais assistidos
```sql
SELECT c.titulo, COUNT(h.id_historico) AS total_views
FROM catalogo c
LEFT JOIN historico_visualizacao h ON c.id_item = h.id_item
GROUP BY c.titulo
ORDER BY total_views DESC
LIMIT 10;
```

Faturamento estimado por plano
```sql
SELECT p.tipo_plano, COUNT(u.id_usuario) AS assinantes,
       (COUNT(u.id_usuario) * p.valor) AS faturamento
FROM planos p
LEFT JOIN usuarios u ON p.id_plano = u.id_plano
GROUP BY p.tipo_plano, p.valor;
```

---

 Views Disponíveis

| View | Descrição |
|------|-----------|
| `vw_conteudo_mais_visto` | Ranking de conteúdos por visualizações |
| `vw_faturamento_estimado` | Faturamento mensal estimado por plano |
| `vw_usuarios_por_plano` | Relatório de Usuários por Plano |
| `vw_catalogo_por_genero` | Relatório de Catálogo por Gênero |



```sql
SELECT * FROM vw_conteudo_mais_visto;
SELECT * FROM vw_faturamento_estimado;
SELECT * FROM vw_usuarios_por_plano;
SELECT * FROM vw_catalogo_por_genero;
```

---

Procedures Disponíveis

| Procedure | Descrição |
|-----------|-----------|
| `sp_cadastrar_usuario` | Cadastra usuário validando se o plano existe |
| `sp_relatorio_assinantes` | Relatório de assinantes e faturamento por plano |
| `sp_registrar_visualizacao` | Registra visualização com validação de existência |

```sql
CALL sp_cadastrar_usuario('Nome', 'email@email.com', '00011122233', '11999990000', 1);
CALL sp_relatorio_assinantes();
CALL sp_registrar_visualizacao(1, 3);
```

---

Triggers Configuradas

| Trigger | Evento | Descrição |
|---------|--------|-----------|
| `tr_log_novo_usuario` | AFTER INSERT em usuarios | Registra log de novo cadastro |
| `tr_log_exclusao_usuario` | BEFORE DELETE em usuarios | Registra log antes de excluir usuário |
| `tr_log_visualizacao` | AFTER INSERT em historico_visualizacao | Registra log de cada visualização |

---

 Aprendizados

> Ver arquivo `/reflexoes/aprendizados.md`

---

Autores

Projeto desenvolvido como portfólio de Banco de Dados de um sistema de Streaming de filmes e séries. 
Elaborado por: Bianca Quintans, João Pedro e Phelipe Souza. 
Março de 2026
