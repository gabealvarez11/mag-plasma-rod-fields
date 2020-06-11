---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
mag-plasma-rod-fields

Software suite developed by Gabe Alvarez, Spring 2020-21. Any questions should be directed to alvarez7@stanford.edu.

Allows user to specify plasma parameters, choose incident EM frequencies, and toggle simulation control parameters.
 
For each incident EM frequency fcen, produces transmission curves, uses image subtraction to show scattered fields, and creates movies of fields evolving in time.

Can be extended to analyze 2D slices of 3D cell, albeit at a significant computational cost.

Any cell geometry can be specified in the MEEP .ctl file (plasmonic crystals, a square rod, several cylindrical rods of different radii, etc.).

The program is run by calling % bash run-mag-plasma-rod.sh in the console.

Requires offidiagonal-meep to be installed locally. 

See install-modified-meep.sh for instructions on setting up the correct dependencies for https://github.com/alexfriman/offidiagonal-meep.

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
run-mag-plasma-rod.sh

Main function, controls execution of other files. 

Open this file to comment out make-movie section if not needed.

---------------------------------------------------------------------------------------------------
generate-params.py

Generates .txt files with parameter values that will override define-param values in the .ctl and be read later into other Python files for processing.

runtime, res, fcen (can be array or single value), sx, and sy should be entered into generate-params.py. All other parameters should be specified in mag-plasma-rod.ctl.

---------------------------------------------------------------------------------------------------
mag-plasma-rod.ctl

MEEP file. For each probing frequency fcen, runs once with an empty geometry (normalization run), and once with the fully specified geometry.

---------------------------------------------------------------------------------------------------
run-h5totxt.sh

Specifies which timesteps to use in plot-fields. The main function defaults to the last available time step if run-h5totxt.sh is not run.

---------------------------------------------------------------------------------------------------
plot-fields.py

Creates a len(fcen) x 3 array of subplots, where for each probing frequency fcen, the incident fields (no rod present), the total fields (rod present), and the scattered fields (total minus incident) are plotted.

---------------------------------------------------------------------------------------------------
plot-spectrum.py

Inspects the incident and transmitted flux spectra to identify dips in transmission at resonant frequencies. 

---------------------------------------------------------------------------------------------------
run-movie.sh

Converts .h5 files to .txt's and calls make-movie.py to perform the same image subtraction as in plot-fields.py. Saves the subtracted images only to ${fcen}/subtracted and then converts them into an animated gif.

---------------------------------------------------------------------------------------------------
make-movie.py

For all timesteps, performs the same image subtraction as in plot-fields.py, saves the subtracted images only to ${fcen}/subtracted. 