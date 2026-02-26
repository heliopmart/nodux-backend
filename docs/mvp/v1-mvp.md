
```
Legenda: 

Tutores: Donos de animais de estimação;
<app>: Nodux;
Selo de CRMV: Se refere ao estádo de uma vacina ou a um prontuario que foi emitido por um proficional verificado;

```

# <app> v1 - Mínimo Produto Viável (Lean MVP)


## 1. Introdução e Visão Estratégica

O projeto <app> não é apenas um software de gestão, mas um ecossistema de autoridade sanitária animal desenhado para resolver a fragmentação de dados no mercado pet brasileiro. A visão estratégica baseia-se no modelo B2B2C, onde o software é inserido no cotidiano operacional de pequenos e médios estabelecimentos como uma ferramenta de gestão indispensável e gratuita (ou de baixo custo), atuando como um "Cavalo de Troia" para a aquisição orgânica de tutores. O objetivo final é centralizar o histórico clínico do animal, garantindo que o tutor seja o proprietário real da informação e que os estabelecimentos possuam uma ferramenta de agendamento e fluxo financeiro que minimize a inadimplência e maximize a eficiência do tempo de serviço.

## 2. O Problema e a Oportunidade de Mercado

Atualmente, o pequeno lojista pet sofre com a "morte por planilha" e a desorganização de agendas via WhatsApp, o que gera o fenômeno do no-show (cliente que marca e não aparece) e a perda de receita por falta de controle financeiro. Do lado do tutor, existe a "cegueira de dados": as informações de saúde do animal estão espalhadas em papéis térmicos que apagam ou em bancos de dados fechados de clínicas particulares. A oportunidade reside na criação de um ponto de confiança centralizado. Existe um vácuo tecnológico entre os apps "meia-boca" que são apenas agendas manuais e os grandes ecossistemas fechados de planos de saúde. O <app> ocupa esse espaço ao oferecer validação de autoridade (Selo de CRMV) e automação de processos, transformando a gestão burocrática em um ativo de marketing para o pet shop.

## 3. Escopo do Produto: O que entra e o que fica para depois

O escopo do MVP está focado no mínimo necessário para a operação financeira e a autoridade de dados. No "In" (dentro), teremos a gestão completa de múltiplos perfis (Multi-tenancy) para garantir que cada pet shop opere de forma isolada e segura. O sistema deve contemplar o motor de agendamentos, permitindo tanto reservas avulsas quanto a configuração de recorrências para planos de assinatura. A integração com o Asaas é mandatória nesta fase para viabilizar a cobrança automática e o split de pagamento. Do lado do tutor, o escopo contempla o histórico de saúde com selos de autenticidade e a visualização preditiva de status de serviços.

No "Out" (fora), para garantir agilidade, não incluiremos agora: gestão de estoque complexa (venda de rações e acessórios), e-commerce integrado, inteligência artificial para otimização de agenda (faremos apenas por regras manuais) e ferramentas de marketing avançado.

## 4. Proposta de Valor por Segmento

A proposta de valor para o Pet Shop reside na redução drástica da inadimplência e do no-show através da automação de cobranças e lembretes, além da profissionalização do atendimento que gera fidelização orgânica. Para o Tutor, o valor é a conveniência de ter a vida do pet no bolso, a segurança de um histórico clínico que não se apaga e a transparência de saber exatamente em que etapa do banho o animal está. Já para o Veterinário, o sistema oferece o que ele mais precisa para cobrar o preço justo: credibilidade. Ter um registro assinado digitalmente e validado pela plataforma eleva o status do profissional de "aplicador de vacina" para "autoridade sanitária".

## 5. Diferenciais Competitivos de Lançamento

O grande diferencial que nos afasta da concorrência "meia-boca" é o Selo de Autenticidade Gradual e o Check-in Preditivo. Enquanto outros apps são apenas repositórios passivos, o <app> atua como um validador. Além disso, a estratégia de Shadow Accounts garante que o lojista não perca tempo convencendo o cliente a baixar um app no balcão; o cliente é atraído pela utilidade imediata da notificação de status e converte-se em usuário por vontade própria ao perceber o valor do histórico acumulado.

## 6. Estratégia de Conversão e Modelo de Monetização

A nossa conversão de usuários não será baseada em anúncios caros de Instagram, mas sim na utilidade compulsória gerada pelo cotidiano. A estratégia baseia-se no fluxo de notificação por utilidade: ao deixar o animal no pet shop, o tutor recebe um link via WhatsApp para acompanhar o status do serviço. Ao clicar, ele entra em uma experiência lite que resolve sua ansiedade imediata sem exigir login. A conversão em usuário real ocorre no "momento de valor", quando o sistema oferece o salvamento vitalício da carteira de vacinação ou o acesso a documentos assinados pelo veterinário; para não perder o dado, o usuário ativa sua conta, transformando um cliente ocasional do pet shop em um usuário permanente do ecossistema <app>. Quanto ao modelo financeiro, adotaremos uma postura de subsídio agressivo para dominar o mercado: custearemos integralmente a operação na fase inicial, oferecendo acesso completo e gratuito para novos pet shops e clínicas, eliminando qualquer barreira financeira de entrada. Não cobraremos taxas adicionais sobre transações, permitindo que o lojista lide apenas com as taxas nativas do Asaas, o que posiciona o <app> como a solução de menor custo operacional do setor. A sustentabilidade e o lucro virão com a maturação da base, através da introdução de planos Pro e Premium, que oferecerão funcionalidades avançadas e novas ferramentas exclusivas mediante assinatura fixa, capturando valor conforme os estabelecimentos escalam sua utilização.

## 7. Funcionalidades Críticas (User Stories do MVP)

- **Perspectiva do Pet Shop (B2B)**
    1. Acesso Rápido: Como Dono de Pet Shop, eu quero visualizar um dashboard de "Previstos para Hoje" ao abrir o sistema, para que eu possa dar entrada nos pets agendados com apenas um clique.

    2. Automação Financeira: Como Gestor, eu quero configurar planos de assinatura recorrentes integrados ao Asaas, para que o sistema gere cobranças automaticamente e bloqueie a agenda de clientes inadimplentes.

    3. Operação Limpa: Como Banhador/Tosador, eu quero alterar o macro-status do pet (Entrada -> Em Atendimento -> Pronto) em uma tela de baixo atrito, para que o tutor seja notificado sem que eu precise parar o meu trabalho técnico.

- **Perspectiva do Tutor (B2C)**
    1. Conveniência Instantânea: Como Tutor, eu quero receber um link único via WhatsApp após o check-in do meu pet, para que eu acompanhe o progresso do banho/tosa em tempo real sem precisar baixar o app de imediato.

    2. Soberania de Dados: Como Tutor, eu quero visualizar minha carteira de vacinação digital (com selos de autenticidade), para que eu tenha um histórico confiável para apresentar em condomínios ou viagens.

    3. Conversão Orgânica: Como Usuário "Shadow", eu quero converter minha conta temporária em uma conta definitiva com um clique, para que eu não perca o histórico de saúde que o pet shop já cadastrou.

- **Perspectiva do Veterinário**
    1. Assinatura de Autoridade: Como Veterinário, eu quero registrar vacinas e consultas vinculando meu CRMV validado, para que o documento gerado tenha o selo de autenticidade máxima ("Selo Ouro").

## 8. Métricas de Sucesso (KPIs)

|Métrica| O que mede Meta | (MVP - 3 meses) |
|-------|----------------|------------------|
| B2B Activation | Número de Pet Shops que realizaram pelo menos 10 check-ins. | 10 estabelecimentos | 
| Shadow Conversion | % de tutores que clicaram no link do WhatsApp e criaram conta. | > 25% |
| Retention (Tutor) | % de usuários B2C que abrem o app 15 dias após o primeiro serviço. | > 40% | 
| Data Quality | Proporção de registros com "Selo Ouro" vs "Selo Bronze". | 30% Gold | 
| Inadimplência Real | Redução de faltas (no-show) por conta da gestão de planos. | < 10% de faltas | 

## 9. O "Pulo do Gato" Técnico (Rastreabilidade de Valor)

Para um engenheiro de planejamento, o KPI técnico mais importante aqui será o MTTU (Mean Time to Utility): quanto tempo o tutor leva, desde que recebe o link no WhatsApp, até ver o status do pet. Se esse tempo for maior que 3 segundos (devido a lentidão no Java ou excesso de processamento no Flutter), a conversão vai pro ralo. No nosso planejamento, isso significa que a rota de "Visualização Lite" tem que ser a mais otimizada do sistema, com cache agressivo e zero autenticação pesada no primeiro hit.

---

# Requisitos do sistema

## Requisitos Funcionais (RF)

- **Módulo B2B (Pet Shop & Clínica)**
    - **Gestão de Tenancy**: Isolamento completo de dados por loja. Uma unidade não pode, sob hipótese alguma, acessar clientes ou financeiro de outra.

    - **Controle de Acesso (RBAC)**: Diferentes níveis de permissão para Dono, Veterinário, Banhador e Recepcionista.

    - **Dashboard de Previstos**: Tela principal com a lista de pets agendados para o dia, permitindo check-in rápido (um clique) para clientes frequentes.

    - **Check-in de Novos Clientes**: Fluxo de cadastro simplificado (Nome + Celular + Pet) que gera automaticamente uma Shadow Account.

    - **Motor de Agendamento**: Gestão de slots de tempo baseada na disponibilidade de recursos (mesas de tosa, banheiras) e profissionais.

    - **Gestão Financeira e Assinaturas**: Integração nativa com Asaas para cobranças recorrentes, emissão de boletos/Pix e controle automático de inadimplência.

    - **Prontuário de Autoridade**: Registro de vacinas e procedimentos clínicos com assinatura digital vinculada ao CRMV do profissional.


- **Módulo B2C (Tutor)**
    - **Experiência Lite (Web-View)**: Acesso ao status do pet em tempo real através de um link único enviado via WhatsApp, sem necessidade de login inicial.

    - **Conversão de Conta**: Funcionalidade de "Reivindicar Histórico", onde o usuário transforma sua Shadow Account em uma conta definitiva com senha.

    - **Timeline de Saúde**: Visualização cronológica de eventos com selos de autenticidade (Bronze, Prata e Ouro).

    - **Carteira de Vacinação Offline**: Cache local dos documentos sanitários para apresentação em locais sem sinal de internet.

    - **Agendamento Self-Service**: Interface para escolher serviço, profissional e horário baseado na agenda real do pet shop.

## Requisitos Não Funcionais (RNF)

- **Segurança (LGPD)**: Criptografia de dados sensíveis em repouso (AES-256) e em trânsito (TLS 1.3). Trilhas de auditoria para alteração em prontuários médicos.

- **Escalabilidade Horizontal**: O backend em Java deve ser stateless (sem estado), permitindo rodar múltiplas instâncias atrás de um Load Balancer.

- **Disponibilidade**: Meta de 99.9% de uptime para as APIs críticas de check-in e consulta de vacinas.

- **Observabilidade**: Implementação de logs estruturados e rastreamento de requisições com correlation-id entre Flutter e Java.

- **Baixa Latência**: Respostas de leitura de dashboard e timeline devem ocorrer em menos de 200ms.

- **Resiliência Financeira**: Uso de filas de mensageria para processar Webhooks de pagamento, garantindo que nenhuma baixa de fatura se perca em caso de instabilidade externa.


## Stack Técnico e Tecnologias

- **Backend**: Java 21+ com Spring Boot 3.x. É o "canhão" que discutimos. Usaremos Spring Security (OAuth2/JWT) para a identidade única e Spring Data JPA para persistência.

- **Frontend**: Flutter. Uma única base de código para Web (Desktop do Pet Shop), Android e iOS (App do Tutor).

- **Banco de Dados Principal**: PostgreSQL. Pela robustez, suporte a JSONB (para dados flexíveis de exames) e facilidade de isolamento por schemas ou tenant_id.

- **Cache e Mensageria**: Redis para cache de tokens de acesso efêmero e RabbitMQ (ou Redis Pub/Sub para o MVP) para processar os webhooks do Asaas.

- **Persistência Local (Mobile)**: Isar ou Hive. Bancos NoSQL rápidos para o Flutter garantir o funcionamento offline da carteira de vacinas.

## Hospedagem e Infraestrutura (DevOps)

- **Provedor de Cloud**: AWS (usando instâncias EC2 ou App Runner para o Java) ou Railway/Render para uma abordagem mais lean no início.

- **Banco de Dados Gerenciado**: RDS (AWS) ou o banco nativo da plataforma de deploy escolhida, com backups diários automáticos.

- **Armazenamento de Arquivos (Fotos/PDFs)**: AWS S3 com políticas de acesso privado e CDN (CloudFront) para entrega rápida das fotos dos pets.

- **CI/CD: GitHub Actions. Automação completa**: deu push na main, o sistema roda os testes JUnit e faz o deploy automático.

- **Monitoramento**: Sentry para captura de erros em tempo real no Flutter e no Java, e Prometheus/Grafana para métricas de saúde do servidor.

## Integrações de Terceiros

- **Financeiro**: Asaas API (Pagamentos, Assinaturas, Split e Antecipação).

- **Comunicação**: WhatsApp Business API (via provedores como Twilio ou Z-API para envio de links de check-in).

- **Processamento de Documentos**: Google Vision API ou AWS Textract para o OCR das fotos de carteiras de vacina antigas.

---

# Fase de Desenvolvimento (O Custo da Criação)

Nesta fase, o custo é quase 100% "Sweat Equity".

- **IDE & Ferramentas**: $0 (IntelliJ Community, VS Code, Docker Desktop).
- **Domínio (.com.br)**: R$ 40,00/ano (Registro.br).
- **Infra Local**: $0 (Docker rodando Postgres, Redis e RabbitMQ).
- **Auth**: $0 (Implementada via Spring Security).

**Total Estimado**: R$ 5,00 - R$ 10,00 / mês (apenas a diluição do domínio).

# Produção: O Primeiro "Cavalo de Tróia" (MVP)

Aqui o sistema sai da sua máquina. O objetivo é gastar o mínimo para manter um pet shop real rodando com uns 100 tutores.

| Item | AWS | Azure | Custo Mensal (Est.) |
|------|-----|-------|---------------------|
| Backend (Java) | App Runner (0.5 vCPU / 1GB) | Container Apps (Consumo) | $15.00 - $25.00 |
| Banco de Dados | RDS (Postgres t4g.micro) | Azure DB (Burstable B1ms) | $18.00 - $25.00 |
| Storage (Fotos) | S3 (Standard) | Blob Storage (Hot) | $1.00 - $3.00 | 
| DNS/SSL | Route 53 + ACM | Azure DNS + Certificado | $1.00 - $5.00 |
| WhatsApp API | VPS (Luz/Z-API) | VPS (Luz/Z-API) | ~R$ 120,00 | 
| Redis | Instanciado na maquina | Instanciado na maquina | +~ $5,00 |

**Total Estimado** (Câmbio R$ 5,00): R$ 350,00 a R$ 480,00 / mês.

# Produção em Escala (50+ Pet Shops / 5.000+ Tutores)

| Recurso | AWS (Escala) | Azure (Escala) | Est. Mensal (USD) |
|---------|--------------|----------------|-------------------|
| Computação|ECS on Fargate (Auto-scaling)|Container Apps (Dedicated)|$100.00 - $200.00|
| Banco de Dados|RDS Aurora (Postgres Serverless)|Azure DB (General Purpose)|$80.00 - $150.00|
| Cache (Redis)|ElastiCache (t4g.micro)|Azure Cache for Redis|$20.00 - $40.00|
| Transferência|CloudFront (Data Egress)|CDN (Data Out)|$10.00 - $40.00|
| WhatsApp API|Provedor API Oficial (Z-API/Twilio)|Provedor API Oficial|R$ 600,00 - R$ 1.200,00|

**Total Estimado** (Câmbio R$ 5,00): R$ 2.500,00 a R$ 4.500,00 / mês.

