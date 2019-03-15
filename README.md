# Texture Heterogeneity Detection
We present an approach of Spatial Heterogeneity, i.e., Habitats, detection using texture information. First, we compute circular harmonic wavelets for small patches within a Region of Interest (RoI). Second, we cluster patches in order to define the sub-regions of an image with similar texture patterns (habitats). Finally, information about resulting clusters and their texture signatures is presented as habitat descriptors.

<H2>Introduction</H2><br>
This version of code is modification of methods from a project which results are published in the paper: "Revealing Tumor Habitats from Texture Heterogeneity Analysis for Classification of Lung Cancer Malignancy and Aggressiveness". The paper is in open access and can be found here: <br>
https://www.nature.com/articles/s41598-019-38831-0<br>


<H2>Input Arguments</H2><br>
There are three input variables. The first one is a 2D image. The second one is a mask (RoI) for the input image. The third one is Harmonic Vector description.<br><br>
1.  <i>"img"</i>: The Source 2D image. There are no requirements for pixel value range or type.<br><br>
2.  <i>"mask"</i>: An RoI for the source image. It has to have the same resolution as the input image. Non-zero elements represent an RoI where heterogeneity should be evaluated.<br><br>
3.  <i>"hV"</i>: The Harmonic Vector (hV) represents the complexity and number of texture features. All texture computations are done in Fourier space, so you may think about hV as a representative of convolution kernels. The simplest texture description represented by 0. Next is -1 and 1 and so on. Thus, you can set hV to (0), (-1, 0), (-1, 0, 1), ..., (-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5) and so on. <br><br>
Deteiled description of texture computation and Harmonic Vectors can be found in the following paper:<br>
<i>Depeursinge, A., Puspoki, Z., Ward, J.-P. & Unser, M. Steerable Wavelet Machines (SWM): Learning Moving Frames for Texture Classification. IEEE Transactions on Image Process. 26, 1626–1636 (2017)</i><br>


<H2>Output Arguments</H2><br>

Habitat detection algorithm produces two outputs.<br><br>
+ <i>"Habitats"</i>: NxXxY matrix, where N is number of detected habitats, X and Y are resolutions of the input image. Each habitat is marked with non-zero elements in an individual habitat map. Function workflow/show_habitats.m can be used for displaying of combined habitat map.
+ <i>"Features"</i>: Structure variable containing description of habitats and tumor heterogeneity.<br>
  + <i>"Features.num_clusters"</i>: number of detected habitats;<br>
  + <i>"Features.fingerprint"</i>: texture signature values for each habitat. The order of signatures is the same as the order of habitat maps in "Habitats" output.<br>
  + <i>"Features.q_features"</i>: Stracture field which describe statistical information about habitat areas.<br>
      + <i>"Features.q_features.smallest_ration_v"</i>: The smallest ratio of a habitat area to an RoI area.<br>
      + <i>"Features.q_features.largest_region_v"</i>: The largest ratio of a habitat area to an RoI area.<br>
      + <i>"Features.q_features.mean_region_v"</i>: The mean ratio of a habitat area to an RoI area.<br>
      + <i>"Features.q_features.median_region_v"</i>: The median ratio of a habitat area to an RoI area.<br>
      + <i>"Features.q_features.disjoint_smallest_ration_v"</i>: The smallest ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
      + <i>"Features.q_features.disjoint_largest_region_v"</i>: The largest ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
      + <i>"Features.q_features.disjoint_mean_region_v"</i>: The mean ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
      + <i>"Features.q_features.disjoint_median_region_v"</i>: The median ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
  + <i>"Features.centroids_mean_dist"</i>: Mean euclidean distance from each habitat texture signature to a RoI texture signature. The RoI texture signature is defined as mean value of all texture signatures.<br>
  + <i>	"Features.centroids_std_dist"</i>: Standart deviation of euclidean distances from each habitat texture signature to a RoI texture signature. The RoI texture signature is defined as mean value of all texture signatures.<br><br>


<b>*Habitats</b> are detected without the respect to their location within an RoI. As a result, an individual habitat can be presented as a set of disjoint sub-regions within an RoI. In the case where area statistics is computed on disjoint habitats each disjoint region of a habitat is considered as an independent habitat.<br><br>

For a detailed description of the statistical features see the paper.<br>




<H2>Patient Cohort Processing</H2><br>

There is only one requirement for the preprocessing.<br><br>
+ <i>Uniform spatial resolution</i>. Medical image spatial resolution depends on the patient. For consistency of habitat detection across patients, it is important to make spatial resolution uniform.<br><br>

<H2>Original version</H2>

This version of the heterogeneity detection method was created to simplify preprocessing requirements and increase the stability of the method. You may find the original version by the link below.<br>
https://github.com/VisionAI-USF/TextureHeterogeneityDetection<br>

<H2>Example Code</H2>

After you download the code, include all the folders (features, U, utils, Wavelet, FuzzyClusteringToolbox_m, and workflow) and their subfolders into Matlab PATH variable.<br>
To do that in terminal you need to change working directory (<i>cd</i> command) to the one where the downloaded code is located. Then you can use the code below.

```
cur_folder = pwd();
addpath([cur_folder,filesep,'features']);
addpath([cur_folder,filesep,'U']);
addpath([cur_folder,filesep,'utils']);
addpath([cur_folder,filesep,'Wavelet']);
addpath([cur_folder,filesep,'Wavelet',filesep,'Radial']);
addpath([cur_folder,filesep,'workflow']);
```


All the computations are done by function <i>compute_features</i>. Below is an example of its usage.

```
clc;
clear;
close all;
load('test_data.mat');

hV = [-1,0,1];
[habitats, features] = compute_features( img, mask, hV );

```

After execution the code above you should get following resuls:

```
habitats = 15x512x512 double

features = 
           num_clusters: 15
            fingerprint: [15×9 double]
             q_features: [1×1 struct]
    centroids_mean_dist: 66.0818
     centroids_std_dist: 34.6537
```

If you are running Matlab at graphical operating system, then you can plot input data and resulting habitat map using following code.
```
show_habitats(habitats);title('Habitat map');
figure; imagesc(img); colormap gray;title('CT data');
figure; imagesc(mask); colormap gray;title('Original segmentation');
```

<H2>Assumptions and Peproducibility</H2>

We use c-mean algorithm for detection of clusters with similar texture signatures. For reproducibility we used default Random Number Generator.
```
rng('default')
```
Line 21 at <i>workflow/cluster_texture.m</i><br>

<H2>References</b></H2>
If you are going to use it, please, use the reference:<br>
TBA

<H2>Questions</b></H2>

If you have any questions, please contact corresponding author of the paper.
