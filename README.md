# Gastrointestinal transit time in patients with acquired brain injury

This repository is an anonymized version of the dataanalysis used for the article manuscript 'gastrointestinal transit time in patients with acquired brain injury'. To ensure patient anonymity, dates are ommitted from the data set, and only derived time intervals are inclued.

Results are presented in the R markdown file 'result_review.Rmd', and figures are generated in 'gen_plots_article.R'. Both sources 'main.R'.

## Variables (codebook)
### Patient data
  - anon_id: Unique patient ID
  - inj_cat: Injury category. Anoxic brain injury, Hemoragic stroke, Ischemic Stroke, Subarachnoid hemorage (SAH), or Traumatic brain injury (TBI)
  - inj_gcs: GCS at initial admission after injury.
  - fois: Latest score on Functional Oral Intake Scale (FOIS)
  - fim: Functional independence measure in closest temporal proximity to the measurement of gastrointestinal transit time (GITT). Calculated from 3 subscores:
    - fim_motor 
    - fim_bowel 
    - fim_cog 
  - bristol: latest bristol score
  - use_laxative: Does the patient use a laxative at the time of GITT measurement
  - use_baclofen: Does the patient use a baclofen at the time of GITT measurement 
  - use_opioid: Does the patient use an opioid at the time of GITT measurement
  - use_statin: Does the patient use a statin at the time of GITT measurement 
  - use_ssri:  Does the patient use an SSRI at the time of GITT measurement 
  - mark_R: Number of radioopaque markers in the right colon
  - mark_L: Number of radioopaque markers in the left colon
  - mark_RS: Number of radioopaque markers in the rectosigmoid colon
  - age: Age in years
  - sex: Biological sex 
  - days_since_inj: Days from injury to GITT measurement
  - days_rtg_to_fim: Days from GITT measurement (X-ray/Röntgen) to FIM score (negative is FIM before GITT measurement)
  - rtg_to_q: Days from GITT measurement to Neurogenic Bowel Dysfunction questionaire
  - days_inj_to_q: Days from injury to Neurogenic Bowel Dysfunction questionaire
  - q_sum: Sum score of Neurogenic Bowel Dysfunction questionaire (0-47)
  - q_infl: Score of how much the patients quality of life is influenced by their bowel function (1: No influence, 2: Litle influence, 3: Some influence, 4: High influence).

### Control data
  - sex: Biological sex 
  - age: Age in years
  - gitt: Gastrointestinal transit time (GITT) in days
  - use_laxative: Does the patient use a laxative at the time of GITT measurement

### HRV data
  - anon_id: Unique patient ID
HRV measures:
Variables without '\_#' (underscore number) endings are 24 hour measurements. Variables with '\_#' endings are 5 min samples at 6 am, 1 pm, 6 pm, and 2 am respectively. All time variables are in seconds (S), S^2 or S^-1. Variables are calculated and exported in Kubios HRV.
  - mean.RR: Mean RR interval.
  - std.RR: Standard deviation (SD) of RR intervals.
  - mean.HRV: Mean heart rate. (Erroneous variable name in kubios export file)
  - std.HRV: SD of heart rate.
  - RMSSD: Root of mean squared differences of successive NN intervals.
  - NN50: Number NN intervals with a difference greater than 50 ms.
  - pNN50: Proportion of NN50 to total intervals.
  - HRV.tri.ind: HRV triangular index.
  - TINN: Triangular interpolation of NN interval histogram.
  - SDANN: Standard deviation of 5 min averages of NN intervals.
  - SDNN.index: Mean of the SDs of NN intervals in 5 min segments. 
  - LF.power: Low frequency (0.04-0.15 Hz) power of spectral analysis.
  - HF.power: High frequency (0.15-0.4 Hz) power of spectral analysis.
  - VLF.power: Very low frequency (0-0.04 Hz) power of spectral analysis. 
  - LF.HF.power: LF/HF ratio. 
  - tot.power: Total power of spectral analysis.

For more information on HRV variables see [AHA and ESC (1996) ‘Heart rate variability. Standards of measurement, physiological interpretation, and clinical use. Task Force of the European Society of Cardiology and the North American Society of Pacing and Electrophysiology.’, Eur. Heart J., 17(3), pp. 354–81.](http://circ.ahajournals.org/content/93/5/1043)

## ECG files
ECG files (24 hours, 250 Hz) used for HRV analysis are provided. These files have been deidentified (all dates are changed to 2001-01-01 and subject IDs are changed to the anon_id used througout the analysis).

## License
FOR DATA FILES:
Please contact the author about permisson to use this data in research projects.

FOR ANALYSIS FILES:
MIT License.
