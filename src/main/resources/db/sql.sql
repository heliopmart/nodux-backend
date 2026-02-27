CREATE TYPE "PlanType" AS ENUM (
  'BRONZE',
  'SILVER',
  'GOLD'
);

CREATE TYPE "UserRole" AS ENUM (
  'OWNER',
  'VETERINARIAN',
  'EMPLOYEE',
  'TUTOR'
);

CREATE TYPE "PetsGender" AS ENUM (
  'MALE',
  'FEMALE'
);

CREATE TYPE "ServiceCategory" AS ENUM (
  'ESTHETIC',
  'CLINICAL',
  'HOSPITALITY'
);

CREATE TYPE "AppointmentStatus" AS ENUM (
  'SCHEDULED',
  'CHECKED_IN',
  'IN_PROGRESS',
  'READY',
  'FINISHED',
  'CANCELED'
);

CREATE TYPE "ItemStatus" AS ENUM (
  'PENDING',
  'IN_PROGRESS',
  'COMPLETED'
);

CREATE TYPE "PaymentFlow" AS ENUM (
  'INTERNAL',
  'EXTERNAL'
);

CREATE TYPE "HealthRecordType" AS ENUM (
  'VACCINE',
  'DEWORMING',
  'EXAM',
  'CONSULTATION'
);

CREATE TYPE "AuthorityLevel" AS ENUM (
  'BRONZE',
  'SILVER',
  'GOLD'
);

CREATE TYPE "TransactionStatus" AS ENUM (
  'PENDING',
  'PAID',
  'CANCELED',
  'REFUNDED',
  'OVERDUE'
);

CREATE TYPE "PaymentMethod" AS ENUM (
  'CASH',
  'PIX',
  'BOLETO',
  'CREDIT_CARD',
  'DEBIT_CARD'
);

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY,
  "email" varchar UNIQUE,
  "password_hash" varchar,
  "name" varchar NOT NULL,
  "phone" varchar UNIQUE NOT NULL,
  "document_id" varchar UNIQUE,
  "is_shadow" boolean DEFAULT true,
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "tenants" (
  "id" uuid PRIMARY KEY,
  "name" varchar NOT NULL,
  "document_id" varchar UNIQUE NOT NULL,
  "plan_type" "PlanType" NOT NULL DEFAULT 'BRONZE',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "user_tenants" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "tenant_id" uuid NOT NULL,
  "is_primary_tenant" boolean DEFAULT false,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "user_tenant_roles" (
  "id" uuid PRIMARY KEY,
  "role" "UserRole" NOT NULL,
  "user_tenant_id" uuid NOT NULL
);

CREATE TABLE "pets" (
  "id" uuid PRIMARY KEY,
  "tutor_id" uuid NOT NULL,
  "name" varchar NOT NULL,
  "species" varchar NOT NULL,
  "breed" varchar NOT NULL,
  "birth_date" date,
  "gender" "PetsGender",
  "weight_kg" decimal,
  "is_active" boolean NOT NULL DEFAULT true,
  "profile_photo_url" varchar,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "tenant_pets" (
  "id" uuid PRIMARY KEY,
  "tenant_id" uuid NOT NULL,
  "pet_id" uuid NOT NULL,
  "internal_notes" text,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "services" (
  "id" uuid PRIMARY KEY,
  "tenant_id" uuid NOT NULL,
  "name" varchar NOT NULL,
  "description" text,
  "price" decimal NOT NULL,
  "duration_minutes" integer,
  "category" "ServiceCategory" NOT NULL DEFAULT 'ESTHETIC',
  "requires_crmv" boolean NOT NULL DEFAULT false,
  "is_active" boolean NOT NULL DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "bundles" (
  "id" uuid PRIMARY KEY,
  "tenant_id" uuid NOT NULL,
  "name" varchar NOT NULL,
  "price" decimal NOT NULL,
  "is_subscription" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "bundle_items" (
  "id" uuid PRIMARY KEY,
  "bundle_id" uuid NOT NULL,
  "service_id" uuid NOT NULL,
  "quantity" integer NOT NULL DEFAULT 1
);

CREATE TABLE "tutor_subscriptions" (
  "id" uuid PRIMARY KEY,
  "tutor_id" uuid NOT NULL,
  "tenant_id" uuid NOT NULL,
  "bundle_id" uuid NOT NULL,
  "external_id_asaas" varchar,
  "status" varchar,
  "starts_at" date,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "appointments" (
  "id" uuid PRIMARY KEY,
  "tenant_id" uuid NOT NULL,
  "pet_id" uuid NOT NULL,
  "payment_flow" "PaymentFlow" DEFAULT 'EXTERNAL',
  "subscription_id" uuid,
  "professional_user_tenant_id" uuid NOT NULL,
  "scheduled_at" timestamp NOT NULL,
  "status" "AppointmentStatus" NOT NULL DEFAULT 'SCHEDULED',
  "checkin_at" timestamp,
  "started_at" timestamp,
  "ready_at" timestamp,
  "canceled_at" timestamp,
  "notes" text,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "appointment_metadata" (
  "id" uuid PRIMARY KEY,
  "appointment_id" uuid UNIQUE NOT NULL,
  "share_token" varchar UNIQUE NOT NULL,
  "expires_at" timestamp NOT NULL,
  "view_count" integer DEFAULT 0,
  "total_amount" decimal NOT NULL,
  "last_viewed_at" timestamp,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "appointment_items" (
  "id" uuid PRIMARY KEY,
  "appointment_id" uuid NOT NULL,
  "service_id" uuid NOT NULL,
  "bundle_item_id" uuid,
  "price_at_time" decimal NOT NULL,
  "status" "ItemStatus" NOT NULL DEFAULT 'PENDING'
);

CREATE TABLE "health_records" (
  "id" uuid PRIMARY KEY,
  "pet_id" uuid NOT NULL,
  "tenant_id" uuid NOT NULL,
  "professional_user_tenant_id" uuid NOT NULL,
  "appointment_id" uuid,
  "type" "HealthRecordType" NOT NULL,
  "title" varchar NOT NULL,
  "description" text,
  "event_date" date NOT NULL,
  "next_due_date" date,
  "authority_level" "AuthorityLevel" NOT NULL DEFAULT 'BRONZE',
  "crmv_verified" varchar,
  "attachment_url" varchar,
  "updated_at" timestamp DEFAULT (now()),
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "financial_transactions" (
  "id" uuid PRIMARY KEY,
  "tenant_id" uuid NOT NULL,
  "tutor_id" uuid NOT NULL,
  "appointment_id" uuid,
  "subscription_id" uuid,
  "external_id_asaas" varchar UNIQUE,
  "recorded_by" uuid,
  "amount" decimal NOT NULL,
  "net_amount" decimal,
  "status" "TransactionStatus" NOT NULL DEFAULT 'PENDING',
  "payment_method" "PaymentMethod" NOT NULL,
  "due_date" date,
  "paid_at" timestamp,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "audit_logs" (
  "id" uuid PRIMARY KEY,
  "tenant_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "action" varchar NOT NULL,
  "entity_name" varchar NOT NULL,
  "entity_id" uuid,
  "old_value" jsonb,
  "new_value" jsonb,
  "ip_address" varchar,
  "user_agent" varchar,
  "created_at" timestamp DEFAULT (now())
);

CREATE UNIQUE INDEX ON "user_tenants" ("user_id", "tenant_id");

CREATE UNIQUE INDEX ON "user_tenant_roles" ("user_tenant_id", "role");

CREATE UNIQUE INDEX ON "tenant_pets" ("tenant_id", "pet_id");

CREATE INDEX ON "appointments" ("tenant_id", "scheduled_at");

CREATE INDEX ON "appointments" ("tenant_id", "status");

CREATE INDEX ON "appointment_items" ("appointment_id");

CREATE INDEX ON "financial_transactions" ("tenant_id", "status", "due_date");

COMMENT ON COLUMN "users"."email" IS 'Null para Shadow Accounts';

COMMENT ON COLUMN "users"."password_hash" IS 'Null para Shadow Accounts';

COMMENT ON COLUMN "users"."document_id" IS 'CPF do Tutor';

COMMENT ON COLUMN "tenants"."document_id" IS 'CNPJ da Loja';

COMMENT ON COLUMN "user_tenant_roles"."role" IS 'Pepel do usuário';

COMMENT ON COLUMN "pets"."tutor_id" IS 'Dono do animal (Soberania de Dados)';

COMMENT ON COLUMN "pets"."species" IS 'Cão, Gato, Ave, etc';

COMMENT ON COLUMN "pets"."breed" IS 'Raça - Para o MVP v0.5, varchar resolve';

COMMENT ON COLUMN "pets"."gender" IS 'Macho/Fêmea';

COMMENT ON COLUMN "tenant_pets"."internal_notes" IS 'Notas privadas do lojista (ex: comportamento)';

COMMENT ON COLUMN "services"."duration_minutes" IS 'Essencial para o motor de agendamento da v1.0';

COMMENT ON COLUMN "services"."requires_crmv" IS 'Gatilho para o Selo Ouro';

COMMENT ON COLUMN "bundles"."is_subscription" IS 'Se gera cobrança recorrente no Asaas';

COMMENT ON COLUMN "bundle_items"."quantity" IS 'Ex: 4 banhos';

COMMENT ON COLUMN "tutor_subscriptions"."external_id_asaas" IS 'ID da assinatura no Asaas';

COMMENT ON COLUMN "appointments"."payment_flow" IS 'Define se o sistema gera link Asaas ou se é manual';

COMMENT ON COLUMN "appointments"."subscription_id" IS 'Se nulo, é serviço avulso';

COMMENT ON COLUMN "appointments"."scheduled_at" IS 'Data/Hora marcada';

COMMENT ON COLUMN "appointments"."notes" IS 'Observações específicas deste atendimento';

COMMENT ON COLUMN "appointment_items"."bundle_item_id" IS 'Se veio de um combo/assinatura';

COMMENT ON COLUMN "appointment_items"."price_at_time" IS 'Preço cobrado no momento, ignora alterações futuras no catálogo';

COMMENT ON COLUMN "appointment_items"."status" IS 'Para saber se a tosa já terminou mas o banho não';

COMMENT ON COLUMN "health_records"."event_date" IS 'Data em que o serviço foi feito';

COMMENT ON COLUMN "health_records"."next_due_date" IS 'Gatilho para o status preditivo da v1.0';

COMMENT ON COLUMN "health_records"."crmv_verified" IS 'CRMV de quem assinou, se GOLD';

COMMENT ON COLUMN "health_records"."attachment_url" IS 'Foto/PDF da carteira física para OCR ou prova';

COMMENT ON COLUMN "financial_transactions"."appointment_id" IS 'Para cobranças avulsas v0.5';

COMMENT ON COLUMN "financial_transactions"."subscription_id" IS 'Para mensalidades v1.0';

COMMENT ON COLUMN "financial_transactions"."external_id_asaas" IS 'NULL se o fluxo for EXTERNAL';

COMMENT ON COLUMN "financial_transactions"."recorded_by" IS 'Usuário que confirmou o recebimento manual';

COMMENT ON COLUMN "financial_transactions"."net_amount" IS 'No fluxo EXTERNAL, taxas não são calculadas automaticamente';

COMMENT ON COLUMN "audit_logs"."user_id" IS 'Quem fez a ação';

COMMENT ON COLUMN "audit_logs"."action" IS 'Ex: UPDATE_STATUS, MANUAL_PAYMENT_BYPASS';

COMMENT ON COLUMN "audit_logs"."entity_name" IS 'Ex: appointments, financial_transactions';

ALTER TABLE "user_tenants" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "user_tenants" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "user_tenant_roles" ADD FOREIGN KEY ("user_tenant_id") REFERENCES "user_tenants" ("id");

ALTER TABLE "pets" ADD FOREIGN KEY ("tutor_id") REFERENCES "users" ("id");

ALTER TABLE "tenant_pets" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "tenant_pets" ADD FOREIGN KEY ("pet_id") REFERENCES "pets" ("id");

ALTER TABLE "services" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "bundles" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "bundle_items" ADD FOREIGN KEY ("bundle_id") REFERENCES "bundles" ("id");

ALTER TABLE "bundle_items" ADD FOREIGN KEY ("service_id") REFERENCES "services" ("id");

ALTER TABLE "tutor_subscriptions" ADD FOREIGN KEY ("tutor_id") REFERENCES "users" ("id");

ALTER TABLE "tutor_subscriptions" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "tutor_subscriptions" ADD FOREIGN KEY ("bundle_id") REFERENCES "bundles" ("id");

ALTER TABLE "appointments" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "appointments" ADD FOREIGN KEY ("pet_id") REFERENCES "pets" ("id");

ALTER TABLE "appointments" ADD FOREIGN KEY ("subscription_id") REFERENCES "tutor_subscriptions" ("id");

ALTER TABLE "appointments" ADD FOREIGN KEY ("professional_user_tenant_id") REFERENCES "user_tenants" ("id");

ALTER TABLE "appointment_metadata" ADD FOREIGN KEY ("appointment_id") REFERENCES "appointments" ("id");

ALTER TABLE "appointment_items" ADD FOREIGN KEY ("appointment_id") REFERENCES "appointments" ("id");

ALTER TABLE "appointment_items" ADD FOREIGN KEY ("service_id") REFERENCES "services" ("id");

ALTER TABLE "appointment_items" ADD FOREIGN KEY ("bundle_item_id") REFERENCES "bundle_items" ("id");

ALTER TABLE "health_records" ADD FOREIGN KEY ("pet_id") REFERENCES "pets" ("id");

ALTER TABLE "health_records" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "health_records" ADD FOREIGN KEY ("professional_user_tenant_id") REFERENCES "user_tenants" ("id");

ALTER TABLE "health_records" ADD FOREIGN KEY ("appointment_id") REFERENCES "appointments" ("id");

ALTER TABLE "financial_transactions" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "financial_transactions" ADD FOREIGN KEY ("tutor_id") REFERENCES "users" ("id");

ALTER TABLE "financial_transactions" ADD FOREIGN KEY ("appointment_id") REFERENCES "appointments" ("id");

ALTER TABLE "financial_transactions" ADD FOREIGN KEY ("subscription_id") REFERENCES "tutor_subscriptions" ("id");

ALTER TABLE "financial_transactions" ADD FOREIGN KEY ("recorded_by") REFERENCES "users" ("id");

ALTER TABLE "audit_logs" ADD FOREIGN KEY ("tenant_id") REFERENCES "tenants" ("id");

ALTER TABLE "audit_logs" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
