# Worked example — a risky change done right

**`fix(checkout): prevent duplicate orders on payment retry`**

### Why

Closes PROJ-2311. When Stripe returned a timeout, our retry created a second `Order` row. 47 duplicate orders in the last 30 days, ~$8k in manual refunds. Root cause: the idempotency key was generated per-request instead of per-checkout-session.

### What

- Move idempotency key generation to session creation, persist it on `checkout_sessions`
- Reuse the stored key on every retry for that session
- Add a unique partial index on `orders(idempotency_key)` as a DB-level backstop

### How to test

1. Start checkout, use Stripe test card `4000 0000 0000 0259` (timeout)
2. Retry twice from the error screen
3. Verify a single row in `orders`, single charge in the Stripe dashboard

Covered by `checkout_retry_spec.rb:88` (new).

### Risks & rollout

- Migration adds a unique index concurrently — no table lock, safe on the 2M-row table
- Existing in-flight sessions have `NULL` keys; the index is partial (`WHERE idempotency_key IS NOT NULL`) so they're unaffected
- Behind `checkout_idempotency_v2` flag, rolling out at 10% -> 100% over 3 days
- Rollback: flip the flag off; the index is harmless if unused

### Notes for reviewer

Start at `CheckoutSession#idempotency_key` — that's the whole change. The rest of the diff is the migration and test fixtures.

I considered deduplicating in the webhook handler instead, but that leaves a window where the user sees two orders before the webhook lands. Rejected.

## Why this works

- The Why quantifies the pain (47 orders, $8k) and names the root cause — none of which is in the diff.
- How to test gives exact reproduction steps including the magic test card number.
- Risks address the three prod questions up front: lock behaviour, legacy rows, rollback.
- Notes point the reviewer at the one hunk that matters and pre-answer the obvious alternative.
