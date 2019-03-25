#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
FrameFeatureExtract.py
This is the class to process the audio file
Generate the feature matrix

@author: Yuhan Liu 802997 University of Melbourne
@version: 1.02
@Date: March, 2018
"""
import numpy as np
import librosa

fileSet = set(librosa.util.find_files('Room-wav',recurse=False))
fileList = list(fileSet)
feature_list = list()
y, sr = librosa.load(fileList[0], sr=8000)
MFCCFeature = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=20).T

for i in range(1,len(fileList)):
    y_tmp, sr_tmp = librosa.load(fileList[i], sr=8000)
    MFCCFeature_tmp = librosa.feature.mfcc(y=y_tmp, sr=sr_tmp, n_mfcc=20).T
    MFCCFeature = np.concatenate((MFCCFeature_tmp,MFCCFeature))

print MFCCFeature.shape
np.save("roomSpeechFeatureMatrix-3193-20.npy",MFCCFeature)