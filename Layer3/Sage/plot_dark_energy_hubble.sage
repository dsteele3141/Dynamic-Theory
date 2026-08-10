#!/usr/bin/env sage
# --------------------------------------------------------------------------
# Scatter plot: Pantheon SN-Ia Hubble residual (relative to a no-dark-energy
# Einstein-de Sitter universe) with DT and LambdaCDM model curves overlaid.
# Companion figure to scripts 27/29. DATA: Pantheon binned (Scolnic+ 2018).
# Writes 02_results/dark_energy_hubble.png. (Not an NN_-prefixed verification
# script; a figure generator.)
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage plot_dark_energy_hubble.sage
# --------------------------------------------------------------------------
from sage.all import *
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

LN10 = float(log(10))
DATA = [
 (0.0140,14.57001926,0.0311),(0.0194,15.2279603507,0.02645),(0.0264,15.934102317,0.0231),
 (0.0329,16.4217829558,0.0235),(0.0396,16.836418956,0.02845),(0.0475,17.2346439906,0.0334),
 (0.0560,17.5758459622,0.03215),(0.0640,17.9104543501,0.0439),(0.0721,18.1780074589,0.03865),
 (0.0811,18.5543855764,0.04225),(0.0889,18.7006554037,0.03635),(0.1001,19.0388242428,0.03515),
 (0.1071,19.1720185353,0.03355),(0.1195,19.3711295152,0.0260),(0.1278,19.5555026238,0.02635),
 (0.1396,19.8185930766,0.02335),(0.1519,19.9445025196,0.0237),(0.1635,20.0642537602,0.02585),
 (0.1778,20.3389008923,0.01965),(0.1906,20.5047456137,0.02205),(0.2067,20.6854007995,0.0214),
 (0.2216,20.8610322507,0.0233),(0.2405,21.0518440051,0.0222),(0.2558,21.2037930719,0.02025),
 (0.2762,21.3636137766,0.0221),(0.2972,21.5790014334,0.0216),(0.3215,21.813277279,0.0214),
 (0.3453,21.9665751024,0.0234),(0.3708,22.1428940056,0.02145),(0.4049,22.3799192408,0.03225),
 (0.4355,22.5579272526,0.0254),(0.4738,22.797376642,0.02935),(0.5174,23.0011594448,0.02685),
 (0.5742,23.3004345026,0.0245),(0.6299,23.5036280324,0.031),(0.7240,23.8666293039,0.027),
 (0.8210,24.2445519795,0.0248),(0.9511,24.6411323707,0.0276),(1.2336,25.3039940191,0.05635),
 (1.6123,25.9259729107,0.0735),
]
zd = [d[0] for d in DATA]; mb = [d[1] for d in DATA]; dmb = [d[2] for d in DATA]
w = [1.0/s**2 for s in dmb]; N = len(DATA)

def shape_FRW(Om, z):
    I = numerical_integral(lambda zp: 1.0/sqrt(Om*(1+zp)**3 + (1-Om)), 0, z)[0]
    return 5.0*log((1+z)*I)/LN10
def shape_DT(z, xi=0.235):
    return 5.0*log((1+z)*log(1+z))/LN10 + (15.0/4.0)*xi*log(1+z)/LN10

# best-fit additive offset for each model (inverse-variance weighted), on the data
def offset(shape_at):
    r = [mb[i]-shape_at[i] for i in range(N)]
    return sum(w[i]*r[i] for i in range(N))/sum(w)

sE = [shape_FRW(1.0, z) for z in zd]; offE = offset(sE)
sL = [shape_FRW(0.3, z) for z in zd]; offL = offset(sL)
sD = [shape_DT(z)       for z in zd]; offD = offset(sD)

# data residual relative to the best-fit EdS (no-dark-energy) model
res_data = [mb[i] - (sE[i]+offE) for i in range(N)]

# smooth model curves (relative to EdS) on a z-grid
grid = [0.01 + (1.70-0.01)*k/400.0 for k in range(401)]
def curve(shape_fn, off):
    return [ (shape_fn(z)+off) - (shape_FRW(1.0,z)+offE) for z in grid ]
cL = curve(lambda z: shape_FRW(0.3,z), offL)
cD = curve(lambda z: shape_DT(z),      offD)

fig, ax = plt.subplots(figsize=(8.2, 5.6))
ax.axhline(0.0, color='0.4', lw=1.6, ls='--', label='Einstein-de Sitter (no dark energy)')
ax.plot(grid, cL, color='C0', lw=2.2, label=r'$\Lambda$CDM ($\Omega_m{=}0.3$)')
ax.plot(grid, cD, color='C3', lw=2.2, ls='-.', label=r'DT (log-$z$ + evolving candle, $\xi{=}0.235$)')
ax.errorbar(zd, res_data, yerr=dmb, fmt='o', ms=5, color='black',
            ecolor='0.5', capsize=2, label='Pantheon binned SN Ia (Scolnic+ 2018)')
ax.set_xscale('log')
ax.set_xlabel('redshift  z')
ax.set_ylabel(r'$\Delta\mu$  (mag, relative to Einstein-de Sitter)')
ax.set_title('Pantheon SN Ia Hubble residual: the dark-energy signal\n'
             'DT absorbs it (~98%); EdS does not  —  scripts 27/29')
ax.legend(loc='upper left', fontsize=9, framealpha=0.9)
ax.grid(True, which='both', alpha=0.25)
ax.set_xlim(0.012, 1.8); ax.set_ylim(-0.15, 0.75)
fig.tight_layout()
import os, sys
out = os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), os.pardir,
                   "sage-results", "dark_energy_hubble.png")
fig.savefig(out, dpi=140)
print("wrote", out)
print("data points: %d ; high-z data lie ABOVE EdS(0) and track LambdaCDM/DT." % N)
