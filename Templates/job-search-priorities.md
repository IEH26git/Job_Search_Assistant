# Job Search Priorities

Living reference for the agent to use during `/start` and `/sync`.
Update this file when constraints change.

---

## Financial Runway

Last day at previous role: **YYYY-MM-DD**
Target hire date: **YYYY-MM-DD**
Last severance/buffer date: **YYYY-MM-DD**

---

## Tier Definitions

**Tier 1 — Active Opportunities**
Tasks tied to real open jobs, waiting contacts, or overdue follow-ups. Always prioritize over everything else.
- Examples: submit application, follow up on submitted app, reach out to decision-maker, tailor résumé

**Tier 2 — Deadline Track**
Prep tasks with a hard external deadline.
- Examples: interview prep, application with close date, study sessions before applying

**Tier 3 — Portfolio & Visibility**
Makes you more visible and compelling. Do after at least one Tier 1 item is done.
- Examples: LinkedIn posts, Substack articles, portfolio site, CAIO outreach

**Tier 4 — System Building / Long-Term**
Valuable but not urgent. Move to Later unless Tier 1–3 are clear.

---

## Active Constraints

- Application deadlines: [list any hard-deadline roles]
- Follow-ups: check `Progress Log.md` for overdue follow-ups at every `/start` and `/sync`

---

## Known Dependency Chains

| Upstream (must be done first) | Downstream (blocked until then) |
|:------------------------------|:--------------------------------|
| Portfolio site live | Executive/CAIO outreach |
| Study sessions complete | Target application |

---

## Prioritization Rules for the Agent

When displaying the board at `/start`:
1. Show Today, This Week, Next Week with tier labels and target dates
2. Flag overdue items with ⚠️ and blocked items with ⛔
3. If Today has fewer than 2 items, propose the highest-priority unblocked This Week items
4. Max 2 items in Today
