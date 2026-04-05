Reflexões e Aprendizados — db_streaming

Introdução

O desenvolvimento deste projeto prático teve como objetivo consolidar os conhecimentos adquiridos ao longo da disciplina de Banco de Dados, aplicando-os em um cenário inspirado em plataformas reais de streaming. Ao longo do processo, foi possível vivenciar não apenas os aspectos técnicos da modelagem e manipulação de dados, mas também compreender as decisões de design que tornam um banco de dados eficiente, íntegro e sustentável. 
Durante o desenvolvimento, aprendemos a modelar um banco de dados desde o início, criando entidades, relacionamentos e chaves primárias. Também praticamos SQL e entendemos como estruturar dados com eficiência.


Modelagem de Dados e Normalização

A etapa de modelagem foi, sem dúvida, a mais reflexiva do projeto. Definir as entidades, seus atributos e os relacionamentos entre elas exigiu análise cuidadosa do domínio do problema. Um exemplo concreto foi a decisão de separar `historico_visualizacao` de `favoritos` em tabelas distintas: embora ambas relacionem usuários a conteúdos, representam semânticas completamente diferentes uma é um registro automático e acumulativo de comportamento, enquanto a outra é uma escolha explícita do usuário. Unificá-las violaria o princípio da responsabilidade única e introduziria colunas nulas desnecessárias, ferindo a Terceira Forma Normal (3FN).

Essa experiência reforçou que uma boa modelagem não se resume a criar tabelas, mas a compreender profundamente o negócio que está sendo representado.



Integridade Referencial e Chaves Estrangeiras

A implementação das chaves estrangeiras (FK) evidenciou na prática o conceito de integridade referencial. Ao tentar executar um `DELETE` em `catalogo` com registros vinculados em `historico_visualizacao`, o banco de dados rejeitou a operação — comportamento esperado e desejável, pois impede a existência de registros órfãos.

Esse mecanismo também impõe uma ordem lógica na inserção dos dados: os `planos` precisam existir antes dos `usuarios`, assim como o `catalogo` deve estar populado antes do `historico_visualizacao`. Compreender essa dependência entre entidades é essencial para a correta manutenção de qualquer banco de dados relacional.



Consultas com JOIN

O estudo e a aplicação dos diferentes tipos de JOIN foram fundamentais para a construção de consultas significativas. O `INNER JOIN` mostrou-se adequado para situações em que se deseja apenas os registros com correspondência nos dois lados da relação — como listar somente os usuários que de fato possuem um plano vinculado. Já o `LEFT JOIN` revelou-se indispensável para relatórios analíticos, pois permite retornar todos os registros da tabela principal mesmo quando não há correspondência na tabela secundária — como exibir todos os planos, inclusive aqueles sem nenhum assinante cadastrado.

A diferença entre esses dois tipos de junção, que inicialmente pareceu sutil, mostrou-se decisiva para a corretude dos relatórios gerados pelas views do projeto.


Subqueries e Consultas Avançadas

A construção das consultas avançadas demonstrou que a linguagem SQL vai muito além das operações básicas de CRUD. O uso de subqueries permitiu resolver problemas que não seriam possíveis com uma única instrução simples, como identificar usuários que nunca assistiram a nenhum conteúdo utilizando `NOT IN` com uma subquery ou filtrar aqueles com comportamento acima da média de visualizações utilizando subquery dentro da cláusula `HAVING`.

Esses recursos evidenciam o poder expressivo do SQL como linguagem declarativa, onde o foco está no "o quê" se deseja obter, e não no "como" percorrer os dados.



Stored Procedures e Validação de Dados

A criação das stored procedures acrescentou uma camada de lógica de negócio diretamente no banco de dados. A utilização de `IF NOT EXISTS` combinada com `SIGNAL SQLSTATE` permitiu implementar validações explícitas, retornando mensagens de erro claras e compreensíveis em vez de mensagens genéricas geradas automaticamente pelo MySQL.

Essa abordagem aproxima o banco de dados do conceito de serviço: ao encapsular regras de validação em procedures, garante-se que qualquer aplicação ou usuário que interaja com o banco estará sujeito às mesmas verificações, independentemente da camada de acesso utilizada.



Triggers e Auditoria Automática

As triggers introduziram o conceito de automação reativa no banco de dados. Ao configurar eventos `AFTER INSERT` e `BEFORE DELETE` nas tabelas principais, o sistema passou a registrar automaticamente na tabela `logs_sistema` qualquer inserção ou remoção de usuários, além de cada nova visualização registrada.

Do ponto de vista acadêmico, as triggers ilustram o princípio de que a integridade e a rastreabilidade dos dados não devem depender exclusivamente da aplicação cliente. Um log gerado por trigger é mais confiável porque é acionado diretamente pelo banco, independentemente de quem ou qual sistema realizou a operação.



Dificuldades Encontradas

Ao longo do desenvolvimento, algumas dificuldades merecem registro por seu valor formativo:

- Ordem de execução dos scripts: a dependência entre tabelas via FK exige que a criação e a inserção de dados sigam uma sequência lógica rigorosa, o que não é evidente em um primeiro contato com bancos relacionais.
- DELETE com integridade referencial: operações de remoção em tabelas pai falham quando existem registros filhos vinculados, sendo necessário compreender quando usar `ON DELETE CASCADE` e quando tratar a remoção manualmente.
- Distinção entre LEFT JOIN e INNER JOIN: a escolha incorreta entre esses tipos de junção pode produzir resultados silenciosamente errados, sem gerar nenhum erro — o que torna esse ponto especialmente crítico em relatórios analíticos.
- Subqueries dentro de HAVING: exigiu compreensão aprofundada da ordem de execução das cláusulas SQL (`FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY`).



Considerações Finais e Próximos Passos

Este projeto representou uma oportunidade concreta de aplicar, de forma integrada, os principais conceitos estudados na disciplina: modelagem relacional, normalização, integridade referencial, consultas avançadas, automação com triggers e encapsulamento com procedures.

Como evolução natural do que foi desenvolvido, identificam-se os seguintes aprimoramentos possíveis:

- Indexação: adicionar índices nas colunas mais consultadas, como `id_usuario` e `id_item`, para otimizar o desempenho em tabelas com grande volume de dados.
- Soft delete: substituir o `DELETE` físico de usuários por uma coluna `ativo BOOLEAN`, preservando o histórico de dados e mantendo a rastreabilidade.
- Particionamento: explorar o particionamento da tabela `historico_visualizacao` por data, dado seu potencial de crescimento acelerado em um cenário real.
- Procedure de relatório mensal: desenvolver uma procedure que consolide automaticamente os dados de faturamento, visualizações e novos cadastros de um determinado mês.
