PhD_PIHM
<br />
<p style="text-align: center;"><span style="text-decoration: underline;"><strong>PIHM 1-6 month lead forecast scripts:</strong></span></p>
<ol>
<li><strong>data/1st_downscaling/1st_script.sh</strong>
<ul>
<li>this script downloads the (2.8&deg; X 2.8&deg;) ECHAM4p5 precipitation monthly forecast grids for the specified limits and the Maurer (1&frasl;8&deg; X 1&frasl;8&deg;) precipitation monthly (and daily to be used in the next step) historical observations</li>
<li>then uses principal component regression (PCR) executed by the climate predictability tools (CPT) from the IRI data library. It downscales the ECHAM4p5 grids to (1&frasl;8&deg; X 1&frasl;8&deg;)</li>
<li>n.b.: the script downloads all lead times (1-7) but can be limited from (1-4)-month lead time which is more common.</li>
</ul>
</li>
<li><strong>data/2_disaggregation/2nd_script.sh</strong>
<ul>
<li>this script takes the downscaled monthly forecast and disaggregates it to daily time series using the Matlab code (medisagg.m), which is modified from the original Matlab code at (study.m)</li>
<li>the script uses Octave (open source alternative for Matlab) and the necessary octave commands to run on all grids and all leads.</li>
</ul>
</li>
<li><strong>data/3_forcing/3rd_script.sh</strong>
<ul>
<li>this script generates the forcing file for each PIHM setup from the precipitation daily forecasts from steps 1 &amp; 2, so for (1981-01 to 1981-06) setup, it collects the Jan from 1-month, Feb from 2-month, ... Jun from 6-month, ...</li>
</ul>
</li>
<li><strong>data/4_runs/4th_script.sh</strong>
<ul>
<li>&nbsp;</li>
</ul>
</li>
<li><strong>data/5_results/5th_script.sh</strong>
<ul>
<li>&nbsp;</li>
</ul>
</li>
</ol>