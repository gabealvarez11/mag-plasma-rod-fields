# Run after run-mag-plasma-rod if make-movie command was commented out.
# Makes a movie out of the subtracted images. 
# First, convert .h5 to .txt, then use Python to do the image processing. 
# Finally, use ImageMagick to convert png's to gif.
for fcen in `cat fcen.txt`; do
	mkdir ${fcen}/subtracted
	for runtime in `cat runtime.txt`; do
		for i in $(seq 1 $runtime); do 
			h5totxt ${fcen}/no-rod/hz-$(printf "%06d" $i).00.h5 | tee ${fcen}/no-rod/hz-$(printf "%06d" $i).00.txt
			h5totxt ${fcen}/mag-plasma-rod/hz-$(printf "%06d" $i).00.h5 | tee ${fcen}/mag-plasma-rod/hz-$(printf "%06d" $i).00.txt
		done
	done
done

python3 make-movie.py

for fcen in `cat fcen.txt`; do
	convert ${fcen}/subtracted/*.png ${fcen}/movie.gif
done