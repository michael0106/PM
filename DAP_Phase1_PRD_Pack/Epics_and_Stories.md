## Epics
- E1 Registration & Login
- E2 OTP + KYC
- E3 Account & Multi-Account
- E4 Lead Allocation
- E5 Commission Plans & Agreements
- E6 Commission Management & Payments
- E7 Marketing & Tracking
- E8 Client Management (Portal + Admin)
- E9 Agent Management (Admin)
- E10 RBAC & Settings
- E11 Data/BI & Logs
- E12 Integrations & Migration

## Key User Stories (selected)

- E1-S1 As a CPA, I can register via website with email/phone so I can access DAP.
  - Reject if email/phone belongs to IB; prompt login if CPA; instruct Client to upgrade if Client.
  - Regulation auto-assigned by domain and invite parameters (V1/V2 only).

- E1-S2 As a CPA, I can login by email or phone + password.
  - Error messages for unregistered or wrong password as specified.

- E2-S1 As a CPA, I can complete OTP (email/phone) and KYC (POI/POA) via Sumsub.
  - After POI pass, marketing links are enabled; after POA pass, payout and plan change are enabled.

- E2-S2 As OP, I can manually audit POI/POA in OWS and send notifications.

- E3-S1 As a CPA, I can request additional CPA Accounts (<=10) for other countries/sales.

- E4-S1 As a Sales Manager, I can define CPA Allocation rules in OWS and set priority order.
  - OR within block, AND between blocks; delayed and scheduled effect; allocation to selected sales list.

- E5-S1 As OP/Sales, I can configure a CPA plan mode, qualification, application scope, transfer re-trigger, and monthly bonus.
  - Changing plan optionally triggers agreement generation and CPA confirmation.

- E5-S2 As a CPA, I can view current plan and download agreements.

- E6-S1 As a CPA, I can apply for commission payout on allowed cycles (weekly/bi-weekly/monthly per plan).

- E6-S2 As Finance/OP, I can review, adjust, and approve commissions; create payment records.

- E7-S1 As a CPA, I can generate invite links/QR with tracking code/AFP and use marketing materials.

- E8-S1 As a CPA, I can view client list and performance report with filters, totals, and export.

- E9-S1 As Sales/OP, I can view CPA details, activity/ROI, sub-CPA tree, and reassign sales or upstream CPA.

- E10-S1 As Admin, I can manage roles and permissions; SWS shows PII by default, OWS is permission-gated.

- E11-S1 As BI/OP, I can view funnel metrics, allocation records, QFTD counts, commission totals, and ROI.

- E12-S1 As OP, I can upgrade a Client to CPA via OWS with KYC check, creating an application record and plan config.