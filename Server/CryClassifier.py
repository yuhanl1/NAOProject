#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
CryClassifier.py
This is the class to train the model for cries

@author: Yuhan Liu 802997 University of Melbourne
@version: 1.04
@Date: March - April, 2018
"""
from sklearn import svm
from sklearn.naive_bayes import GaussianNB
import numpy as np
import librosa
import math


class CryClassifier:

    def extractFeature(self,filename,dimension=20):
        y, sr = librosa.load(filename, sr=8000, duration=5)
        #print len(y)
        # if y.shape[0] < 40000:
        #     pad = np.zeros(40000 - y.shape[0])
        #     y = np.concatenate((y, pad))
        MFCCFeature = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=dimension).T
        return MFCCFeature

    def calculateScore(self,list):
        transposition = list.T
        product = 1.0
        count = 0.0
        for i in transposition[1]:
            product = product * i
            count = count + 1.0
        j = 1.0 / count
        return math.pow(product, j)

    def getResult(self,list):
        if np.sum(list == 1) > np.sum(list == 0):
            return 1
        else:
            return 0

    def __init__(self):
        # Prepare X
        cry = np.load("model/cryFeatureMatrix-train560-60405-20.npy")
        cryLength = cry.shape[0]
        nonSpeech = np.load("model/nonSpeechFeatureMatrix-4585-20.npy")
        nonSpeechLength = nonSpeech.shape[0]
        room = np.load("model/roomSpeechFeatureMatrix-3193-20.npy")
        roomLength = room.shape[0]
    
        X = np.concatenate((cry, nonSpeech, room))
    
        # Build y
        oneLength = cryLength
        zeroLength = nonSpeechLength + roomLength
        y = np.concatenate((np.ones(oneLength), np.zeros(zeroLength)))
    
        self.GNB_clf = GaussianNB()
        # GNB_clf = svm.LinearSVC(random_state=0)
        self.GNB_clf.fit(X, y)

'''
    def __init__(self,matrix_cry = None,matrix_nonSpeech = None ,matrix_room = None):
        # Prepare X
        cry = matrix_cry
        # if matrix_cry != None:
        #     cry = matrix_cry
        # else:
        #     cry = np.load("cryFeatureMatrix-train560-60405-20.npy")
        cryLength = cry.shape[0]
        nonSpeech = matrix_nonSpeech
        # if matrix_nonSpeech != None:
        #     nonSpeech = matrix_nonSpeech
        # else:
        #     nonSpeech = np.load("nonSpeechFeatureMatrix-4585-20.npy")
        nonSpeechLength = nonSpeech.shape[0]
        room = matrix_room
        # if matrix_room != None:
        #     room =matrix_room
        # else:
        #     room = np.load("roomSpeechFeatureMatrix-3193-20.npy")
        roomLength = room.shape[0]

        X = np.concatenate((cry, nonSpeech, room))

        # Build y
        oneLength = cryLength
        zeroLength = nonSpeechLength + roomLength
        y = np.concatenate((np.ones(oneLength), np.zeros(zeroLength)))

        self.GNB_clf = GaussianNB()
        # GNB_clf = svm.LinearSVC(random_state=0)
        self.GNB_clf.fit(X, y)
'''
    def detectCry(self,filename, threshold, dimension = 20):
        # fileSet = set(librosa.util.find_files('TestFile', recurse=False))
        # fileList = list(fileSet)
        pre_X = self.extractFeature(filename,dimension=dimension)
        probList = self.GNB_clf.predict_proba(pre_X)
        # probList = GNB_clf.predict(pre_X)
        prob = self.calculateScore(probList)
        # prob = getResult(probList)
        #print "Cry" if prob > threshold else "Non-Cry"
        return "Cry" if prob > threshold else "Non-Cry"

    def extractFeatureByRawData(self, rawData, sampleRate):
        MFCCFeature = librosa.feature.mfcc(y=rawData, sr=sampleRate, n_mfcc=20).T
        #print MFCCFeature
        return MFCCFeature

    def detectCryByRawData(self,rawData,sampleRate):
        pre_X = self.extractFeatureByRawData(rawData,sampleRate)
        probList = self.GNB_clf.predict_proba(pre_X)
        # probList = GNB_clf.predict(pre_X)
        prob = self.calculateScore(probList)
        # prob = getResult(probList)
        threshold = 0.80
        #print "Cry" if prob > threshold else "Non-Cry"
        return "Cry" if prob > threshold else "Non-Cry"