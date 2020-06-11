for fcen in `cat fcen.txt`; do
	h5totxt ${fcen}/no-rod/hz-000008800.00.h5 | tee ${fcen}/no-rod/no-rod-fields.txt
	h5totxt ${fcen}/mag-plasma-rod/hz-000008800.00.h5 | tee ${fcen}/mag-plasma-rod/mag-plasma-rod-fields.txt
done