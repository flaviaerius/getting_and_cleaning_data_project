# Codebook for the output of the script run_analysis

This codebook will describe the variables contained in the file **average_data_labeled_task5.tsv**, which is the last file written out in the script here contained, **run_analysis.R**, described in **README.md** as the output file from the last task for the assignment of Getting and Cleaning Data course on Coursera. 

- **subject**: contains the numbers 1 to 30, which identifies the volunteer subjects which performed the activities. The volunteers have the age range from 19 to 48 years.

- **labels**: contains the 6 labels of activities performed by the subjects, which are: STANDING, SITTING, LAYING, WALKING, WALKING_DOWNSTAIRS, and WALKING_UPSTAIRS.

- **timeBodyAccelerometer-mean()-X** trough **angle(Z_gravityMean)** (561 columns): each one of the columns contain the average of measurement for each activity to each subject of one sensor from a smartphone. All the measurements range from -1 to 1.
About some characteristics of these features:
  - _time_: features containing this label denote time domain signals, captured at a constant rate of 50 Hz, and filtered. 
  - _frequency_: features containing this label denote frequency domain signals after passing by a Fast Fourier Transform (FFT).
  - _Accelerometer_: features containing this label were obtained through the accelerometer and their units are standard gravity 'g'.
  - _Gyroscope_: features containing this label were obtained by the Gyroscope and their units are radians per second.
  - _-XYX_: features containing this label denote 3-axial signals in the X, Y and Z directions.
  - _Magnitude_: features containing this label have their magnitude, calculated using the Euclidean norm.
  - _Jerk_: features containing this label have the body linear acceleration and angular velocity derived in time. 

