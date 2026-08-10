#!/usr/bin/env sage
# --------------------------------------------------------------------------
# Scatter plot of the solar system's ACTUAL planetary orbits vs DT's
# gravitational-Bohr quantisation a_n = a1 n^2 (companion to script 34).
# Measured semi-major axes (AU, standard ephemerides). Writes
# 02_results/planetary_orbits_quantization.png. Figure generator (non-NN).
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage plot_planetary_orbits.sage
# --------------------------------------------------------------------------
from sage.all import *
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# actual measured semi-major axes (AU)
names = ['Mercury','Venus','Earth','Mars','Jupiter','Saturn','Uranus','Neptune']
a_AU  = [0.3871, 0.7233, 1.0000, 1.5237, 5.2026, 9.5549, 19.2184, 30.1104]
ceres_a = 2.7658   # Ceres / asteroid belt (a dwarf planet, the 'gap')

# DT gravitational-Bohr fit: anchor Mercury at n=3 (script 34's best fit)
a1 = a_AU[0] / 3.0**2
nreal = [float(sqrt(a/a1)) for a in a_AU]          # 'quantum number' if a~a1 n^2
nint  = [int(round(x)) for x in nreal]
resid = [nreal[i] - nint[i] for i in range(len(a_AU))]
ceres_n = float(sqrt(ceres_a/a1))                   # ~ 8.0 -> sits in the Mars-Jupiter gap

import numpy as np
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8.4, 7.4),
                               gridspec_kw={'height_ratios':[3,1]})

# --- top: measured a vs assigned n, with the a1 n^2 curve and the gaps -------
ng = np.arange(1, 28)
ax1.plot(ng, a1*ng**2, color='C0', lw=2.0, zorder=1,
         label=r'DT gravitational-Bohr  $a_n = a_1 n^2$  (Mercury$\to n{=}3$)')
occ = set(nint)
gap_n = [n for n in range(nint[0], nint[-1]+1) if n not in occ]
ax1.scatter(gap_n, [a1*n**2 for n in gap_n], facecolors='none', edgecolors='0.6',
            s=42, zorder=2, label='empty levels (gaps)')
ax1.scatter(nint, a_AU, c='black', s=70, zorder=3, label='planets (measured a)')
for i, nm in enumerate(names):
    ax1.annotate(nm, (nint[i], a_AU[i]), textcoords='offset points',
                 xytext=(6, -3), fontsize=8)
ax1.scatter([round(ceres_n)], [ceres_a], marker='*', s=240, c='C3', zorder=4,
            label='Ceres / asteroid belt (lands at n=8, in the gap)')
ax1.annotate('Ceres', (round(ceres_n), ceres_a), textcoords='offset points',
             xytext=(6, -3), fontsize=8, color='C3')
ax1.set_yscale('log')
ax1.set_xlabel('assigned quantum number  n')
ax1.set_ylabel('semi-major axis  a  (AU)')
ax1.set_title('Are planetary orbits quantised?  DT $a_n\\propto n^2$ vs the real solar system\n'
              '(fit RMS 0.18 in n; under-constrained / numerology-prone -- script 34)')
ax1.legend(loc='upper left', fontsize=8.2, framealpha=0.92)
ax1.grid(True, which='both', alpha=0.25)
ax1.set_xlim(0, 28)

# --- bottom: the residual in n (a clean quantisation would be ~0) ------------
ax2.axhline(0, color='0.4', lw=1)
ax2.axhspan(-0.5, 0.5, color='0.9', zorder=0)
ax2.stem(nint, resid, basefmt=' ')
for i, nm in enumerate(names):
    ax2.annotate(nm[:3], (nint[i], resid[i]), textcoords='offset points',
                 xytext=(4, 2 if resid[i] >= 0 else -10), fontsize=7)
ax2.set_xlabel('assigned quantum number  n')
ax2.set_ylabel(r'$\sqrt{a/a_1}-$ nearest int')
ax2.set_title('residual in n (clean quantisation would be ~0; here RMS=0.18, Neptune off by 0.46)',
              fontsize=9)
ax2.set_xlim(0, 28); ax2.set_ylim(-0.6, 0.6)
ax2.grid(True, alpha=0.25)

fig.tight_layout()
import os, sys
out = os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), os.pardir,
                   "sage-results", "planetary_orbits_quantization.png")
fig.savefig(out, dpi=140)
print("wrote", out)
print("n (sqrt(a/a1)): " + ", ".join("%s=%.2f" % (names[i][:3], nreal[i]) for i in range(len(a_AU))))
print("Ceres n = %.2f (sits in the Mars[6]-Jupiter[11] gap, ~n=8)" % ceres_n)
