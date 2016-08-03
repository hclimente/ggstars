# ggstars
Easily add significance marks to your ggplots.

## Install

Install it directly from GitHub:

```{r}
library(devtools)
install_github("hclimente/ggstars")
```

## Usage

### On barplot

```{r}
library(ggstars)

data(spliced)

star_bar(p, spliced$p < 0.05)

```
