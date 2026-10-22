# Attainable Concordance Signature on Swiss Market Index

This repository contains my undergraduate research project, where I proposed an applied study of attainable concordance signatures using the Swiss Market Index (SMI). This project was motivated by [McNeil et al., 2022](#mcneil2022) and supervised by Professor Johanna Nešlehová.

This project aimed to answer the following questions:

- How can we study multivariate dependence when some components' data are not available?
- What does the attainable concordance signatures look like on Swiss Market Index?
- How can we study the full attainable concordance signature when the computation scales exponentially with dimension?

------------------------------

## Data

The dataset contains the **log returns of the 20 SMI components from 2020-01-01 to 2020-12-31**, downloaded from Yahoo Finance. After cleaning:

- 18 stocks are considered to have complete histories. 
- PGHN has only a partial history, as it was newly added to the index after September 18, 2020.
- ALC is treated as data unavailable, since its price is in a different currency from the other stocks.

To remove auto-correlations driven by volatility clustering, I fitted a **GARCH(1,1)** model to each stock using either **Gaussian** or **scaled-t innovations**, and used the standardized residuals for dependence modeling.

Model adequacy was checked using:

- **auto-correlograms** of absolute residuals and **Portmanteau tests** to check for auto-correlation.
- **QQ plots** and **histograms** to valid distribution assumptions of Gaussian or scaled-t.

------------------------------------------------------

## Methodology
(Note that the theoretical framework of this project is based entirely on [McNeil et al., 2022](#mcneil2022). I only summarized the key formulas here, please refer to the original paper for more details.)

For a set of variables $\mathcal{X}$, its **concordance signature** is defined as the collection of concordance probabilities $\kappa_I$ over all subsets of the index set $D$ of $X$:		

```math
\kappa_I = \mathbb{P}\left(\{\boldsymbol{X}_I \leq \boldsymbol{X}_I^*\} \cup \{\boldsymbol{X}_I^* \leq \boldsymbol{X}_I\}\right)
= 2\int_{[0,1]^{|I|}} C_I(\boldsymbol{u})\,dC_I(\boldsymbol{u})
```

For elliptical distributions, concordance signature can be generated from the Kendall's tau matrix:

$$
\kappa_I = 2\mathbb{P}(\boldsymbol{Z}_I \leq \boldsymbol{0}), \quad
\boldsymbol{Z} \sim N_d(\boldsymbol{0},\boldsymbol{P}), \quad
(\boldsymbol{P})_{ij} = \rho_{ij} = \sin\left(\frac{\pi}{2}\tau_{ij}\right)
$$

Also, odd-order concordance signatures can be derived from even ones, so the full concordance signature is determined soley by the probabilities of concordance of even subsets. The methodology for attainable concordance signature is thus based on the even-order concordance signarures. 

Not any concordance signature is attainable. The set of attainable concordance signatures is given by the convex hull:

$$
\mathbb{K} =
\left\{
\sum_{k=1}^{2^{d-1}} w_k \boldsymbol{a}_k :
w_k \geq 0, k=1,\ldots,2^{d-1},
\sum_{k=1}^{2^{d-1}} w_k = 1
\right\}
$$

Thus, given a partial concordance signature $\kappa_S$, it is attainable if we can find a non-negative weight vector that satisfies:

$$
A_d^S w = \kappa_S, \quad
A_d^S \text{ consists of the rows of } \boldsymbol{A}_d = (\boldsymbol{a}_k) \text{ indexed by } S
$$	

And, if the partial concordance signature is attainable, the set of attainable remaining concordance signature is 

$$
\mathbb{K}^C = \left\{
A_d^C w : w \text{ is a solution to } A_d^S w = \kappa_S
\right\}
$$

Using this framework, I analyzed the dependence structure of SMI.

--------------------------------------------------------

## Empirical Results

The computation of attainable concordance signature is done via R package [`KendallSignature`](https://github.com/ajmcneil/KendallSignature). Since the computation scales as **$O(2^d)$**, computation time was a major obstacle in this study. I tried several approaches to resolve this issue:

- Setting higher-order concordance terms to zero, and
- Partition the stocks into PEA clusters, and
- Starting with a small subset then generalizing the result to the whole index.

### Attainability of zero higher-order dependence 

Setting $\kappa_I=0$ for all subsets $|I|>2$ could greatly reduce the computation, but I had to verify it's attainability first. 

I chose several subsets from SMI to apply the attainability check. I first generated the concordance signature from the Kendall's tau matrix directly, then I set $\kappa_I = 0$ for every $|I| > 2$ and checked its attainability via the `attainable()` function in [`KendallSignature`](https://github.com/ajmcneil/KendallSignature). Unfortunately, after checking on several subsets, I concluded that this simplification was in general not attainable in the case of SMI.


### Dimension reduction via PEA clustering

I then tried to partition the stocks into clusters that satisfy the **Partial Exchangeability Assumption (PEA)**:
For a partition $G=\{G_1,...,G_k\}$ of $X_1,...,X_d$, any permutation $\pi(1),...,\pi(d)$ that preserves the partition also preserves the copula:

$$
C(u_1,...,u_d) = C(u_{\pi(1)},...u_{\pi(d)})
$$

Since concordance signature is determined only by copulas, one can choose a stock from each cluster to construct the analysis of pairwise concordance signature of SMI. This would also greatly reduce computation if we can partition the stocks into a small number of clusters.

I applied the algorithm in [Perreault et al., 2019](#Perreault2019) (I leveraged the code in [learning-block-exchangeability](https://github.com/samperochkin/learning-block-exchangeability/tree/master)) to search for the optimal partition, and **compressed the 18 stocks to 13 clusters**. However, 15 (13 clusters + PGHN + ALC) was still too expensive to compute directly, so I had to consider other approaches.


### Attainable concordance signature on SMI

I then tried to started the analysis with a small subset, {UBSG, LHN, LONN, PGHN}, with {UBSG, LHN, LONN} provides the partial concordance signature, and PGHN lack of information (it has a partial history and thus cannot be used to estimated the Kendall's tau matrix). I estimated the set of attainable pairwise concordance signature, and plotted it as a convex polyhedron as well as the 2-D projections of the polyhedron. I then repeated the process by adding more stocks into the analysis. 

I discovered that adding more stocks only complicates the convex hull, but does not change its lower-dimensional projections. This means that although I may not be able to get the full attainable concordance signature of SMI, I was able to obtain the partial information about the attainable dependence structures through its low-dimensional projections.

------------------------------------------------------------------

## Repository Structure

```text
.
├── code/                        # Sample R code
│   ├── 01_Data Preprocessing.R  # Fit GRACH(1,1) models, generate residuals, check fitt
│   ├── 02_Reducing Dimension.R  # Reduce dimension, prepare kendall's tau matrix for concordance calculation
│   └── 03_Empirical Results.R   # Attainability of higher-order independence, set of attainable concordance signature, pairwise concordance signature estimation
├── report/                      
│   └── report.pdf               # Final report
└── README.md
```

--------------------------------------------------

## References

<a id="mcneil2022"></a>
**McNeil, A., Nešlehová, J., & Smith, A. (2022).**  
On attainability of Kendall’s tau matrices and concordance signatures.

<a id="Perreault2019"></a>
**Perreault, S., Duchesne, T., & Nešlehová, J. G. (2019).**  
Detection of block-exchangeable structure in large-scale correlation matrices.

---
*For an overview of my research projects, see my [research portfolio](https://github.com/wry1998/research-portfolio).*
