## Registration & Login
- Email: <=60 chars; RFC-like .com format; error messages per spec.
- Username: collected but not used for login; length <=30; no uniqueness enforcement.
- Phone: <=30 digits; country code selectable; validation per CRM country code list.
- Duplicate detection: check email then phone; IB → reject; CPA → prompt login; Client → prompt upgrade flow.
- Regulation assignment: by domain and inviter org; V1/V2 only; country fallbacks as provided.
- Success: redirect Dashboard; global success toast.

## OTP + KYC
- Security Center 1.0 flows hooked for email/phone/password changes; TOTP not required in DAP.
- Sumsub POI/POA integrated; manual audit available in OWS; messages and emails sent on status changes.
- Feature gates: POI enables marketing; POA enables payout and plan change.

## Client Upgrade to CPA
- Client Portal entry visible only if allowed by brand/regulation and sales org setting; disabled if KYC incomplete.
- OWS audit: choose sales owner and commission plan (default loaded, editable); approve creates CPA Account ID.
- Messages: Upgrade submitted/approved/rejected events created; emails as listed.

## Lead Allocation (CPA)
- Rule builder: OR within block; AND across blocks; up to 50 conditions; duplicate fields allowed; 200 assignees max.
- Priority ordering with drag-and-drop; enable/disable switch; effective time options.
- Records list: statuses (In Queue/Completed/Recycle/Not Pursue); sortable/filterable; rule drill-down.

## Commission Plans
- Modes: Deactivate, CPA by Country (country/group/ELSE precedence), FTD Amount Tiers (up to 5 non-overlap ranges), Progressive CPA Tiers (up to 5 ascending ranges, strictly increasing payouts).
- Qualification: Net Deposit >= x AND (Indices Lot >= a OR Non-Indices Lot >= b OR Position Count >= c).
- Application Scope: Incremental or Full; Full supports lookback up to 12 months for qualified-but-unsettled only.
- Transfer Re-trigger: At most once per natural month per Client post-transfer; independent of plan payout cycle.
- Monthly Bonus: Enable/disable; ROI operator and threshold; headcount threshold; first month requires manual approval then auto.
- Agreements: Template selection; generation; CPA confirmation required if setting demands; archive upon confirmation.

## Commission Management
- Calculation pipeline emits QFTD and progressive adjustments per Client lifecycle; settled items immutable.
- Adjustments: Manual/batch with audit trail and linkage; notifications; downstream sync.
- Payout Application: Cycles per plan; approval workflow; payment record created on approval.

## Marketing
- Link/QR generation requires POI; localized options; track tracking code/AFP/NCI; landing pages/videos/posters browsing with filters (hot/new), sizes, languages; inline playback for videos.

## Client Management (Portal)
- Default filters last 30 days by registration; search by ID/Name; metrics (clients, FTD, Qualified, Expected Commission) shown; customizable columns; totals row for monetary fields; CSV/XLSX export.

## Client Management (OWS/SWS)
- Defaults last 7 days by registration; PII visibility per OWS role; SWS shows PII; extensive fields per table; exports; filter builders.

## Agent Management
- View CPA ID scheme; registration source; KYC status; reassign sales/upstream CPA (permissioned); follow-up notes with timestamp/user; submit requests (plan change, reassign, cancel) with workflow status check.

## RBAC
- Role-based module/action/data permissions; menu visibility; field-level visibility for PII in OWS; audit logs on changes.