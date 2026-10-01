# Dev-Company — a full virtual company of Claude Code agents

This directory defines a complete technology, software-development, and
cybersecurity **company** as Claude Code subagents. It mirrors how a real firm
(like a CrowdStrike or Cisco) is organized: a **CEO** who reports to **you (the
owner)** and makes the final day-to-day call, with every department beneath.

## How to use it

- **Run `/dev-company <task>`.** The fastest way in — a slash command
  (installed in this repo and at the user level) that routes your request to
  the CEO. Run `/dev-company` with no arguments for an intro and roster.
- **Talk to the CEO.** For anything multi-step or strategic, ask Claude to use
  the `ceo` agent (e.g. *"CEO, plan and build X"*). The CEO frames the goal,
  delegates to the right departments, integrates the work, and reports back to
  you with decisions, trade-offs, and recommendations. **CEO routing is the
  default** — a `CLAUDE.md` (in this repo and at the user level) tells Claude to
  route to the `ceo` agent whenever you say *"Dev-Company"*, *"the company"*,
  *"the team"*, or *"CEO"*, or ask for broad end-to-end work.
- **Or call a specialist directly** when you know who you need
  (e.g. *"ask the appsec-engineer to review this diff"*).
- Claude Code can also auto-delegate to these agents based on their
  `description` fields.

## Available in every project

These agents are installed at the **user level** (`~/.claude/agents/`), so the
company is available in *any* project on this account — not just this repo. A
version-controlled copy also lives in this repo under `.claude/agents/`.
Run `.claude/agents/install.sh` to (re)install the user-level copy on any
machine. The installer also adds a small managed **Dev-Company** block to
`~/.claude/CLAUDE.md` so CEO routing works globally — it merges safely and
never clobbers your existing `CLAUDE.md`.

## Org chart

```
                                YOU (Owner)
                                    │  final approval & direction
                                    ▼
                                 ┌─────┐
                                 │ CEO │  single point of contact, final day-to-day call
                                 └──┬──┘
          ┌───────────────┬────────┼─────────┬───────────────┬───────────────┐
          ▼               ▼        ▼         ▼               ▼               ▼
        ┌─────┐        ┌──────┐  ┌───────────────┐   ┌──────────────┐  ┌──────────────┐
        │ CTO │        │ CISO │  │ VP Engineering│   │ Product/Design│  │  Business/Ops│
        └──┬──┘        └──┬───┘  └──────┬────────┘   └──────┬───────┘  └──────┬───────┘
           │              │             │                   │                 │
   ┌───────┼────────┐     │      ┌──────┼───────┐    ┌──────┴──────┐   ┌──────┼────────────┐
   ▼       ▼        ▼     │      ▼      ▼       ▼    ▼             ▼   ▼      ▼            ▼
 AI/ML   Data    Cloud/IT │  backend frontend mobile product-mgr ux  project finance   hr-lead
   │       │        │      │   qa       devops                        -manager -controller
   │       │        │      │                                          technical-writer
   │       │        │      ▼
   │       │        │   SECURITY DEPARTMENT (defensive + AUTHORIZED offensive)
   │       │        │   ├─ red-team-lead        (authorized pentest / threat emulation)
   │       │        │   ├─ blue-team-defender   (hardening & detection)
   │       │        │   ├─ soc-analyst          (monitoring & triage)
   │       │        │   ├─ threat-intel-analyst (threat research)
   │       │        │   ├─ incident-response-lead (DFIR)
   │       │        │   ├─ appsec-engineer      (secure code & SDLC)
   │       │        │   ├─ grc-compliance-officer (SOC2/ISO/GDPR…)
   │       │        │   └─ legal-counsel        (authorization & contracts)
   │       │        │
 ai-research-lead  data-engineer   cloud-architect
 ml-engineer       data-scientist  it-sysadmin
 ai-security-engineer
```

## Full roster (35 agents)

| Department | Agents |
|---|---|
| **Executive** | `ceo`, `cto`, `ciso` |
| **Engineering** | `vp-engineering`, `senior-backend-engineer`, `senior-frontend-engineer`, `mobile-engineer`, `qa-automation-engineer`, `devops-sre-engineer`, `qa-lead`, `code-reviewer`, `performance-engineer` |
| **AI / ML** | `ai-research-lead`, `ml-engineer`, `ai-security-engineer` |
| **Security** | `red-team-lead`, `blue-team-defender`, `soc-analyst`, `threat-intel-analyst`, `incident-response-lead`, `appsec-engineer` |
| **Governance & Legal** | `grc-compliance-officer`, `legal-counsel` |
| **Data** | `data-engineer`, `data-scientist` |
| **Product & Design** | `product-manager`, `ux-designer`, `ux-researcher` |
| **Infrastructure & IT** | `cloud-architect`, `it-sysadmin` |
| **Business & Ops** | `project-manager`, `technical-writer`, `finance-controller`, `hr-lead`, `internal-auditor` |

## Security & authorization policy (important)

This company is **defense-oriented**. Any offensive security activity
(red-team, penetration testing, exploit development, intrusive scanning) runs
**only** against assets you own or are **authorized in writing** to test, and
only after the **CISO's go/no-go** and `legal-counsel` confirm scope and
rules of engagement. If authorization is unclear, the agents stop and ask you.
The agents will not help attack systems you don't own or lack permission to
test. Advisory roles (`legal-counsel`, `finance-controller`) are not a
substitute for a licensed professional.
