Predicting Human Gaze Beyond Pixels
===================================
Matlab tools for "Predicting human gaze beyond pixels," Journal of Vision, 2014
Juan Xu, Ming Jiang, Shuo Wang, Mohan Kankanhalli, Qi Zhao
 
Copyright (c) 2014 NUS VIP - Visual Information Processing Lab

Distributed under the MIT License
See LICENSE file in the distribution folder.

Contents
================

This code package includes the following files:

- demo.m:                             demonstrates the usage of this package. 
- src/common/config.m                 defines the configuration parameters.
- src/common/normalise.m              normalises a saliency map.
- src/dataset/computeFixationMaps.m   generates the human fixation maps.
- src/dataset/showEyeData.m           visualises the scanpaths of a given subject.
- src/metric/computeInterSubjectAUC.m computes the ideal (inter-subject) AUC scores.
- src/metric/normalizedAUC.m          computes the normalized AUC scores.
- src/model/computeIttiMaps.m         computes the pixel-level feature maps (Itti & Koch model).
- src/model/extractObjectFeatures.m   computes the object level feature values.
- src/model/computeObjectMaps.m       computes the object-level feature maps.
- src/model/computeSemanticMaps.m     computes the semantic-level feature maps.
- src/model/splitData.m	              splits the data into training and testing sets.
- src/model/trainModel.m              trains the saliency model.
- src/model/computeSaliencyMaps.m     computes the predicted saliency maps.

This data package includes the following files:

- data/stimuli/*.jpg                  stimuli files
- data/eye/fixations.mat              eye-tracking data (fixation points and durations)
- data/attrs.mat                      manually labelled object masks and attributes

Getting Started
================

Open Matlab and run demo.m to compute the fixation maps, the feature maps, to learn and evaluate the saliency model.

Contacts
================

Send feedback, suggestions and questions to
Juan Xu at <jxu@nus.edu.sg>
Ming Jiang at <mjiang@nus.edu.sg>
