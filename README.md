# homebrew-tap

Homebrew formulae for my open source tools.

```sh
brew tap asger-weirsoee/tap
brew install ubl-tools   # read UBL e-invoices (Peppol, OIOUBL) offline: ubl view invoice.xml
brew install ahfail      # "ah ah ah, you didn't say the magic word" on a failed screen unlock
```

| Formula | Source |
|---|---|
| `ubl-tools` | [gitea.weircon.dk/agw/ubl-tools](https://gitea.weircon.dk/agw/ubl-tools) |
| `ahfail` | [gitea.weircon.dk/agw/gtk-ahfail](https://gitea.weircon.dk/agw/gtk-ahfail) |

The code lives on my own Gitea; this tap only holds the formulae, which the
release pipelines there update on every tag. Arch Linux packages and Windows
builds are on [asger.weirsøe.dk/tarballz](https://asger.weirsoe.dk/tarballz/).
