### Intro

This repository provides the Matlab implementation for the CVPR18 paper, "[Learning Facial Action Units From Web Images With Scalable Weakly Supervised Clustering](http://openaccess.thecvf.com/content_cvpr_2018/CameraReady/0237.pdf)". This code has two goals:

1. Learn a **weakly-supervised spectral embedding (WSE)**, which considers the coherence between visual similarity and weak annotations (Sec 3.1 in the paper).

2. Re-annotate noisy images using **rank-order clustering** and majority voting (Sec 3.2 in the paper).  We also provide **uMQI** metric to automatically determine the number of clusters.  This part will be released soon.


### Dependencies
We use the [FLANN](https://www.cs.ubc.ca/research/flann/) library to compute K nearest neighbors to construct the affinity matrix for WSE and rank-order clustering. Before using this code, please download FLANN library and add the path to `addpaths.m`.


### Getting started

To run the toy demo (as Fig. 2 in the paper).  Run the command in Matlab:

``` matlab
>> demo_toy
```

Then you should be able to see the results from the classical clustering problem:
![demo_toy](figures/demo_toy.gif)


### More info

* **Contact**: Please send comments or bugs to Kaili Zhao ([kailizhao@bupt.edu.cn](kailizhao@bupt.edu.cn)).
* **Citation**: If you use this code in your paper, please cite the following:

```
@inproceedings{zhao2018learning,
  title={Learning Facial Action Units From Web Images With Scalable Weakly Supervised Clustering},
  author={Zhao, Kaili and Chu, Wen-Sheng and Martinez, Aleix M.},
  booktitle={IEEE/CVF Conference on Computer Vision and Pattern Recognition},
  year={2018}
}
```