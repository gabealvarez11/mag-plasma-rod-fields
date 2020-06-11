module purge
module load openmpi

# Double-check that the directories are cleaned of any results from previous runs. 
rm -f *.txt
rm -f *.png
rm -f *.h5
rm -f *.dat
rm -f *.out

# Generate the .txts which will be read below to control simulation parameters and file organization.
python3 generate-params.py

for sx in `cat sx.txt`; do
	for sy in `cat sy.txt`; do
		for res in `cat res.txt`; do
			for runtime in `cat runtime.txt`; do
				for fcen in `cat fcen.txt`; do
					mkdir ${fcen}
					mkdir ${fcen}/no-rod
					mkdir ${fcen}/mag-plasma-rod

					rm -f ${fcen}/no-rod/*
					rm -f ${fcen}/mag-plasma-rod/*
					#rm -f ${fcen}/subtracted/*

					# Normalization run with empty cell.
					mpirun -np 2 meep fcen=$fcen runtime=$runtime res=$res sx=$sx sy=$sy no-rod?=true mag-plasma-rod.ctl | tee flux0.out
					grep flux1: flux0.out > flux0.dat

					# Convert .h5 files to .png's and move images and files of fields and epsilons to appropriate subfolder. 
					h5topng -Zc RdBu no-rod-out/*.h5
					h5totxt no-rod-out/hz-$(printf "%06d" $runtime).00.h5 | tee no-rod-out/no-rod-fields.txt
					mv no-rod-out/* ${fcen}/no-rod

					# Now, load plasma rod into simulation and organize files as before.
					mpirun -np 2 meep fcen=$fcen runtime=$runtime res=$res sx=$sx sy=$sy no-rod?=false mag-plasma-rod.ctl | tee flux.out
					grep flux1: flux.out > flux.dat

					h5topng -Zc RdBu mag-plasma-rod-out/*.h5
					h5totxt mag-plasma-rod-out/hz-$(printf "%06d" $runtime).00.h5 | tee mag-plasma-rod-out/mag-plasma-rod-fields.txt
					mv mag-plasma-rod-out/* ${fcen}/mag-plasma-rod

					# Move the flux files into the appropriate subfolders and cleanup working directory.
					mv *.dat ${fcen}
					rm -f *.out	
				done
			done
		done
	done
done

rm -rf no-rod-out
rm -rf mag-plasma-rod-out

python3 plot-spectrum.py

# Optional: override which timestep is used for field analysis. Specify which files to use in run-h5to5xt.sh.
#bash run-h5totxt.sh

# If previous line is commented out, this uses the fields output at the final timestep available.
python3 plot-fields.py

# Make a movie out of the subtracted images. First, convert .h5 to .txt, then use Python to do the image processing. 
bash run-movie.sh