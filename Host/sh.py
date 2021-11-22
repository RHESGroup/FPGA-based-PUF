#!/usr/bin/env python
# coding: utf-8

"""
   File Name: sh.py
      Author: Wan Ji
      E-mail: wanji@live.com
  Created on: Sun Jul 26 21:16:30 2015 CST
"""
DESCRIPTION = """
"""

import os
import argparse
import logging
import ctypes
from types import SimpleNamespace

from scipy.io import loadmat
import numpy as np

#bitsop = ctypes.cdll.LoadLibrary('bitsop.so')

BIT_CNT_MAP = np.array([bin(i).count("1") for i in range(256)], np.uint16)



def eigs(X, npca):
    l, pc = np.linalg.eig(X)
    idx = l.argsort()[::-1][:npca]
    return pc[:, idx], l[idx]


def trainSH(X, nbits):
    """
    Input
      X = features matrix [Nsamples, Nfeatures]
      param.nbits = number of bits (nbits do not need to be a multiple of 8)
    """

    [Nsamples, Ndim] = X.shape
    obj = SimpleNamespace(propertyName='propertyValue')
    SHparam = SimpleNamespace()
    SHparam.nbits = nbits

    # algo:
    # 1) PCA
    npca = min(nbits, Ndim)
    pc, l = eigs(np.cov(X.T), npca)
    # pc[:, 3] *= -1
    X = X.dot(pc)   # no need to remove the mean

    # 2) fit uniform distribution
    eps = np.finfo(float).eps
    mn = np.percentile(X, 5)
    mx = np.percentile(X, 95)
    mn = X.min(0) - eps
    mx = X.max(0) + eps

    # 3) enumerate eigenfunctions
    R = mx - mn
    maxMode = np.ceil(np.real((nbits+1) * R / R.max())).astype(int)
    nModes = maxMode.sum() - maxMode.size + 1
    modes = np.ones((nModes, npca))
    m = 0
    for i in range(npca):
        modes[m+1:m+maxMode[i], i] = np.arange(1, maxMode[i]) + 1
        m = m + maxMode[i] - 1
    modes = modes - 1
    omega0 = np.pi / R
    omegas = modes * omega0.reshape(1, -1).repeat(nModes, 0)
    eigVal = -(omegas ** 2).sum(1)
    ii = (-eigVal).argsort()
    modes = modes[ii[1:nbits+1], :]

    SHparam.pc = pc
    SHparam.mn = mn
    SHparam.mx = mx
    SHparam.modes = modes
    return SHparam


def loadParam(path):
    return loadmat(path, struct_as_record=False, squeeze_me=True)['params']


def compactbit(b):
    nSamples, nbits = b.shape
    nwords = (nbits + 7) // 8
    B = np.hstack([np.packbits(b[:, i*8:(i+1)*8][:, ::-1], 1)
                   for i in range(nwords)])
    residue = nbits % 8
    if residue != 0:
        B[:, -1] = np.right_shift(B[:, -1], 8 - residue)
        print (8 - residue)

    return B


def compressSH(X, SHparam):
    """
    [B, U] = compressSH(X, SHparam)

    Input
    X = features matrix [Nsamples, Nfeatures]
    SHparam =  parameters (output of trainSH)

    Output
    B = bits (compacted in 8 bits words)
    U = value of eigenfunctions (bits in B correspond to U>0)
    """

    if X.ndim == 1:
        X = X.reshape((1, -1))

    Nsamples, Ndim = X.shape
    nbits = SHparam.nbits

    X = X.dot(SHparam.pc)
    X = X - SHparam.mn.reshape((1, -1))
    omega0 = np.pi / (SHparam.mx - SHparam.mn)
    omegas = SHparam.modes * omega0.reshape((1, -1))

    U = np.zeros((Nsamples, nbits))
    for i in range(nbits):
        omegai = omegas[i, :]
        ys = np.sin(X * omegai + np.pi/2)
        yi = np.prod(ys, 1)
        U[:, i] = yi

    b = np.require(U > 0, dtype=np.int)
    return b, U


def compressSH2(X, SHparam):
    """
    [B, U] = compressSH2(X, SHparam)

    Input
    X = features matrix [Nsamples, Nfeatures]
    SHparam =  parameters (output of trainSH)

    Output
    B = bits (compacted in 8 bits words)
    U = value of eigenfunctions (bits in B correspond to U>0)
    """

    if X.ndim == 1:
        X = X.reshape((1, -1))

    Nsamples, Ndim = X.shape
    nbits = SHparam.nbits

    X = X.dot(SHparam.pc)
    X = X - SHparam.mn.reshape((1, -1))
    omega0 = 0.5 / (SHparam.mx - SHparam.mn)
    omegas = SHparam.modes * omega0.reshape((1, -1))

    U = np.zeros((Nsamples, nbits))
    for i in range(nbits):
        omegai = omegas[i, :]
        ys = X * omegai + 0.25
        ys -= np.floor(ys)
        yi = np.sum(ys < 0.5, 1)
        U[:, i] = yi

    b = np.require(U % 2 == 0, dtype=np.int)
    B = compactbit(b)
    return B, U