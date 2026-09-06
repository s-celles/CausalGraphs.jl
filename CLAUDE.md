# Claude Code Preferences

## Git Commits
- GitHub handle: s-celles
- Name: Sébastien Celles
- use a gitallow pattern for .gitignore
- disclose ai usage without model name, never include "Generated with [Claude Code]" or "Co-Authored-By: Claude" or any Co-Authored-By message to commit messages, PR descriptions or anywhere in the project. Use Assisted-by: AI
- Do NOT modify .gitignore (if that's necessary ask using !!! CAPITAL LETTERS !!!)
- Never try to git add CLAUDE.md AGENTS.md spec.md file or specs/ .claude/ .specify/ folders
- Use conventional commit format (feat:, fix:, refactor:, docs:, test:, chore:, etc.)
- Project MUST adhere to "Semantic Versioning"
- write code, comment and doc in english
- run tests before committing code changes
- build doc (without warning) before committing code changes
- All notable changes MUST be documented in CHANGELOG.md in a "Keep a Changelog" format
- Always document in docs/ new feature
- provide llms.txt and llms-full.txt thanks to documentation (ie not at repository root)
- Always write tests before writing code (TDD)
- create a justfile for main entry points
- if you find upstream bug create entry in upstream-bugs.md file
- Use Julia development skill and latest methods for automated code quality (DependaBot, TagBot, CompatHelper, ...) with BestieTemplate.jl. SECURITY.md (with GHSA disclosure) and LICENSE.md are required for new packages.
- For Julia TDD prefer using TestItemRunner.jl over Tests.jl

## Active Technologies
- (placeholder)

## Recent Changes
- (placeholder)
