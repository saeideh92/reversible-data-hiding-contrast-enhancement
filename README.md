# Reversible Data Hiding with Automatic Contrast Enhancement

MATLAB implementation of the two-sided histogram expansion method for reversible data hiding and automatic contrast enhancement.

**Publication:** S. Mansouri, H. Khaleghi Bizaki, and M. Fakhredanesh, “Reversible data hiding with automatic contrast enhancement using two-sided histogram expansion,” *Journal of Visual Communication and Image Representation*, vol. 81, article 103359, 2021.  
**DOI:** https://doi.org/10.1016/j.jvcir.2021.103359

## Overview

The proposed method combines reversible data hiding (RDH) with image contrast enhancement through two-sided histogram expansion. Two high-frequency histogram bins are selected as embedding peaks, while two low-frequency bins on the outer sides provide space for histogram shifting. Payload bits are embedded on both sides of the histogram, with associated side information enabling data extraction and cover-image recovery.

The experiments compare the proposed method with three contrast-enhancement RDH approaches: RDHCE, ACERDH, and brightness-preserving ACERDH (BP-ACERDH).

## MATLAB files

| Directory | Main contents |
| --- | --- |
| `proposed-method/` | Two-sided histogram embedding, extraction, BOSSBase experiments, and Kodak experiments |
| `baselines/ACERDH/` | ACERDH embedding, extraction, and image-set evaluations |
| `baselines/BP-ACERDH/` | Brightness-preserving ACERDH embedding and image-set evaluations |
| `baselines/RDHCE/` | RDHCE single-round embedding/extraction, multi-round embedding, and image-set evaluations |

Individual scripts are named according to their algorithm and task. The embedding and extraction scripts operate on grayscale image data; the image-set analysis scripts calculate quality and embedding-capacity measurements across multiple inputs.

## Image datasets

The study uses two standard image datasets:

| Dataset | Image collection used in the study | Purpose |
| --- | --- | --- |
| **BOSSBase 1.01** | 620 grayscale images at 512 × 512 resolution | Quantitative evaluation over a range of embedding capacities |
| **Kodak Lossless True Color Image Suite** | 24 images at 512 × 768 resolution, converted to grayscale | Image-level experiments and visual assessment of contrast enhancement |

The BOSSBase and Kodak images are not included in this repository. Image numbering in the MATLAB scripts follows the experiment filenames: numbered `.pgm` images for BOSSBase and `kodim*.png` images for Kodak.

## Requirements and data paths

- **MATLAB**, with image-processing functionality used by the scripts (including functions such as `psnr`, `ssim`, `rgb2gray`, and `entropy`).
- MATLAB functions `de2bi` and `bi2de`, available through the relevant toolbox or release-specific equivalents.
- Locally available copies of the input images and the MAT-files referenced by each script.

Before running a script, set the relevant file and directory paths:

| Path field | Expected input |
| --- | --- |
| `PATH_TO_BOSSBASE_DIRECTORY` | Folder containing numbered BOSSBase `.pgm` images |
| `PATH_TO_KODAK_DIRECTORY` | Folder containing the Kodak `kodim*.png` images |
| `PATH_TO_DATA2_MAT_FILE` | MAT-file containing the message bit sequence in variable `data` |
| `PATH_TO_DATA_MAT_FILE` | MAT-file used by scripts that load `data.mat` |

Other file references, including `BNum.mat`, `NCapa.mat`, example input images, and generated stego images, are resolved relative to the MATLAB working directory unless a path is specified in the script. Set these inputs according to the experiment being run.

The scripts are organized by experiment and may rely on input variables or images generated in another MATLAB session. Refer to the associated publication for the evaluation protocol and reported numerical results.

## Evaluation

The study examines embedding capacity, payload rate, contrast enhancement, image quality, mean brightness preservation, and computational time. Reported metrics include **PSNR**, **SSIM**, **BRISQUE**, **RCE**, **REE**, and **RMBE**. Individual MATLAB analysis scripts calculate subsets of these measures; the complete experimental results are described in the paper.

## Citation

```bibtex
@article{mansouri2021reversible,
  title={Reversible data hiding with automatic contrast enhancement using two-sided histogram expansion},
  author={Mansouri, Saeideh and Khaleghi Bizaki, Hossein and Fakhredanesh, Mohammad},
  journal={Journal of Visual Communication and Image Representation},
  volume={81},
  pages={103359},
  year={2021},
  doi={10.1016/j.jvcir.2021.103359}
}
```
