# 🐾 Nodux - Plataforma de Gestão e Autoridade Sanitária Animal

O **Nodux** é um ecossistema projetado para transformar a gestão de pet shops e clínicas veterinárias, focando na soberania dos dados do pet e na automação do atendimento através de fluxos inteligentes.

<br>

## 🚀 Visão do Projeto (v0.5 MVP)
Nesta fase inicial, o objetivo é validar o **Check-in Preditivo** e a **Shadow Account**, permitindo que o tutor acompanhe o serviço em tempo real sem a necessidade de login imediato (Link Lite).

<br>

### 🛠 Diferenciais Técnicos
* **Arquitetura Hexagonal**: Separação clara entre as regras de negócio (Core) e integrações externas (Adapters).
* **Shadow Accounts**: Cadastro rápido de tutores via WhatsApp, facilitando o onboarding.
* **Selo de Autoridade (Bronze/Silver/Gold)**: Validação de registros de saúde por profissionais com CRMV.
* **Integração Financeira**: Fluxo automatizado com Asaas para pagamentos e assinaturas.

<br>

## 🏗 Arquitetura & Documentação
O projeto está amplamente documentado na pasta `/docs`:

* **[Contrato de API]**: Padronização de respostas (Envelopes) e códigos de erro sistêmicos.
* **[Modelagem de Dados]**: Schema relacional otimizado para multi-tenancy.
* **[Diagramas de Sequência]**: Detalhamento dos fluxos de Auth, Check-in e Conversão de Usuários.

<br>

## 📂 Estrutura de Pastas
```
Nodux-backend/
├── .github/              # Actions e Workflows
├── docs/                 # Documentação técnica (v0.5 / v1.0)
│   ├── api/              # ROTES.md
│   ├── architecture/     # Hexagonal Architecture.md e Ports & Adapters
│   ├── db/               # petshop-app.sql e Modelagem de Dados
│   |── diagrams/         # Arquivos Mermaid (.md) de Classes e Sequência
│   └── docker/           # Artefatos de infra
├── src/                  # Código-fonte (Seguindo Hexagonal)
│   │src/main/java/com/nodux/
│   ├── core/                         # O Hexágono (Zero dependências externas)
│   │   ├── domain/                   # Entidades e Value Objects (DDD)
│   │   │   ├── model/                # Ex: User, Pet, Appointment
│   │   │   └── exception/            # Exceções de negócio (DomainException)
│   │   ├── ports/                    # Interfaces de comunicação
│   │   │   ├── in/                   # Use Cases (O que o sistema faz)
│   │   │   └── out/                  # Persistence/Messaging (O que o sistema precisa)
│   │   └── services/                 # Implementação dos Use Cases (Orquestração)
│   ├── infrastructure/               # Os Adaptadores (Lado de fora)
│   │   ├── adapters/
│   │   │   ├── in/web/               # Controllers REST e DTOs de entrada
│   │   │   └── out/persistence/      # Implementações Spring Data JPA / Redis
│   │   └── config/                   # Beans de configuração e Segurança (SOLID)
│   └── shared/                       # Contratos robustos e utilitários genéricos
├── docker-compose.yml    # Setup local (Postgres, Redis)
└── README.md             # Guia Geral do Projeto
```

<br>

## 💻 Stack Tecnológica
* **Backend**: Java 21+ / Spring Boot 3
* **Database**: PostgreSQL (Persistência) e Redis (Cache/Sessão)
* **Integrações**: Asaas (Financeiro), Z-API (WhatsApp)
* **Arquitetura**: Hexagonal (Ports & Adapters)

<br>

## 🛠️ Convenção de Commits - Nodux

Para manter o histórico do projeto organizado e permitir a geração automática de changelogs, seguimos o padrão **Conventional Commits**.

<br>

### 📝 Estrutura do Commit

|Tipo|Descrição|
|----|---------|
|feat|Nova funcionalidade (ex: endpoint de check-in).|
|fix|Correção de um bug.|
|docs|Alterações apenas na documentação.|
|refactor|Mudança no código que não corrige bug nem adiciona feature.|
|build|Mudanças que afetam o sistema de build ou dependências (Maven/Docker).|
|chore|"Atualização de tarefas de build, configurações de IDE ou .gitignore."|
|test|Adição ou correção de testes unitários ou de integração.|
|ci|Mudanças em arquivos de configuração de CI (GitHub Actions).|
|perf|Mudança de código focada em melhorar performance.|

<br>

#### 🎯 Commits de scopo

|Tipo|Descrição|
|----|---------|
|domain| Regras de negócio e entidades.|
|web| Adaptadores de entrada (Controllers/REST).|
|persistence| Adaptadores de saída (JPA/Postgres).|
|auth| Segurança e JWT.|
|infra| Configurações de Docker, Redis ou Cloud.|

<br>

#### 💡 Exemplos Reais do Projeto

```text
- feat(auth): add shadow account support for new tutors

- build(docker): optimize multi-stage build layers in Dockerfile

- refactor(arch): move core domain entities to standard package structure

- chore(env): add asaas and z-api placeholders to .env.example

- fix(persistence): resolve deadlock on appointment status update
```

<br>

#### ⚠️ Regras de Ouro

1. **Use o Imperativo**: "add feature" em vez de "added feature" ou "adicionando feature".
2. **Seja Conciso**: A primeira linha deve ter no máximo 50 caracteres.
3. **Commits Atômicos**: Um commit deve fazer apenas uma coisa. Se você corrigiu um bug e adicionou uma feature, são dois commits diferentes.
4. **Minúsculas**: A descrição deve começar com letra minúscula.

<br>

## Padrões de Branchs 

Para manter a consistência com os nossos Conventional Commits, as branches devem seguir o prefixo do tipo de alteração:

- **feat/nome-da-feature**: Para novas implementações (ex: ```feat/shadow-accounts```).

- **fix/descricao-do-bug**: Para correções (ex: ```fix/jwt-expiration```).

- **chore/tarefa-manutencao**: Para ajustes de infra ou dependências (ex: ```chore/docker-compose-update```).

- **docs/melhoria-documentacao**: Para arquivos Markdown (ex: ```docs/api-contracts```).

<br>

## 🚥 Como rodar o ambiente de desenvolvimento
1. Certifique-se de ter o Docker instalado.
2. Execute: `docker-compose up -d`
3. A API estará disponível em `http://localhost:8080`


---
Desenvolvido com foco em escalabilidade e experiência do usuário (UX) para o setor pet.