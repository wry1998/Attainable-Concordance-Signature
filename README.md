# Attainable Concordance Signature on Swiss Market Index

Under the supervision of Prof. Johanna Nešlehová, I conducted an undergraduate research project motivated by McNeil et al. (2020) on attainable concordance signatures—the collection of concordance probabilities over the power set that characterizes multivariate dependence beyond pairwise measures. I proposed an applied study using the Swiss Market Index (SMI), which contains 20 constituents with two lack complete histories, making the attainable-set framework directly relevant.

---------------------------------------------------------

## Project Goal

The project aimed to answer the following questions:

- How can we study multivariate dependence when some components have partially or fully missing histories?
- How can we reduce dimensionality when the computation of concordance signatures scales exponentially with dimension? Is the commonly used **higher-order independence** simplification actually attainable in this dataset?
- What does the attainable set of concordance signatures look like on subsets of Swiss Market Index?

***************************************

## Data

The dataset consists of the **adjusted daily prices of the 20 SMI component stocks in 2020**, downloaded from Yahoo Finance.

Two components created incompleteness in the panel:

- **PGHN**: only available after September 18, 2020, because it was newly added to the index
- **ALC**: treated as fully missing, since its price series was quoted in a different currency unit from the other stocks

After cleaning:

- **18 stocks** had nearly complete histories
- **PGHN** had only a partial history
- **ALC** was treated as fully missing

***************************

## Methodology


## Empirical Results




## Limitations

The main limitation is computational.

Because the number of concordance-signature coordinates grows exponentially with dimension, the full 15-dimensional problem (13 clusters + PGHN + ALC) was too expensive to compute directly. As a result, the empirical study focused on carefully chosen lower-dimensional subsets.

A more complete analysis in larger dimensions would require either:

- stronger structural assumptions, or
- more efficient computational methods for vertex enumeration and convex-hull analysis




## Repository Contents

```text
.
├── data/               # cleaned or intermediate data files
├── code/               # R scripts for preprocessing, clustering, and attainability analysis
├── report/             # final written report
└── README.md
```

## References

