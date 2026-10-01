# Dev-Company

A complete **virtual technology & cybersecurity company**, implemented as
[Claude Code](https://claude.com/claude-code) agents — modeled on how a real
firm (think CrowdStrike / Cisco) is organized: a **CEO who reports to you** and
makes the final day-to-day decision, with every department beneath.

The full org chart, roster, usage, and security policy live in
**[`.claude/agents/README.md`](.claude/agents/README.md)**.

## Quick start

- **Run the slash command:** `/dev-company <what you want done>` — routes your
  request to the CEO, who delegates across departments and reports back. Run
  `/dev-company` with no arguments for an intro and the roster.
- **Use the company in this repo:** the agents are already in `.claude/agents/`.
  Ask Claude: *"CEO, plan and build …"* and the CEO will delegate across
  departments and report back to you.
- **Use it in every project:** run the installer once to add the company at the
  user level (`~/.claude/agents/`), so it's available in any Claude Code
  project on this machine/account:

  ```bash
  bash .claude/agents/install.sh
  ```

- **Auto-install:** `.claude/settings.json` has a `SessionStart` hook that runs
  `install.sh` whenever Claude Code starts in this project, so the user-level
  install refreshes itself (and self-heals after a container reset). It is
  failure-safe (`|| true`) and never blocks startup. Note it fires when a
  session starts *in this repo*; in a brand-new environment, open the repo once
  (or run the installer) and the company becomes global from then on.

- **Call a specialist directly:** e.g. *"ask the `appsec-engineer` to review
  this diff"* or *"have the `cloud-architect` design the infra."*

## The team (30 agents)

- **Executive:** `ceo`, `cto`, `ciso`
- **Engineering:** `vp-engineering`, `senior-backend-engineer`,
  `senior-frontend-engineer`, `mobile-engineer`, `qa-automation-engineer`,
  `devops-sre-engineer`
- **AI / ML:** `ai-research-lead`, `ml-engineer`, `ai-security-engineer`
- **Security:** `red-team-lead`, `blue-team-defender`, `soc-analyst`,
  `threat-intel-analyst`, `incident-response-lead`, `appsec-engineer`
- **Governance & Legal:** `grc-compliance-officer`, `legal-counsel`
- **Data:** `data-engineer`, `data-scientist`
- **Product & Design:** `product-manager`, `ux-designer`
- **Infrastructure & IT:** `cloud-architect`, `it-sysadmin`
- **Business & Ops:** `project-manager`, `technical-writer`,
  `finance-controller`, `hr-lead`

## Security posture

Defense-oriented by design. Any offensive security work (red team / pentest)
runs **only** against systems you own or are **authorized in writing** to test,
gated by the CISO and legal review. If authorization is unclear, the agents
stop and ask you. See the
[agents README](.claude/agents/README.md#security--authorization-policy-important)
for the full policy.
