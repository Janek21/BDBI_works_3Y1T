#!/bin/bash
pandoc -f "markdown+pipe_tables+header_attributes+raw_tex+latex_macros+tex_math_dollars+citations+yaml_metadata_block"             --template=docs/BScBI_CompGenomics_template.tex        -t latex --natbib                 --number-sections                 --highlight-style pygments        -o README_BScBICG2425_exercise00_SURNAME_NAME.tex README_BScBICG2425_exercise00_SURNAME_NAME.md
