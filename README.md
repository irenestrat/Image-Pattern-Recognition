# Image-Pattern-Recognition
## Description
 Each image of the given dataset has 3500 x 2400 pixels. We split this image into         5 x 5 = 25 pixels-block. For each one of these blocks we calculate the 7 features as described in the paper [1]. With this procedure each image has 335000 feature vectors and each one of these vectors has 7 features. By implementing Scalar Feature Selection we end up with 5 of 7 features which represent better the three classes: text, background and images. In the following step Gaussian Mixture Model is implemented and we set 50 images from the given dataset as an input. We train the algorithm up to these images. The model has 3 gaussian functions for each one of the classes. Then, we set as an input new 20 images in order to classify each image's features. We now have 5 dimension vectors up to those 3 classes. With this way we achieved correct classification rate 63,6%

 By using the same 50 images for training and the same 20 images for testing, we used K-NN model with 5 and 11 neighbors respectively we achieved correct classification rate up to 69.3% and 70.8%

```Matlab
% x is the 5 dimension feature vectors of 50 images
% y is the classes where these vectors are classified
% xaraktnew is the 5 dimension feature vector of 20 images
Md1=fitcknn(x, y, 'NumNeighbors', 11); 
label=predict(Md1,xaraktnew);
```
## Important Notes

 - First you must download the dataset of the images from 
<a href="http://archive.ics.uci.edu/ml/datasets/Newspaper+and+magazine+images+segmentation+dataset">UCI Machine Learning Repository</a>
- Only .jpeg and their classes as .pmg files must be downloaded
- You will end up with 70 images. All of them must be in the same file with the .m files which contain the code
- This code was implemented bu using Matlab2015b

## How to run the code

1. *featureExtraction.m* this files creates the features, they must be 7x1 dimension
2. *featureDiscrimination.m* this file takes the features that we created above and finds the best of them. You must end up with only 5 features. In this point **Scalar Feature Selection** is being used
3. *featuresExtractionForTest.m* this file creates the 5 dimension vectors for the 20 images
4. *calculateCorrectRate.m* this file calculates the correct classification rate by implementing the **Gaussian Mixture Model** with 3 gaussians for each class. The algorithm **Expectation Maximization** was used to calculate the parameters mean value, variance and the percentage of the partition each ones of the 3 gaussians at the final classifier of each class. Afterwards, algorithm **K-means** used to find an initial mean value for each gaussian of each class.

## Future Work

In a next step Neural Network's implementation will replace the GMM and KNN algorithms.

## References

[1] Algorithm for Segmentation of Documents Based on Texture Features A. M. Vil’kin, I. V. Safonov, and M. A. Egorova National Research Nuclear University MEPhI, Kashirskoe sh. 31, Moscow, 115409 Russia 

[2] Pattern Recognition book, S. Theodoridis and K. Koutroumbas, copyrights © 2009

[3] Image Dataset from UCI
