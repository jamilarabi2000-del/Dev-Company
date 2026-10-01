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

## Install it anywhere

`/dev-company` is a user-level command, so it works in every project, but only
where it has been installed. Each machine or cloud environment needs one setup.

**Cloud environment (every new session):** paste this into the environment's
Setup script (cloud environment menu in the session title bar, then Edit). It
is safe to re-run and never blocks a session if it fails:

```bash
rm -rf /tmp/dc-boot && git clone --depth 1 --branch main https://github.com/jamilarabi2000-del/Dev-Company /tmp/dc-boot && bash /tmp/dc-boot/.claude/agents/install.sh; rm -rf /tmp/dc-boot; true
```

**Your own computer:** run the same line once in a terminal, then restart
Claude Code (commands load at startup).

Requires access to github.com from that environment. It installs the agents,
the `/dev-company` command, and the CEO-routing block into `~/.claude/`.

A Claude Code plugin is not used on purpose: plugin commands and agents are
always namespaced (`/dev-company:dev-company`, `dev-company:ceo`), so the bare
`/dev-company` command is only possible as a user-level command. The plain
claude.ai chat and mobile app do not support custom commands or agents.

## The team (35 agents)

- **Executive:** `ceo`, `cto`, `ciso`
- **Engineering:** `vp-engineering`, `senior-backend-engineer`,
  `senior-frontend-engineer`, `mobile-engineer`, `qa-automation-engineer`,
  `devops-sre-engineer`, `qa-lead`, `code-reviewer`, `performance-engineer`
- **AI / ML:** `ai-research-lead`, `ml-engineer`, `ai-security-engineer`
- **Security:** `red-team-lead`, `blue-team-defender`, `soc-analyst`,
  `threat-intel-analyst`, `incident-response-lead`, `appsec-engineer`
- **Governance & Legal:** `grc-compliance-officer`, `legal-counsel`
- **Data:** `data-engineer`, `data-scientist`
- **Product & Design:** `product-manager`, `ux-designer`, `ux-researcher`
- **Infrastructure & IT:** `cloud-architect`, `it-sysadmin`
- **Business & Ops:** `project-manager`, `technical-writer`,
  `finance-controller`, `hr-lead`, `internal-auditor`

## Security posture

Defense-oriented by design. Any offensive security work (red team / pentest)
runs **only** against systems you own or are **authorized in writing** to test,
gated by the CISO and legal review. If authorization is unclear, the agents
stop and ask you. See the
[agents README](.claude/agents/README.md#security--authorization-policy-important)
for the full policy.
