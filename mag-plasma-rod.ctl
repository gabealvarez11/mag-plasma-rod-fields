; Some parameters to describe the plasma rod:                                                                                                                   
(define-param rp 1) ; radius of plasma
(define-param w_p_meep (* 0.188 6.28)); plasma angular frequency in meep units (do not forget to use 2pi factor)
(define-param w_b_meep (/ w_p_meep 8.02)); cyclotron angular frequency in meep units (do not forget to use 2pi factor)
(define-param v_c_meep (/ w_p_meep 62.8)); collision frequency in meep units, one tenth the plasma frequency

; The cell dimensions                                                           
(define-param sy 20) ; size of cell in y direction     
(define-param sx 20) ; size of cell in x direction
(define-param dpml 2) ; PML thickness 
(define-param res 10) ; resolution

; Allows for normalization run with no rod present.
(define-param no-rod? false)

; Run simulation in the xy plane.
(set! geometry-lattice (make lattice (size sx sy no-size)))

(if (not no-rod?)
  (set! geometry
    (list
      ; Quartz sheath
      ;(make cylinder (center (+ (/ (- dpml sx) 2) src_to_rod) 0) (radius (+ rp dquartz)) (height infinity)
        ;(material(make dielectric (epsilon 4.5))))
      ; Plasma cylinder
      (make cylinder (center 0 0) (radius rp) (height infinity)
        (material(make dielectric (epsilon 1)(E-susceptibilities
          (make gyroelectric-susceptibility (omega_plas w_p_meep) (nu_cycl w_b_meep) (nu_col v_c_meep) (sigma-offdiag w_p_meep 0 0) (b_dir 0 0 1))))))
    )
  )
)

(set! pml-layers (list (make pml (thickness dpml))))
(set-param! resolution res)

(define-param fcen 0.145) ; pulse center frequency
(define-param df (/ fcen 1000)) ; pulse width (in frequency)

(define-param nfreq 1000) ; number of frequencies at which to compute flux

(set! sources (list
  (make source
    ; Gaussian source
    ;(src (make gaussian-src (frequency fcen)(fwidth df)(is-integrated? true))) ; fwidth != width
    ;  (component Hz) 
    ;  (center (/ (- dpml sx) 2) 0)
    ;  (size 2 sy)
    ; Continuous source
    (src (make continuous-src (frequency fcen)(fwidth (/ fcen 1000))(is-integrated? true))) ; fwidth != width
      (component Hz) 
      (center (/ (- dpml sx) 2) 0)
      (size 2 sy)
    )
  )
)

(define trans ; transmitted flux                                          
  (add-flux fcen (/ fcen 2) nfreq
    (make flux-region
      (center (- (/ sx 2) dpml) 0)
      (size 0 (- sy (* 2 dpml)))
    )
  )
)

(if no-rod?
  (use-output-directory "no-rod-out")
  (use-output-directory "mag-plasma-rod-out")
)

(define-param runtime 200) ; time for simulation to run

;(run-sources+ 
  ;(stop-when-fields-decayed 50 Hz (vector3 (- (/ sx 2) dpml) 0) 1e-3)
(run-until runtime
  (at-beginning output-epsilon)
  (at-every 1 output-hfield-z) ; should increase temporal resolutuon on snapshots for smoother composite animation later if desired
)

(display-fluxes trans) ; print out the flux spectrum