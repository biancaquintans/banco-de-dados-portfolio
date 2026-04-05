 Dicionário de Dados — db_streaming

---

Tabela: `planos`

Armazena os tipos de planos de assinatura disponíveis na plataforma.

| Coluna | Tipo | Restrições | Descrição |
|--------|------|------------|-----------|
| `id_plano` | INT | PK, AUTO_INCREMENT | Identificador único do plano |
| `tipo_plano` | ENUM | NOT NULL | Tipo: 'Premium', 'Padrão', 'Padrão com Anúncios' |
| `valor` | DECIMAL(10,2) | CHECK > 0 | Valor mensal do plano em reais |
| `tipo_pagamento` | VARCHAR(50) | — | Forma de pagamento aceita |

---

Tabela: `usuarios`

Armazena os dados dos assinantes da plataforma.

| Coluna | Tipo | Restrições | Descrição |
|--------|------|------------|-----------|
| `id_usuario` | INT | PK, AUTO_INCREMENT | Identificador único do usuário |
| `nome` | VARCHAR(100) | NOT NULL | Nome completo do usuário |
| `email` | VARCHAR(100) | UNIQUE, CHECK LIKE '%@%' | E-mail de login |
| `cpf` | CHAR(11) | UNIQUE | CPF sem pontuação |
| `telefone` | VARCHAR(15) | — | Telefone de contato |
| `id_plano` | INT | FK → planos(id_plano) | Plano ativo do usuário |

---

Tabela: `catalogo`

Armazena filmes e séries disponíveis na plataforma.

| Coluna | Tipo | Restrições | Descrição |
|--------|------|------------|-----------|
| `id_item` | INT | PK, AUTO_INCREMENT | Identificador único do conteúdo |
| `titulo` | VARCHAR(150) | NOT NULL | Título do filme ou série |
| `classificacao_indicativa` | VARCHAR(10) | NOT NULL | Classificação etária (L, 10, 12, 14, 16, 18) |
| `tipo` | ENUM | NOT NULL | 'Filme' ou 'Série' |
| `duracao_ou_episodios` | INT | — | Duração em minutos (filmes) ou nº de episódios (séries) |
| `genero` | VARCHAR(50) | — | Gênero do conteúdo |

---

Tabela: `historico_visualizacao`

Registra cada vez que um usuário assiste a um conteúdo.

| Coluna | Tipo | Restrições | Descrição |
|--------|------|------------|-----------|
| `id_historico` | INT | PK, AUTO_INCREMENT | Identificador único do registro |
| `id_usuario` | INT | FK → usuarios(id_usuario) | Usuário que assistiu |
| `id_item` | INT | FK → catalogo(id_item) | Conteúdo assistido |
| `data_visto` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Data e hora da visualização |

---

 Tabela: `favoritos`

Armazena a lista de favoritos de cada usuário.

| Coluna | Tipo | Restrições | Descrição |
|--------|------|------------|-----------|
| `id_favorito` | INT | PK, AUTO_INCREMENT | Identificador único do favorito |
| `id_usuario` | INT | FK → usuarios(id_usuario) | Usuário dono da lista |
| `id_item` | INT | FK → catalogo(id_item) | Conteúdo favoritado |

---

Tabela: `logs_sistema`

Registra eventos automáticos gerados pelas triggers.

| Coluna | Tipo | Restrições | Descrição |
|--------|------|------------|-----------|
| `id_log` | INT | PK, AUTO_INCREMENT | Identificador único do log |
| `descricao` | TEXT | — | Descrição do evento ocorrido |
| `data_evento` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Data e hora do evento |

---

Relacionamentos

```
planos (1) ──── (N) usuarios
usuarios (1) ──── (N) historico_visualizacao
catalogo (1) ──── (N) historico_visualizacao
usuarios (1) ──── (N) favoritos
catalogo (1) ──── (N) favoritos
```

---

Justificativa das Escolhas

Por que separar `planos` em uma tabela própria?
Em vez de salvar o tipo do plano diretamente no cadastro do usuário, optamos por uma tabela separada. Isso garante que qualquer alteração de preço ou nome do plano seja feita em um único lugar, refletindo automaticamente para todos os usuários vinculados. Evita redundância e facilita a manutenção.

Por que usar ENUM em `tipo_plano` e `tipo`?
Os campos `tipo_plano` (planos) e `tipo` (catálogo) têm valores fixos e conhecidos — nunca existirá um tipo de plano fora das três opções, nem um conteúdo que não seja Filme ou Série. O ENUM garante essa integridade diretamente no banco, sem depender da aplicação para validar.

Por que `historico_visualizacao` e `favoritos` são tabelas separadas?
Assistir a um conteúdo e favoritá-lo são ações com naturezas diferentes. O histórico é automático, acumulativo e tem timestamp. Os favoritos são uma escolha manual do usuário e não precisam de data. Unir os dois em uma tabela geraria colunas nulas e lógica confusa.

Por que `duracao_ou_episodios` em vez de duas colunas?
Para filmes, esse campo representa a duração em minutos. Para séries, representa o número de episódios. A decisão foi pragmática: evitar uma coluna sempre nula (se fossem duas separadas, uma delas estaria vazia em todo registro). O campo `tipo` já indica como interpretar o valor.

Por que `logs_sistema` em vez de confiar só na aplicação?
Logs gerados por triggers no banco são mais confiáveis do que logs feitos pela aplicação, pois registram o evento independentemente de qual sistema ou usuário fez a operação. Se alguém deletar um usuário diretamente pelo MySQL Workbench, o log ainda será gerado.

Por que `cpf` como CHAR(11) e não VARCHAR?
O CPF tem sempre exatamente 11 dígitos. Usar CHAR é mais eficiente para campos de tamanho fixo, e armazenamos sem pontuação para facilitar buscas e comparações.

Por que `email` com constraint CHECK LIKE '%@%'?
É uma validação mínima para evitar cadastros claramente inválidos diretamente no banco. Não substitui uma validação completa na aplicação, mas serve como segunda camada de proteção.

Por que usar AUTO_INCREMENT em todas as PKs?
Garante que cada registro tenha um identificador único gerado automaticamente, sem risco de colisão. É a prática mais comum em sistemas relacionais onde a chave não precisa ter significado de negócio.
