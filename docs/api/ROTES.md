# Standardization of Response (Envelopes)

<br>

- **Success Response ```SuccessDTO<T>```**
Utilizado para qualquer retorno bem-sucedido (200, 201).

```json

{
  "success": true,
  "timestamp": "2026-02-26T14:46:23Z",
  "data": { ... }, 
  "message": "SUCCESS OPERATION"
}

```
<br>

- **Error Response ```ErrorDTO```**
Utilizado para erros de negócio, validação ou segurança (400, 401, 403, 404, 409, 422, 500).

```json

{
  "success": false,
  "timestamp": "2026-02-26T14:46:23Z",
  "error": {
    "code": "USER_ALREADY_EXISTS",
    "message": "O e-mail ou CPF informado já está em uso.", // IN PORTUGUESE
    "details": [
      { "field": "email", "issue": "must be a valid email address" }
    ]
  }
}

```
<br>

- **Default error code response**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|INTERNAL_SERVER_ERROR|500|Erro genérico (ex: NullPointerException).|
|DATABASE_ERROR|500|Falha na persistência ou timeout do Postgres.|
|GATEWAY_TIMEOUT|504|O Asaas ou a Z-API demoraram demais para responder.|
|INTEGRATION_FAILURE|502|A API externa (Asaas/WhatsApp) retornou um erro inesperado.|
|INVALID_OPERATION|400|Tentativa de realizar uma ação impossível pelo estado do objeto (ex: dar finish() em um agendamento já cancelado).|
|RESOURCE_NOT_FOUND|404|"O UUID informado não existe no banco (Pet| Tutor| etc)."|
|REDIS_CONNECTION_FAILURE|503|Falha ao buscar sessão ou token no cache.|  

<br>
<br>

# Auth & User

<br>

## **[POST] /api/v1/auth/login**

Autentica o usuário e retorna os tokens de acesso e o contexto do ```tenant``` primário.

<br>

- **Request Body:**
```json

{
    "email" : "email",
    "password": "secure_password"
}

```

<br>

- **Response (200 OK):**
```json

{
  "success": true,
  "timestamp": "2026-02-26T14:46:23Z",
  "data" {
      "accessToken": "ey...",
      "refreshToken": "rf...",
      "user": {
        "id": "uuid",
        "name": "João Silva",
        "isShadow": false
      },
      "activeContext": {
        "tenantId": "uuid",
        "role": "OWNER"
      }
  }
}

```

<br>

- **Tabela de Erros Mapeados (Módulo Auth/Onboarding)**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|INVALID_CREDENTIALS|401|E-mail ou senha não conferem.|
|SESSION_EXPIRED|401|Access Token expirado e Refresh Token inválido no Redis.|
|USER_ALREADY_EXISTS|409|Tentativa de cadastro com dados já existentes.|
|TENANT_CONFLICT|409|CNPJ já cadastrado por outro proprietário.|
|INVALID_CNPJ|422|CNPJ inexistente ou inativo na Receita Federal.|
|ACCESS_DENIED|403|Usuário sem a Role necessária (ex: Banhador tentando ver faturamento).|

<br>
<br>

## POST /api/v1/auth/logout
Apenas para invalidar o refreshToken no servidor.

<br>

- **Request Body:**
```json

{
   
}

```

<br>

- **Response (200 OK):**
```json

{

}

```

<br>
<br>

## **[GET] /api/v1/users/me**

Recupera os dados do usuário logado e seus vínculos ativos.

- Headers: Authorization: Bearer <token>

<br>

- 
- **Response (200 OK):**
```json

{
    "success": true,
    "timestamp": "2026-02-26T17:30:00Z",
    "data": {
        "id": "uuid",
        "name": "João Silva",
        "email": "joao@email.com",
        "phone": "5511999999999",
        "documentId": "123.456.789-00",
        "isShadow": false,
        "memberships": [
        {
            "tenantId": "uuid-petshop-a",
            "role": "OWNER",
            "isPrimary": true
        }
        ]
    }
}

```

<br>
<br>

## [PATCH] /api/v1/users/me
Atualização parcial de dados (Nome ou Telefone).

<br>

- **Request Body:** ```{ "name": "João Silva Alterado" }```

- **Response (200 OK):** ```SuccessDTO<UserDTO>```

<br>

## [PUT] /api/v1/users/me/password

Alteração de senha para usuários já ativos (exige senha antiga).

<br>

- **Request Body:**

```json

{
    "oldPassword": "senha_atual",
    "newPassword": "nova_senha_forte"
}

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|INVALID_CREDENTIALS|401|Crenciais inválidas|

<br>
<br>

## [POST] /api/v1/auth/refresh

Geração de novo par de tokens sem exigir nova senha (Silent Refresh).

- **Request Body:**
```json

{ 
    "refreshToken": "uuid-ou-jwt"
}

```

<br>

- **Response (200 OK):**

```json

"accessToken"
"refreshToken"

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|SESSION_EXPIRED|401|Sessão expirada, faça login novamente|

<br>
<br>

## [DELETE] /api/v1/users/me

Exclusão/Desativação de conta (LGPD).

<br>

- **Request Body:**
```json

{ 
    "password": "confirmação_de_segurança"
}

```

<br>

- **Response (200 OK):**

```json

SUCCESS_OPERATION

```

<br>
<br>

## [POST] /api/v1/auth/register
Cria um perfil de usuário completo. Se o telefone já existir como Shadow, ele promove a conta para isShadow: false.

<br>

- **Request Body:**
```json

{
    "name": "Maria Silva",
    "email": "maria@email.com",
    "phone": "5511999999999",
    "documentId": "123.456.789-00",
    "password": "senha_segura_123"
}

```

<br>

- **Response (201 OK):**

```json

{
  "success": true,
  "timestamp": "2026-02-26T17:30:00Z",
  "data": {
    "accessToken": "ey...",
    "refreshToken": "rf...",
    "user": {
      "id": "uuid",
      "name": "Maria Silva",
      "isShadow": false
    }
  }
}

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|SESUSER_ALREADY_EXISTS|409|Já existe um usuário ativo com este E-mail ou CPF.|
|INVALID_PASSWORD_COMPLEXITY|422|A senha não atende aos requisitos mínimos.|
|INVALID_PHONE_FORMAT|400|Telefone inválido ou fora do padrão.|

<br>
<br>

# Appointments & Check-in

<br>

## [POST] /api/v1/appointments/check-in

Realiza a entrada do pet no estabelecimento. Se o tutor não existir, cria uma ```Shadow Account```. Dispara automaticamente o link de acompanhamento via WhatsApp.

<br>

- **Request Body:**
```json

{
    "tutor": {
        "name": "Carlos Alberto",
        "phone": "5567999998888" 
    },
    "pet": {
        "name": "Rex",
        "species": "Canine",
        "breed": "Golden Retriever"
    },
    "appointment": {
        "professionalId": "uuid-do-veterinario-ou-banhador",
        "scheduledAt": "2026-02-26T14:00:00Z",
        "items": [
            { "serviceId": "uuid-banho", "priceAtTime": 80.00 },
            { "serviceId": "uuid-tosa", "priceAtTime": 50.00 }
        ],
        "notes": "Alérgico a shampoo de coco"
    }
}

```

<br>

- **Response (201 OK):**

```json

{
  "success": true,
  "timestamp": "2026-02-26T17:30:00Z",
  "data": {
    "appointmentId": "uuid",
    "tutorId": "uuid",
    "petId": "uuid",
    "shareToken": "abc-123-xyz",
    "trackingUrl": "https://Nodux.app/track/abc-123-xyz",
    "status": "CHECKED_IN"
  },
  "message": "SUCCESS OPERATION"
}

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|PROFESSIONAL_NOT_FOUND|404|O professionalId informado não existe ou não pertence ao tenant.|
|SERVICE_NOT_FOUND|404|Um ou mais serviceId nos itens não existem no catálogo.|
|INCOMPLETE_SHADOW_DATA|400|Nome ou telefone do tutor ausentes para criação de Shadow Account.|
|DUPLICATE_CHECK_IN|409|O pet já possui um atendimento em aberto (não finalizado) neste momento.|
|WHATSAPP_DISPATCH_FAILED|502|"Agendamento criado, mas falha ao enviar o link via Z-API."|

<br>
<br>

## [GET] /api/v1/public/track/{token}

Rota pública (sem necessidade de login Bearer) para o tutor acompanhar o status do pet através do Link Lite.

<br>

- **Response (201 OK):**

```json

{
  "success": true,
  "data": {
    "petName": "Rex",
    "status": "IN_PROGRESS",
    "checkinAt": "2026-02-26T17:00:00Z",
    "estimatedReadyAt": "2026-02-26T18:30:00Z",
    "items": [
      { "serviceName": "Banho", "status": "COMPLETED" },
      { "serviceName": "Tosa", "status": "IN_PROGRESS" }
    ],
    "metadata": {
      "expiresAt": "2026-02-27T17:00:00Z",
      "totalAmount": 130.00
    }
  }
}

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|LINK_EXPIRED|410|O token de rastreio expirou (limite de 24h ou atendimento finalizado).|
|INVALID_TRACKING_TOKEN|404|Token de rastreio inexistente ou mal formatado.|

<br>

## [PATCH] /api/v1/appointments/{id}/status

Atualiza o estado do atendimento. Mudar para ```READY``` dispara automaticamente o WhatsApp para o tutor avisando que o pet pode ser retirado.

<br>

- **Request Body:**
```json

{
  "status": "READY" // Opções: IN_PROGRESS, READY, CANCELED
}

```

<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "timestamp": "2026-02-26T18:00:00Z",
  "data": {
    "appointmentId": "uuid",
    "newStatus": "READY",
    "readyAt": "2026-02-26T18:00:00Z",
    "notificationSent": true
  },
  "message": "SUCCESS OPERATION"
}

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|APPOINTMENT_NOT_FOUND|400|Tentativa de mudar status para um estado anterior ou proibido (ex: de FINISHED para IN_PROGRESS).|
|INVALID_STATUS_TRANSITION|404|O ID do agendamento não existe para este tenant.|

<br>

## [POST] /api/v1/appointments/{id}/checkout

Finaliza o atendimento e registra a transação financeira. Se o ```paymentFlow``` for ```INTERNAL```, gera o link/cobrança no Asaas.

<br>

- **Request Body:**
```json

{
  "paymentMethod": "PIX", // CASH, PIX, CREDIT_CARD, DEBIT_CARD
  "paymentFlow": "INTERNAL", // INTERNAL (Asaas) ou EXTERNAL (Manual)
  "notes": "Pagamento confirmado no balcão"
}

```

<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "data": {
    "transactionId": "uuid",
    "status": "PAID",
    "asaasInvoiceUrl": "https://asaas.com/i/...", 
    "totalAmount": 130.00
  }
}

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|PAYMENT_GATEWAY_ERROR|502|Falha na comunicação com o Asaas ao gerar cobrança.|
|INCOMPLETE_APPOINTMENT|400|Tentativa de checkout em agendamento que ainda não está no status READY.|

<br>

## [GET] /api/v1/appointments/today

Lista principal para o Dashboard do Lojista, mostrando todos os pets do dia atual e seus respectivos status.

<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "petName": "Rex",
      "tutorName": "Carlos Alberto",
      "status": "IN_PROGRESS",
      "scheduledAt": "2026-02-26T14:00:00Z",
      "totalItems": 2
    }
  ]
}

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|

<br>
<br>

# Services & Bundles

<br>

## [POST] /api/v1/services

Cria um novo serviço no catálogo. Aqui definimos o gatilho de autoridade técnica (```requiresCrmv```).

<br>

- **Request Body:**
```json

{
  "name": "Banho e Tosa Higiênica",
  "description": "Limpeza completa com produtos hipoalergênicos",
  "price": 85.00,
  "durationMinutes": 60,
  "category": "ESTHETIC", // ESTHETIC, CLINICAL, HOSPITALITY
  "requiresCrmv": false
}

```

<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Banho e Tosa Higiênica",
    "isActive": true
  }
}

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|DUPLICATE_SERVICE_NAME|409|Já existe um serviço com este nome no seu PetShop.|
|INVALID_CATEGORY|400|Categoria de serviço não suportada pelo sistema.|

<br>

## [GET] /api/v1/services

Lista todos os serviços ativos para serem selecionados no momento do Check-in.


<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Consulta Veterinária",
      "price": 150.00,
      "requiresCrmv": true,
      "category": "CLINICAL"
    }
  ]
}

```

<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|

<br>
<br>

## [POST] /api/v1/bundles

Cria um combo ou uma assinatura recorrente (Ex: Plano de 4 banhos mensais).

<br>

- **Request Body:**
```json

{
  "name": "Plano Mensal Gold",
  "price": 300.00,
  "isSubscription": true,
  "items": [
    { "serviceId": "uuid-banho", "quantity": 4 },
    { "serviceId": "uuid-tosa", "quantity": 1 }
  ]
}

```

<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "data": {
    "id": "uuid",
    "isSubscription": true,
    "asaasPlanId": "plan_abc123" 
  }
}

```

<br>


- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|BUNDLE_ITEM_NOT_FOUND|404|Um dos serviceId informados para o combo não existe.|
|ASAAS_PLAN_SYNC_ERROR|502|Falha ao criar a regra de recorrência no gateway de pagamento.|

<br>
<br>

# Health Records

<br>

## [POST] /api/v1/health-records

Cria um novo registro clínico (Vacina, Vermifugação, Exame). Se for feito por um usuário com role ```VETERINARIAN```, o sistema tenta validar o CRMV para elevar o registro ao status GOLD.

<br>

- **Request Body:**
```json

{
  "petId": "uuid",
  "type": "VACCINE", // VACCINE, DEWORMING, EXAM, CONSULTATION
  "title": "Vacina Antirrábica",
  "description": "Dose anual aplicada sem reações",
  "eventDate": "2026-02-26",
  "nextDueDate": "2027-02-26", // Gatilho para notificação futura
  "attachmentUrl": "https://s3.Nodux.app/evidencia.jpg"
}

```

<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "data": {
    "id": "uuid",
    "authorityLevel": "GOLD", // BRONZE, SILVER, GOLD
    "crmvVerified": "MG-12345",
    "isExpired": false
  }
}

```

<br>


- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|PET_NOT_FOUND|404|O pet informado não existe ou não pertence a este tenant/tutor.|
|INVALID_AUTHORITY_ACTION|403|Tentativa de criar registro GOLD sem ser Veterinário vinculado ao Tenant.|
|INVALID_DATE_RANGE|400|Data da próxima dose não pode ser anterior à data da aplicação.|

<br>

## [GET] /api/v1/pets/{petId}/health-records

Recupera a linha do tempo de saúde completa do animal. Essencial para o Tutor no App ou o Lojista no Dashboard.


<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "type": "VACCINE",
      "authorityLevel": "GOLD",
      "nextDueDate": "2027-02-26",
      "daysToExpire": 365
    }
  ]
}

```
<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|

<br>
<br>

# Pet Management

<br>

## [PATCH] /api/v1/pets/{id}
Atualiza dados globais do animal (peso, foto, raça). Reflete instantaneamente em todos os estabelecimentos vinculados.

<br>

- **Request Body:**
```json

{
  "weightKg": 12.5,
  "profilePhotoUrl": "https://img.Nodux.app/rex.png"
}

```

<br>

- **Response (200 OK):**

```json

SuccessDTO<PetDTO>

```

<br>


- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|

<br>
<br>

# Financial & Tenant Management

<br>

## [GET] /api/v1/financial/dashboard

Recupera o resumo financeiro do período para o dashboard do lojista. Traz o balanço de transações internas (Asaas) e externas (manual).

<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "data": {
    "totalRevenue": 4500.00,
    "netAmount": 4320.50, // Já descontando taxas do Asaas
    "pendingAmount": 850.00,
    "transactionCount": 42,
    "paymentMethodBreakdown": {
      "PIX": 2500.00,
      "CREDIT_CARD": 1500.00,
      "CASH": 500.00
    }
  }
}

```
<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|

<br>

## [GET] /api/v1/financial/transactions

Lista detalhada das transações para conciliação bancária.

<br>

- **Response (200 OK):**

```json

{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "tutorName": "Carlos Alberto",
      "amount": 130.00,
      "status": "PAID",
      "paymentMethod": "PIX",
      "createdAt": "2026-02-26T14:00:00Z"
    }
  ]
}

```
<br>

- **Tabela de Erros Mapeados**

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|

<br>

## [PATCH] /api/v1/tenants/settings

Configurações administrativas da loja, como a integração com o gateway de pagamento.

<br>

- **Request Body:**
```json

{
  "name": "Novo Nome do PetShop",
  "asaasApiKey": "ak_live_...", // Chave de API para integração
  "businessAddress": "Rua das Flores, 123",
  "notificationPreferences": {
    "whatsappOnReady": true,
    "whatsappOnCheckin": true
  }
}

```

|Código de Erro (code)|HTTP Status|Cenário|
|---------------------|-----------|-------|
|INVALID_ASAAS_KEY|400|A chave de API fornecida é inválida ou não pôde ser autenticada no gateway.|
|UNAUTHORIZED_SETTING_CHANGE|403|Apenas usuários com role OWNER podem alterar chaves de API.|