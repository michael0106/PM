## Registration Sources
- Website (no params) → CPA-House; CPA invite → Sub CPA; Sales invite → Sales; Transfers: Client->CPA; IB->CPA.
- Duplicate handling: email → phone; map to existing state and route per rules.

## Regulation Assignment (V1/V2)
- By domain defaults; override by inviter (sales/IB org) or CPA invite chain; fallback by country/APAC list; BRegulation = Brand + Regulation.

## Client Upgrade to CPA
- Client Portal: button visible per admin setting; KYC gate; submit → OWS task; emails to sales leads per org; OWS audit picks sales owner + plan; approve → CPA Account ID created; CPA Portal notified.

## OTP + KYC
- Security Center 1.0 for email/phone/password flows; Sumsub POI/POA; OWS manual audit; messages: Pending/Approved/Rejected for POI/POA; feature gates applied.

## Commission Calculation
- QFTD detection per plan qualification; emit event for payout period; Progressive tracks cumulative deposits over lifetime and emits delta when tier increases.
- Application Scope changes: affect only un-settled items; settled remain; Full scope may backfill up to 12 months qualified-unsettled.

## Transfer Re-trigger
- Upon upstream CPA change: if Client already QFTD previously, use transfer re-trigger rule; max once per natural month; independent of plan cycle; records linked to new CPA.

## Monthly Bonus
- Each natural month per CPA: count QFTD clients; compute ROI; if meets rule, create bonus event; first after rule change requires manual approval, then auto.

## Lead Allocation (CPA)
- On CPA creation/update events: evaluate rules by priority; if match → assign to selected sales round-robin or list order; record status; support delayed/scheduled effect.

## Agreements
- When plan updated and agreement required: generate from template; push to CPA Portal; CPA confirms to activate; else keep pending; archive all versions.

## Payments
- CPA applies per allowed cycle; OP/Finance review; adjustments applied; approve creates payment record; Funds module executes payout/internal transfer via downstream systems; status synced back.