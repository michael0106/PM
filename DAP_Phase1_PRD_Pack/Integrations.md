## Systems
- Sumsub: KYC (POI/POA) SDK/API; webhook for status updates.
- Security Center 1.0: Email/Phone/Password verification and modification flows; OTP endpoints.
- CRM Admin: Orgs/Users/Sales, blacklist, country code lists, country groups, leads/notes (where applicable), website IDs.
- Client/IB Portals: Upgrade triggers and shared KYC state per UserID; redirect patterns.
- Payments Platform: Commission payout and internal transfers; approval steps; risk thresholds.
- BI/Data Platform: Metrics ingestion, dashboards; allocation and commission events.
- Apollo/Config: Forbidden countries.
- SWS/OWS: Messages, tasks, records, role management.

## Integration Contracts (to define)
- KYC Webhooks: eventType, userId, clientType (CPA), status (pending/approved/rejected), timestamps, operator.
- Security Center Flows: start/verify endpoints for email/phone/password; tokens and TTLs.
- Commission Events: emit schema with clientUserId, cpaAccountId, type, amountUSD, periodKey, createdAt, currency=USD.
- Allocation Rules CRUD: rule schema with blocks/conditions/operators/effective; priority update API.
- Agreement Generation: templateId, planSnapshot, cpaAccountId; status callbacks on confirmation.
- Payout Application: create/review/approve; payment record creation; status sync.
- Notifications: message types (Upgrade, KYC statuses, Allocation), recipients (roles/users), channels (email/SWS/SMS).