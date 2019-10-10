---
title: History
layout: default
---

{% marginnote 'mn-id-contents' "*Contents*<br>
[GENEActiv Workflow](#geneactiv)<br>
[Predicting onset of Alzheimer's Disease](#prediction)<br>
[Hodgkin Huxley model](#HHmodel)<br>
[Muscle Twitch Simulation](#twitch)" %}

The first two projects have been part of my work at Rush University while the
latter two come from class work as part of my Master's degree at Illinois
Institute of Technology.

## GENEActiv Workflow<a name="geneactiv"></a>

The GENEActiv workflow has been my largest contribution at Rush.
GENEActivs are a wrist worn device that record a high time resolution
accelerometer signal along with skin temperature and light intensity.
The GENEActivs have been used to be a modern replacement for a previous activity monitor
to provide additional information.
The activity monitors used an accelerometer as well but to save limited storage
space the signal was processed in real-time to a new "counts" signal intended to
summarize the wearer's activity levels over the last 15 seconds.
As such the first task was to imitate the activity monitor's signal to allow
GENEActiv data to contribute to the activity monitor's data set.

After successfully converting the GENEActiv signal to counts, incoming files
needed to be processed and summarized to start the inflow of new data.
Processing includes quality control and converting to counts while summarizing
used the counts signal to recreate the activity monitor's variables and, to make
use of the additional information in the GENEActiv signals, calculated new
variables with the raw accelerometer signal.

<br>
{% fullwidth 'assets/img/geneactivQc.svg'
'Figure 1: Quality Control GUI for finding days when the device was not worn.
Red shaded area marks days auto-detected as missing.' %}<a name ="geneactivQc"></a>
<br>

When GENEActiv files come in they can include periods at the end of the signal
when after the device was removed from the participant, and in some cases
multiple days of non-wear. 
After prepossessing and removing corrupt files, the files are manually check
with a quality control GUI ([Figure 1](#geneactivQc)).
The GUI looks for missing days and periods when the device was temporarily
removed.
A linear decision line using the number of times the acceleration signal crossed
zero and the standard deviation in skin temperature over the day was used to
identify days after the device was removed (the red shaded area above).

With the signals cleaned, they are sent down two paths.
The first goes on to mimic it's predecessor and the second to add new variables.
These new variables include time walking and the in progress sleep detection.

{% maincolumn 'assets/img/timeWalking.svg'
'Figure 2: Detection of time walking.
The accelerometer data are steps detected using a GENEActiv.
The black lines demarcate periods of walking.
(Note: y-axis variation is due to random jitter added to help see steps in
highly clustered areas.)' %}<a name ="timeWalking"></a>

[Figure 2](#timewalking) shows the detection of walking periods. On the top are
steps found with GENEActiv's signal using a method of correlating the signal
with a frequency varying complex wave.
The step tracker signal below contains the true step locations from a device
designed to fire when pressure is applied to a sensor on the bottom of the foot.
Despite the over-prediction of steps by the GENEActiv algorithm during
non-walking periods, when searching for windows with a high concentration of
steps (indicated by the black lines below the accelerometer data) the calculated
time walking matches the true (step tracker) data closely.


## Hodgkin Huxley model<a name="HHmodel"></a>

NOTE: Hodgkin Huxley set resting membrane potential to 0mV.
{% maincolumn 'assets/img/variedinputsub.svg' 
'A suprathreshold current failing to elicit a spike due to the neuron''s refactory
period. E_{Na}, E_K, E_L are the nernst potential''s of sodium, potasium, and the
leak gates respectively.' %}

{% maincolumn 'assets/img/variedinputsupra.svg' 
'A suprathreshold current applied late enough after the previous firing to start
a second spike.' %}

{% maincolumn 'assets/img/constantcurrent.svg'
'A constant current applied to a neuron causing rhythmic firing at a lower
amplitude than whan the neuron is in a fully rested state.' %}

{% maincolumn 'assets/img/first5neurons.gif' 'aoeu' %}
{% maincolumn 'assets/img/all50neurons.gif' 'auk' %}

## Muscle Twitch Simulation<a name="twitch"></a>

{% fullwidth 'assets/img/muscleTwitch.svg' 'aoeu' %}
