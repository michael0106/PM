# Digital Affiliate Portal (DAP) - Phase 1 PRD Pack

## Overview
- Purpose: Replace Cellxpert (CX) with in-house DAP for CPA business, unblock CX constraints, improve Sales/Marketing/OP efficiency, and enable end-to-end data governance and risk controls.
- Scope: Vantage brand V1/V2 only (no FCA/ASIC/CIMA in Phase 1). Focus on CPA flows: registration/login, OTP+KYC, multi-account, commission plan config, lead allocation, commission calculation and payments, marketing, client/agent management, RBAC, workflows, notifications, integrations (Sumsub, Security Center 1.0), forbidden countries, blacklist, data/BI.
- Out-of-scope (Phase 1): Security Center 2.0 integration (prepare stubs), FCA/ASIC/CIMA, full PAMM deep features, passkey/TOTP app binding inside DAP, advanced task auto-assignment for Client Upgrade CPA.

## Milestones (target sequencing)
- M0 Foundations: Accounts framework (UserID/State/Account), RBAC baseline, country/regulation mapping, forbidden countries, blacklist, notifications infra.
- M1 Registration & Login: Email/Phone login, registration sources (website/CPA invite/Sales invite), duplication rules, regulation assignment, Client->CPA Upgrade (OWS flow), basic dashboard.
- M2 OTP+KYC: Security Center 1.0 flows, Sumsub for POI/POA, manual KYC audit in OWS, KYC-driven feature gates (marketing link after POI, payout/plan change after POA).
- M3 Lead Allocation: CPA Allocation rules (OWS), records, minimal lead pool fallback (if needed), notifications.
- M4 Commission Plans: Modes (Deactivate, CPA by Country, FTD Amount Tiers, Progressive CPA Tiers), Qualification config, Application Scope control, Transfer re-trigger, Monthly Bonus, Agreements.
- M5 Commission Management: Calculation pipeline, reports, application/approval, adjustments, payment records; Funds module skeleton for payout orchestration.
- M6 Partner Portal Modules: Marketing materials, links/QR, client management (list + reports), agent management (admin views), API callbacks.
- M7 Data/BI & Logs: Metrics dictionary, funnel, dashboards, data sync to BI, task/workflow audit logs.

## Directory
- Scope.md
- Epics_and_Stories.md
- Acceptance_Criteria.md
- Data_Model.md
- Workflows.md
- Integrations.md
- RBAC.md
- Risks_and_Open_Questions.md
- Glossary.md

## Owners
- Overall: Leon Li
- Registration/KYC: Leon Li, Michael Duan, Nora Ye
- Plan/Commission: Leon Li
- Marketing/Client: Stella Dai
- Agent/RBAC/Settings: Leon Li, Nora Ye

## Notes
- All currency values in USD. Historical transactions converted with T-1 FX where needed.
- Pagination: CPA Portal lists default 10 rows; OWS/SWS default 20; per-visit choice not persisted.
- Name/email/phone visibility: OWS permission-controlled; SWS fully visible.