## Core Entities (key fields)

- User
  - userId (passport, unique), username, email, phone (cc + number), states [CPA/IB/Client/Affiliate], kycStatus (POI/POA), createdAt

- CPAAccount
  - cpaAccountId, userId, brandReg (BRegulation), country, salesOwnerId, status, createdAt

- SalesUser
  - salesUserId, username, orgId, roles[], active

- Organization
  - orgId, name, regionTag (APAC/GS/CR), parentId

- RegulationMapping
  - domain, defaultReg, overrides (by inviter org/country), countryGroups[]

- CountryGroup
  - groupId, name, countryIsoCodes[]

- CommissionPlan
  - planId, mode (Deactivate/CPAByCountry/FTD/Progressive), qualificationRuleId, applicationScope (Incremental/Full, lookbackMonths), transferRetriggerRuleId, monthlyBonusRuleId, settlementCycle (Week/BiWeek/Month), activeFrom, activeTo, requiresAgreementUpdate (bool)

- CommissionRule
  - planId, ruleset (per mode):
    - CPAByCountry: entries [{targetType: Country|Group|ELSE, targetId?, payoutUSD}]
    - FTD: tiers [{from, to, payoutUSD}]
    - Progressive: tiers [{from, to, payoutUSD}] (strictly increasing payout)

- QualificationRule
  - ruleId, netDepositMin, indicesLotMin, nonIndicesLotMin, positionCountMin

- TransferRetriggerRule
  - ruleId, monthlyOnce (bool)

- MonthlyBonusRule
  - ruleId, roiOperator (>,>=,<,<=,=), roiThreshold, headcountMin, autoAfterFirstApproval (bool)

- Agreement
  - agreementId, cpaAccountId, planSnapshot, status (Pending/Confirmed/Rejected), createdAt, confirmedAt

- LeadAllocationRule
  - ruleId, name, status, priority, blocks[{conditions[] (OR)}] ANDed, assignees[salesUserId], effectiveType (immediate/delayed/scheduled), effectiveAt, notes, updatedAt, operatorId

- AllocationRecord
  - recordId, userId, brand, fromSalesId, toSalesId, status (InQueue/Completed/Recycle/NotPursue), resourcePool, ruleRef, triggerTime, allocationTime

- CommissionEvent
  - eventId, clientUserId, cpaAccountId, type (QFTD/ProgressiveAdjust/TransferRetrigger/Bonus), amountUSD, periodKey, settled (bool), createdAt, linkedRecords[]

- PayoutApplication
  - applicationId, cpaAccountId, cycleType, periodKey, amountUSD, status (Pending/Approved/Rejected/Paid), approvals[], paymentRecordId?

- Adjustment
  - adjustmentId, scope (CPA/Client/Period), amountUSD (+/-), reason, operatorId, createdAt, links[]

- Client
  - userId, name, brandReg, country, salesOwnerId, upstreamCpaAccountId, kycStatus, status, registeredAt

- Message
  - messageId, type, eventType, payload, recipients[], createdAt

- BlacklistEntry
  - userId?, email?, phone?, reason, active

- ForbiddenCountry
  - isoCode, active, notes

- AuditLog
  - logId, actorId, action, entityType, entityId, before, after, createdAt