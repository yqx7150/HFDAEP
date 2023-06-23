# HFDAEP
The Code is created based on the method described in the following paper:          
Zhuonan He, Kai Hong, Jinjie Zhou, Dong Liang, Yuhao Wang, Qiegen Liu.        
Deep Frequency-Recurrent Priors for Inverse Imaging Reconstruction.       
Signal Processing, Volume 190, January 2022, 108320.     
https://www.sciencedirect.com/science/article/pii/S0165168421003571       
   
## Motivation
Ill-posed inverse problems in imaging remain an active research topic in several decades,with new approaches constantly emerging. Recognizing that the popular dictionary learning and convolutional sparse coding are both essentially modeling the high-frequency component of an image, which convey most of the semantic infor-mation such as texture details, in this work we propose a novel multi-profile high-frequency transform-guided denoising autoencoder for attainting deep frequency-recurrent prior (DFRP). To achieve this goal, we first extract a set of multi-profile high-frequency components via a specific transformation and add artificial Gaussian noise to these high-frequency components as training samples. As the high-frequency prior information is learned, we incorporate it into classical iterative reconstruction by proximal gradient descent. Preliminary results on highly under-sampled magnetic resonance imag-ing and sparse-view computed tomography reconstruction demonstrate that the proposed method can efficiently reconstruct feature details and present advantages over state-of-the-arts.

## version
In order to effectively use the high-frequency prior information to reconstruct the texture details of the image, we designed two different schemes. Here we call them HFDAEP_v1 and HFDAEP_v2.

In this paper, we use the image decomposition and component summation to approximate the forward and inverse transformations.

![repeat-HFDAEPRec](https://github.com/yqx7150/HFDAEP/blob/master/HFDAEP_v1/figs/forward%20and%20backward.png)
Fig. 1. Demonstration of (a) the forward transform operator and (b) the backward transform operator in HF-DAEP.

![repeat-HFDAEPRec](https://github.com/yqx7150/HFDAEP/blob/master/HFDAEP_v1/figs/itermri.png)
Fig. 2. Illustration of HF-DAEP at iterative reconstruction phase. Here MRI reconstruction is visualized.

## HFDAEP_v1
### Table
![repeat-HFDAEPRec](https://github.com/yqx7150/HFDAEP/blob/master/HFDAEP_v1/figs/table.png)

### Visual Comparisons
![repeat-HFDAEPRec](https://github.com/yqx7150/HFDAEP/blob/master/HFDAEP_v1/figs/result.png)
Fig. 3. Visual comparisons under 2D Random sampling at 80%. Top line: reference image, reconstruction using DLMRI, PANO and FDLCP; Bottom line: reconstruction using NLR-CS, DC-CNN, EDAEP and HFDAEP.

### MRI reconstruction
'./HFDAEP_v1/DemoMRI/demo_MRI.m' is the demo of HF-DAEP_v1 for MRI reconstruction.
### CT reconstruction
'./HFDAEP_v1/DemoCT/demo_CTRec.m' is the demo of HF-DAEP_v1 for CT reconstruction.
'./HFDAEP_v1/DemoCT/ultilies/generateSystemMatrix.m' is used to generate the system matrix.

## HFDAEP_v2
### Table
![repeat-HFDAEPRec](https://github.com/yqx7150/HFDAEP/blob/master/HFDAEP_v2/figs/result.png)

### Visual Comparisons
![repeat-HFDAEPRec](https://github.com/yqx7150/HFDAEP/blob/master/HFDAEP_v2/figs/fig_result.png)
Fig. 4. Visual comparisons under 2D Random sampling at 80%. Top line: reference image, reconstruction using DLMRI, PANO and FDLCP; Bottom line: reconstruction using NLR-CS, DC-CNN, EDAEP and DFRP.

### MRI reconstruction
'./HFDAEP_v2/DemoMRI/demo_MRI_DFPR.m' is the demo of HF-DAEP_v2 for MRI reconstruction.
### CT reconstruction
'./HFDAEP_v2/DemoCT/demo_CTRec.m' is the demo of HF-DAEP_v2 for CT reconstruction.

## Requirements and Dependencies
    matlab
    caffe
    cuda 8.0
    
## [<font size=5>**[Paper]**</font>](https://arxiv.org/ftp/arxiv/papers/1910/1910.11148.pdf)
    @article{he2019learning, 
    title={Learning Priors in High-frequency Domain for Inverse Imaging Reconstruction},
    author={He, Zhuonan and Zhou, Jinjie and Liang, Dong and Wang, Yuhao and Liu, Qiegen},
    journal={arXiv preprint arXiv:1910.11148},
    year={2019}
    }

## Other Related Projects
  * Multi-Channel and Multi-Model-Based Autoencoding Prior for Grayscale Image Restoration  
[<font size=5>**[Paper]**</font>](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8782831)  [<font size=5>**[Code]**</font>](https://github.com/yqx7150/MEDAEP)   [<font size=5>**[Slide]**</font>](https://github.com/yqx7150/EDAEPRec/tree/master/Slide)  [<font size=5>**[数学图像联盟会议交流PPT]**</font>](https://github.com/yqx7150/EDAEPRec/tree/master/Slide)

  * Highly Undersampled Magnetic Resonance Imaging Reconstruction using Autoencoding Priors  
[<font size=5>**[Paper]**</font>](https://cardiacmr.hms.harvard.edu/files/cardiacmr/files/liu2019.pdf)  [<font size=5>**[Code]**</font>](https://github.com/yqx7150/EDAEPRec)   [<font size=5>**[Slide]**</font>](https://github.com/yqx7150/EDAEPRec/tree/master/Slide)  [<font size=5>**[数学图像联盟会议交流PPT]**</font>](https://github.com/yqx7150/EDAEPRec/tree/master/Slide)

  * High-dimensional Embedding Network Derived Prior for Compressive Sensing MRI Reconstruction  
 [<font size=5>**[Paper]**</font>](https://www.sciencedirect.com/science/article/abs/pii/S1361841520300815?via%3Dihub)   [<font size=5>**[Code]**</font>](https://github.com/yqx7150/EDMSPRec)
 
  * Homotopic Gradients of Generative Density Priors for MR Image Reconstruction  
[<font size=5>**[Paper]**</font>](https://ieeexplore.ieee.org/abstract/document/9435335)   [<font size=5>**[Code]**</font>](https://github.com/yqx7150/HGGDP)  [<font size=5>**[数学图像联盟会议交流PPT]**</font>](https://github.com/yqx7150/EDAEPRec/tree/master/Slide)
 
  * Denoising Auto-encoding Priors in Undecimated Wavelet Domain for MR Image Reconstruction  
[<font size=5>**[Paper]**</font>](https://www.sciencedirect.com/science/article/pii/S0925231221000990) [<font size=5>**[Paper]**</font>](https://arxiv.org/ftp/arxiv/papers/1909/1909.01108.pdf)   [<font size=5>**[Code]**</font>](https://github.com/yqx7150/WDAEPRec)

 * One-shot Generative Prior in Hankel-k-space for Parallel Imaging Reconstruction  
[<font size=5>**[Paper]**</font>](https://ieeexplore.ieee.org/document/10158730)   [<font size=5>**[Code]**</font>](https://github.com/yqx7150/HKGM)   [<font size=5>**[PPT]**</font>](https://github.com/yqx7150/HKGM/tree/main/PPT)
   
  * Complex-valued MRI data from SIAT--test31 [<font size=5>**[Data]**</font>](https://github.com/yqx7150/EDAEPRec/tree/master/test_data_31)

  * Complex-valued MRI data from SIAT--SIAT_MRIdata200 [<font size=5>**[Data]**</font>](https://github.com/yqx7150/SIAT_MRIdata200)   
  * Complex-valued MRI data from SIAT--SIAT_MRIdata500-singlecoil [<font size=5>**[Data]**</font>](https://github.com/yqx7150/SIAT500data-singlecoil)  
  * Complex-valued MRI data from SIAT--SIAT_MRIdata500-12coils [<font size=5>**[Data]**</font>](https://github.com/yqx7150/SIAT500data-12coils)   
 
  * Learning Multi-Denoising Autoencoding Priors for Image Super-Resolution  
[<font size=5>**[Paper]**</font>](https://www.sciencedirect.com/science/article/pii/S1047320318302700)   [<font size=5>**[Code]**</font>](https://github.com/yqx7150/MDAEP-SR)

  * REDAEP: Robust and Enhanced Denoising Autoencoding Prior for Sparse-View CT Reconstruction  
[<font size=5>**[Paper]**</font>](https://ieeexplore.ieee.org/document/9076295)   [<font size=5>**[Code]**</font>](https://github.com/yqx7150/REDAEP)  [<font size=5>**[数学图像联盟会议交流PPT]**</font>](https://github.com/yqx7150/EDAEPRec/tree/master/Slide)
