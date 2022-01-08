# Jupyter book template for Julia Jupyter notebooks

Features:

- [Jupyter book](https://jupyterbook.org/index.html) turns `md` and `ipynb` files into webpages.
- GitHub actions build and publish the website whenever changes are committed.


## Commands

### Install Julia dependencies without updating

```bash
julia --project=. --color=yes --threads=auto -e 'using Pkg; Pkg.instantiate()'
```

### Update Julia dependencies


```bash
julia --project=. --color=yes --threads=auto -e 'using Pkg; Pkg.update()'
```

### Run all the notebooks locally

Using

- Julia
- Jupyter's `nbconvert`
- GNU `parallel`

```bash
find . -type f -name '*.ipynb' -print0 | parallel -0 -j$(nproc) jupyter nbconvert --to notebook --ExecutePreprocessor.timeout=600 --execute --inplace {}
```
