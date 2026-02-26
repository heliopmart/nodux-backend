```mermaid
stateDiagram-v2
    [*] --> SHADOW : Criado pelo Pet Shop (apenas Telefone)
    [*] --> PENDING_VERIFICATION : Cadastro via App/Web (B2C)
    
    SHADOW --> ACTIVE : Reivindica conta (Ghost-to-User)
    PENDING_VERIFICATION --> ACTIVE : Validação de E-mail/SMS
    
    ACTIVE --> SUSPENDED : Violação de termos ou inadimplência
    SUSPENDED --> ACTIVE : Reativação manual
    
    ACTIVE --> [*] : Exclusão (LGPD)
```