Enum PlanType {
  BRONZE
  SILVER
  GOLD
}

Enum UserRole {
  OWNER        // Dono do Pet Shop (acesso total)
  VETERINARIAN // Acesso a prontuários e Selo Ouro
  EMPLOYEE     // Banhador/Tosador (altera status de serviço)
  TUTOR        // Cliente (visualiza apenas seus pets)
}

Enum PetsGender {
  MALE
  FEMALE
}

Enum ServiceCategory {
  ESTHETIC    // Banho, Tosa, Hidratação
  CLINICAL    // Consulta, Vacina, Cirurgia
  HOSPITALITY // Hotel, Creche
}

Enum AppointmentStatus {
  SCHEDULED       // Agendado (ainda não chegou)
  CHECKED_IN      // Entrada (O "Dar Entrada" do Dashboard v0.5)
  IN_PROGRESS     // Em Atendimento
  READY           // Pronto (Gatilha notificação pro tutor)
  FINISHED        // Finalizado (Pet entregue e pago)
  CANCELED        // No-show ou cancelamento
}

Enum ItemStatus { 
  PENDING 
  IN_PROGRESS
  COMPLETED 
}

Enum PaymentFlow {
  INTERNAL // Gerado e rastreado pelo Nodux (Asaas)
  EXTERNAL // Maquininha física, dinheiro, etc.
}

Enum HealthRecordType {
  VACCINE
  DEWORMING
  EXAM
  CONSULTATION
}

Enum AuthorityLevel {
  BRONZE // Manual (v0.5)
  SILVER // Validado por documento (v1.0)
  GOLD   // Assinado por CRMV na plataforma (v1.0)
}

Enum TransactionStatus {
  PENDING     // Cobrança gerada
  PAID        // Dinheiro na conta (Asaas confirmou)
  CANCELED    // Cobrança anulada
  REFUNDED    // Estornado
  OVERDUE     // Vencido (Inadimplência)
}

Enum PaymentMethod {
  CASH
  PIX
  BOLETO
  CREDIT_CARD
  DEBIT_CARD
}

Table users {
  id uuid [pk]
  email varchar [unique, note: 'Null para Shadow Accounts', null]
  password_hash varchar [note: 'Null para Shadow Accounts', null]
  name varchar [not null]
  phone varchar [unique, not null] 
  document_id varchar [unique, note: 'CPF do Tutor', null]
  is_shadow boolean [default: true]
  is_active boolean [default: true]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table tenants {
  id uuid [pk]
  name varchar [not null]
  document_id varchar [unique, note: 'CNPJ da Loja', not null]
  plan_type PlanType [default: PlanType.BRONZE, not null]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table user_tenants {
  id uuid [pk]
  user_id uuid [ref: > users.id, not null]
  tenant_id uuid [ref: > tenants.id, not null]

  is_primary_tenant boolean [default: false]
  created_at timestamp [default: `now()`]

  Indexes {
    (user_id, tenant_id) [unique]
  }
}

Table user_tenant_roles{
  id uuid [pk]
  role UserRole [note: "Pepel do usuário", not null]
  user_tenant_id uuid [ref: > user_tenants.id, not null]

  Indexes {
    (user_tenant_id, role) [unique]
  }
}

Table pets {
  id uuid [pk]
  tutor_id uuid [ref: > users.id, note: 'Dono do animal (Soberania de Dados)', not null]
  name varchar [not null]
  species varchar [note: 'Cão, Gato, Ave, etc', not null]
  breed varchar [note: 'Raça - Para o MVP v0.5, varchar resolve', not null]
  birth_date date
  gender PetsGender [note: 'Macho/Fêmea']
  weight_kg decimal
  is_active boolean [default: true, not null]
  profile_photo_url varchar
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table tenant_pets {
  id uuid [pk]
  tenant_id uuid [ref: > tenants.id, not null]
  pet_id uuid [ref: > pets.id, not null]
  internal_notes text [note: 'Notas privadas do lojista (ex: comportamento)']
  created_at timestamp [default: `now()`]

  Indexes {
    (tenant_id, pet_id) [unique]
  }
}

// Service isn't an employee, it's just a task to be done
Table services {
  id uuid [pk]
  tenant_id uuid [ref: > tenants.id, not null]
  name varchar [not null]
  description text 
  price decimal [not null]
  duration_minutes integer [note: 'Essencial para o motor de agendamento da v1.0']
  category ServiceCategory [default: ServiceCategory.ESTHETIC, not null]
  requires_crmv boolean [default: false, note: 'Gatilho para o Selo Ouro', not null]
  is_active boolean [default: true, not null]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table bundles {
  id uuid [pk]
  tenant_id uuid [ref: > tenants.id, not null]
  name varchar [not null]
  price decimal [not null]
  is_subscription boolean [default: true, note: 'Se gera cobrança recorrente no Asaas']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table bundle_items {
  id uuid [pk]
  bundle_id uuid [ref: > bundles.id, not null]
  service_id uuid [ref: > services.id, not null]
  quantity integer [default:  1,  note: 'Ex: 4 banhos', not null]
}

Table tutor_subscriptions {
  id uuid [pk]
  tutor_id uuid [ref: > users.id, not null]
  tenant_id uuid [ref: > tenants.id, not null]
  bundle_id uuid [ref: > bundles.id, not null]
  external_id_asaas varchar [note: 'ID da assinatura no Asaas']
  status varchar
  starts_at date
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

// --- mvp engine ---

Table appointments {
  id uuid [pk]
  tenant_id uuid [ref: > tenants.id, not null]
  pet_id uuid [ref: > pets.id, not null]
  
  // Need revision
  payment_flow PaymentFlow [default: PaymentFlow.EXTERNAL, note: 'Define se o sistema gera link Asaas ou se é manual']
  
  subscription_id uuid [ref: > tutor_subscriptions.id, note: 'Se nulo, é serviço avulso', null]
  
  professional_user_tenant_id uuid [ref: > user_tenants.id, not null] 
  
  scheduled_at timestamp [note: 'Data/Hora marcada', not null]
  status AppointmentStatus [default: AppointmentStatus.SCHEDULED, not null]
  
  checkin_at timestamp    // Quando o botão "Dar Entrada" foi clicado
  
  started_at timestamp    // Quando entrou em "Em Atendimento"
  ready_at timestamp      // Quando o status virou "Pronto"
  canceled_at timestamp

  notes text [note: 'Observações específicas deste atendimento']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]

  indexes {
    (tenant_id, scheduled_at)
    (tenant_id, status)
  }
}

Table appointment_metadata {
  id uuid [pk]
  appointment_id uuid [ref: - appointments.id, unique, not null]
  
  share_token varchar [unique, not null]
  expires_at timestamp [not null]
  view_count integer [default: 0]
  
  total_amount decimal [not null] 
  
  last_viewed_at timestamp
  created_at timestamp [default: `now()`]
}

Table appointment_items {
  id uuid [pk]
  appointment_id uuid [ref: > appointments.id, not null]
  service_id uuid [ref: > services.id, not null] 
  bundle_item_id uuid [ref: > bundle_items.id, note: 'Se veio de um combo/assinatura', null]
  
  price_at_time decimal [note: 'Preço cobrado no momento, ignora alterações futuras no catálogo', not null]
  status ItemStatus [default: ItemStatus.PENDING, note: 'Para saber se a tosa já terminou mas o banho não', not null]

  Indexes {
    (appointment_id)
  }
}


Table health_records {
  id uuid [pk]
  pet_id uuid [ref: > pets.id, not null]
  tenant_id uuid [ref: > tenants.id, not null]
  professional_user_tenant_id uuid [ref: > user_tenants.id, not null]
  appointment_id uuid [ref: > appointments.id, null]
  
  type HealthRecordType [not null]
  title varchar [not null]
  description text
  
  event_date date [note: 'Data em que o serviço foi feito', not null]
  next_due_date date [note: 'Gatilho para o status preditivo da v1.0']
  
  authority_level AuthorityLevel [default: AuthorityLevel.BRONZE, not null]
  
  // v1.0 - Campos de Autoridade
  crmv_verified varchar [note: 'CRMV de quem assinou, se GOLD']
  attachment_url varchar [note: 'Foto/PDF da carteira física para OCR ou prova']
  
  updated_at timestamp [default:  `now()`]
  created_at timestamp [default: `now()`]
}

Table financial_transactions {
  id uuid [pk]
  tenant_id uuid [ref: > tenants.id, not null]
  tutor_id uuid [ref: > users.id, not null]
  
  appointment_id uuid [ref: > appointments.id, note: 'Para cobranças avulsas v0.5']
  subscription_id uuid [ref: > tutor_subscriptions.id, note: 'Para mensalidades v1.0']
  
  external_id_asaas varchar [unique, note: 'NULL se o fluxo for EXTERNAL']
  recorded_by uuid [ref: > users.id, note: 'Usuário que confirmou o recebimento manual']
  
  amount decimal [not null]
  net_amount decimal [note: 'No fluxo EXTERNAL, taxas não são calculadas automaticamente', null]
  
  status TransactionStatus [default: TransactionStatus.PENDING, not null]
  payment_method PaymentMethod [not null]
  
  due_date date
  paid_at timestamp
  
  created_at timestamp [default: `now()`]

  indexes {
    (tenant_id, status, due_date)
  }
}

Table audit_logs {
  id uuid [pk]
  tenant_id uuid [ref: > tenants.id, not null]
  user_id uuid [ref: > users.id, note: 'Quem fez a ação', not null]
  
  action varchar [note: 'Ex: UPDATE_STATUS, MANUAL_PAYMENT_BYPASS', not null]
  entity_name varchar [note: 'Ex: appointments, financial_transactions', not null]
  entity_id uuid
  
  old_value jsonb
  new_value jsonb
  
  ip_address varchar
  user_agent varchar
  created_at timestamp [default: `now()`]
}