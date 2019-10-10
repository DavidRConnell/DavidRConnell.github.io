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

*Working with GENEActiv*
GENEActiv reader
Imitating actical
QC (auto detection)
Additional metrics

{% fullwidth 'assets/img/geneactivQc.svg'
'Quality Control GUI for finding days when the device was not worn.
Red shaded area marks days autodetected as missing.' %}

{% maincolumn 'assets/img/timeWalking.svg'
'Detection of time walking.
The accelerometer data are steps detected by a wrist-worn accelerometer.
The black lines demarcate periods of walking.
(Note: y-axis variation is due to random jitter added for clarity.)' %}

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
