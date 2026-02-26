# 🐾 Nodux - Plataforma de Gestão e Autoridade Sanitária Animal

O **Nodux** é um ecossistema projetado para transformar a gestão de pet shops e clínicas veterinárias, focando na soberania dos dados do pet e na automação do atendimento através de fluxos inteligentes.

## 🚀 Visão do Projeto (v0.5 MVP)
Nesta fase inicial, o objetivo é validar o **Check-in Preditivo** e a **Shadow Account**, permitindo que o tutor acompanhe o serviço em tempo real sem a necessidade de login imediato (Link Lite).

### 🛠 Diferenciais Técnicos
* **Arquitetura Hexagonal**: Separação clara entre as regras de negócio (Core) e integrações externas (Adapters).
* **Shadow Accounts**: Cadastro rápido de tutores via WhatsApp, facilitando o onboarding.
* **Selo de Autoridade (Bronze/Silver/Gold)**: Validação de registros de saúde por profissionais com CRMV.
* **Integração Financeira**: Fluxo automatizado com Asaas para pagamentos e assinaturas.

## 🏗 Arquitetura & Documentação
O projeto está amplamente documentado na pasta `/docs`:

* **[Contrato de API]**: Padronização de respostas (Envelopes) e códigos de erro sistêmicos.
* **[Modelagem de Dados]**: Schema relacional otimizado para multi-tenancy.
* **[Diagramas de Sequência]**: Detalhamento dos fluxos de Auth, Check-in e Conversão de Usuários.

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
├── docker-compose.yml    # Setup local (Postgres, Redis)
└── README.md             # Guia Geral do Projeto
```

## 💻 Stack Tecnológica
* **Backend**: Java 21+ / Spring Boot 3
* **Database**: PostgreSQL (Persistência) e Redis (Cache/Sessão)
* **Integrações**: Asaas (Financeiro), Z-API (WhatsApp)
* **Arquitetura**: Hexagonal (Ports & Adapters)

## 🚥 Como rodar o ambiente de desenvolvimento
1. Certifique-se de ter o Docker instalado.
2. Execute: `docker-compose up -d`
3. A API estará disponível em `http://localhost:8080`

---
Desenvolvido com foco em escalabilidade e experiência do usuário (UX) para o setor pet.