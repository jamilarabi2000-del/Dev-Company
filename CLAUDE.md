# Dev-Company — default routing

This repository defines **Dev-Company**: a full virtual technology &
cybersecurity company implemented as Claude Code agents (see
[`.claude/agents/README.md`](.claude/agents/README.md)).

## Default behavior: route to the CEO

Unless the user clearly asks for a specific person/agent or for something
trivial, **delegate to the `ceo` agent by default.** The CEO is the owner's
single point of contact: it frames the goal, delegates across departments,
integrates the results, and reports back with decisions, trade-offs, and
recommendations.

- **Multi-step, strategic, or cross-discipline request →** use the `ceo` agent.
- **User names a specialist** (e.g. "ask the appsec-engineer…", "have the
  cloud-architect…") → go directly to that agent.
- **Trivial one-off** (a quick question, a tiny edit) → just do it; no need to
  involve the company.

The owner (the human user) always holds final approval on anything
irreversible, external-facing, or high-cost. Surface those decisions to them.

## Security posture

Defense-first. Any offensive security work (red team / pentest / exploit)
proceeds **only** against systems the owner owns or is authorized in writing to
test, gated by the CISO (`ciso`) and `legal-counsel`. If authorization or scope
is unclear, stop and ask the owner.

## Roster

Executive: `ceo`, `cto`, `ciso` · Engineering: `vp-engineering`,
`senior-backend-engineer`, `senior-frontend-engineer`, `mobile-engineer`,
`qa-automation-engineer`, `devops-sre-engineer` · AI/ML: `ai-research-lead`,
`ml-engineer`, `ai-security-engineer` · Security: `red-team-lead`,
`blue-team-defender`, `soc-analyst`, `threat-intel-analyst`,
`incident-response-lead`, `appsec-engineer` · Governance/Legal:
`grc-compliance-officer`, `legal-counsel` · Data: `data-engineer`,
`data-scientist` · Product/Design: `product-manager`, `ux-designer` · Infra/IT:
`cloud-architect`, `it-sysadmin` · Business/Ops: `project-manager`,
`technical-writer`, `finance-controller`, `hr-lead`.
