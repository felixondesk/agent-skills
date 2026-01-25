# X Algorithm Skills

> Claude Code skills for creating viral content on X (Twitter) using the official open-sourced recommendation algorithm

## Overview

This repository contains a Claude Code skill that teaches you how to create content optimized for X's (Twitter's) recommendation algorithm. Every recommendation traces directly to the open-sourced algorithm codebase at [xai-org/x-algorithm](https://github.com/xai-org/x-algorithm).

### What This Does

Unlike generic "social media advice" that guesses at what works, this skill is based on the actual algorithm that powers X's "For You" feed:

- **15 Engagement Signals** - The exact signals the Phoenix ML model predicts
- **Two-Tower Retrieval** - How out-of-network content is discovered
- **Scoring Formula** - `Σ (weight × P(action))` - how posts are ranked
- **Author Diversity Penalty** - Why posting too much hurts your reach
- **Network Effects** - Converting out-of-network viewers to followers

## Installation

### Using skills.sh (Recommended)

```bash
npx skills add your-username/x-algo-skills
```

### Manual Installation

```bash
# Clone this repository
git clone https://github.com/your-username/x-algo-skills.git

# Copy to your Claude skills directory
cp -r x-algo-skills/skills/x-algo-mastery ~/.claude/skills/
```

## Usage

Once installed, use the skill in Claude Code:

```
Review this X post:

[your post content]
```

```
Will this go viral?

[your post content]
```

```
Optimize this for maximum reach:

[your post content]
```

## What Makes This Different

| Feature | Generic Advice | This Skill |
|---------|---------------|------------|
| **Source** | Opinions & guesses | **Official xai-org codebase** |
| **Signals** | Vague "engagement" | **15 documented predictions** |
| **Retrieval** | Not mentioned | **Two-tower model explained** |
| **Network Strategy** | Missing | **OON → in-network framework** |
| **Author Embedding** | Not addressed | **Candidate tower strategy** |
| **Pipeline** | Unknown | **7 documented stages** |

## Algorithm Fundamentals

### The 15 Engagement Signals

The Phoenix Grok-based transformer predicts:

**Positive Signals:**
- `favorite`, `reply`, `repost`, `quote`, `click`, `profile_click`, `video_view`, `photo_expand`, `share`, `dwell`, `follow_author`

**Negative Signals:**
- `not_interested`, `block_author`, `mute_author`, `report`

### Key Insights

1. **Post Length Matters** - Under 280 chars ensures full consumption (complete dwell signal)
2. **Author Diversity** - Multiple posts get exponentially reduced scores
3. **Network Bridge** - Converting OON → in-network is a permanent amplification
4. **Two-Tower Retrieval** - Consistent topical posting strengthens your author embedding

## Skills Included

### x-algo-mastery

Expert guidance on X's open-sourced recommendation algorithm. Use this skill to:
- Analyze post performance potential
- Optimize content for specific engagement signals
- Develop viral content strategies
- Understand algorithmic behavior

## Documentation

- [x-algo-mastery README](skills/x-algo-mastery/README.md) - Detailed usage guide
- [Official Algorithm](https://github.com/xai-org/x-algorithm) - Source documentation

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

All changes should trace back to the official [xai-org/x-algorithm](https://github.com/xai-org/x-algorithm) documentation.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- **xAI** for open-sourcing the recommendation algorithm
- The **home-mixer**, **thunder**, and **phoenix** teams
- The **Claude Code** team for the skills framework

---

**Built with ❤️ from the official source code**

Source: https://github.com/xai-org/x-algorithm
