## Roles (initial)
- Partner (CPA)
- Sales
- Sales Manager
- OP (Operations)
- Finance
- Admin (CRM/OWS)

## Module Permissions (high-level)
- CPA Portal
  - Partner: Dashboard, Marketing, Clients, Agreements, Funds (apply), Profile/Security; view own plans.
- OWS
  - Sales: View assigned CPAs/clients; notes; submit requests.
  - Sales Manager: All Sales + Allocation rules, reassignments, lead views.
  - OP: KYC audit, Client->CPA audit, plan config, agreements, adjustments, payouts, agent management.
  - Finance: Commission approvals, payments, reports.
  - Admin: Role management, settings (forbidden countries, defaults), country groups, commission groups.
- SWS
  - Messages, dashboards; PII always visible.

## Data/Field-Level Controls
- OWS PII fields (name/email/phone) visible per role/permission; SWS always visible.
- Action-level: reassign, forced KYC pass, adjustment creation require elevated roles.

## Audit
- All mutations recorded with actor/time/before/after.