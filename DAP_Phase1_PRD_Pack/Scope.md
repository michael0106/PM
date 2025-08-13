## In Scope (Phase 1)
- Registration/Login: Email/Phone login; registration via website, CPA invite, Sales invite; duplication checks; regulation assignment (V1/V2);
- Account Model: UserID (passport), States (CPA/IB/Client/Affiliate), CPA Account (cross-regulation), multi-account (<=10 per CPA), account switching.
- OTP+KYC: Email/SMS OTP via Security Center 1.0; KYC via Sumsub (POI/POA) with OWS manual audit and mails/messages; feature gates after POI/POA.
- Client->CPA Upgrade: Client Portal entry (gated by KYC), OWS audit with commission config, notifications.
- Lead Allocation: OWS CPA Allocation rules (OR within group, AND across groups); allocation records; priorities; status transitions.
- Commission Plans: Modes (Deactivate/CPA by Country/FTD Amount/Progressive); Qualification config; Application Scope (incremental/full+range); Transfer re-trigger (monthly once); Monthly Bonus (ROI + headcount threshold, first run manual approval then auto).
- Agreements: Template mgmt, generation, confirmation in CPA Portal, effect on plan go-live, archive.
- Commission Management: Calc pipeline and reports; payout application; approvals; manual/batch adjustments; payment records; Funds module skeleton (withdrawal/internal transfer records, OP review flow outline).
- Marketing: Links/QR; Materials center (poster/video/landing/gif/logo) browsing/usage; tracking params (tracking code/AFP/NCI).
- Client Management: CPA Portal client list and performance report (filters, totals, export); Admin client management (OWS/SWS) with extended fields and exports.
- Agent Management: CPA overview, activity/ROI, tags, goals, notes; Sub-CPA tree; re-assignment tools.
- RBAC: Org/Role/User/Resource model; module/action/data-level permissions; OWS vs SWS differences.
- Data/BI: Metrics dictionary and dashboards (with BI team); funnel and allocation records; event logs.
- Governance: Forbidden countries (Apollo or new config); blacklist reuse; notifications (SWS, email, SMS); workflow engine hooks.

## Out of Scope (Phase 1)
- FCA/ASIC/CIMA regulations and their registrations.
- Security Center 2.0 final APIs; native TOTP/passkey; fund password flows.
- PAMM deep features beyond id mapping.
- Auto-assignment (Task Rule) for Client Upgrade CPA; advanced task types.
- RevShare/CPL (non-CPA) commission types.

## Assumptions
- CX users have email/phone bound; DAP will force email/phone login. Post-migration passwords may be reset.
- Historical settled commissions remain immutable; adjustments use separate adjustment records.
- All monetary config in USD; conversions performed upstream.