% -------------------------------------------------------------------------
% Notes from Frank Wefers Partitioned convolution algorithms for real-time auralization
% -------------------------------------------------------------------------
%{
4.1.1. Overlap-Add
Firstly, the FFT-based running convolution using the Overlap-Add scheme is presented. 
The resulting algorithm is visualized in figure 4.1. It works as follows
1 The next length-B input block is zero-padded to length-K and transformed using a K-point FFT .
2 The length-N impulse response is zero-padded to length-K and transformed using a K-point FFT.
3 The input and filter DFT coefficients are pair-wisely multiplied (spectral convolution)
4 The result is transformed back into the time-domain using a K-point IFFT. 
It forms a partial convolution result of length B + N − 1, which is buffered.
5 The length-B output block is added up from the overlapping partial results (Overlap-Add step).
The transform size K must be chosen sufficiently large to avoid time-aliasing (cp. Eq. 2.18)
K≥B+N−1 (4.1)
For the sake of clarity, all partial output signals are stored separately 
in figure 4.1. In actual implementations, all partial outputs are accumulated 
in a single output buffer. It must be large enough to store at least 
B + N − 1 samples. Leaving the filter transformation out of consideration, 
the algorithm has the following computational cost per filtered output sample
Tstream (B,N,K) := 1 􏰡 TFFT(K) + TCMUL(K) + TIFFT(K) + (4.2) OLA-FFT B 􏰢
TADD(B + N − 1)
Note, that the number of extra additions depends on the filter length N. For
long filters they can cause a significant computational overhead.
4.1.2. Overlap-Save
Figure 4.2 illustrates the corresponding Overlap-Save algorithm. The method 
is similar to the OLA approach in the way the filter is transformed and the 
spectral convolution is computed. But it differs in the following aspects:
76
4.1. FFT-based running convolutions
• TheinputFFTiscomputedfromaK-pointslidingwindowoftheinput. Before the 
transformation, the previous contents are shifted B samples to the left and 
the next length-B input block is stored rightmost.
• From the output of the K-point IFFT, the K − B leftmost samples are 
time-aliased and therefore discarded. The B rightmost samples are saved 
into the output block.
The periodicity of the transform allows to implement the OLS method in 
different ways. The algorithm can be modified by circular shifting of the 
buffers (input or filter), altering the positions where data is written 
into the input buffer and filter buffer and read from the output buffer. 
Shift operations on the sliding window can be minimized by using larger 
ring buffers for the input samples. Then actual shifts (copy operations) 
only have to be performed in the event of buffer wraps. By cyclic shifting 
of the filter buffer, the valid output block can be moved to the leftmost 
position. This can be an advantage, when partial inverse transforms shall 
be computed.
The computational complexity per output sample of the OLS algorithm is 
Tstream (B,N,K) := 1 􏰡 TFFT(K) + TCMUL(K) + TIFFT(K) 􏰢 (4.3)
OLS-FFT B
The filter transformation consists of a single K-point FFT for both methods
Tftrans (B,N,K) = Tftrans (B,N,K) := TFFT(K) (4.4) OLA-FFT OLS-FFT
In principle, both methods require the same number of FFTs, IFFTs and 
complex-valued multiplications. A slight advantage of the OLS over the OLA 
approach is, that it avoids the extra additions for the overlapping samples.
%}