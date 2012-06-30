(context 'GeoTools)

(constant 'PI 3.141592653589793)

;; degrees to radians
(define (degrees-to-radians x)
	;(mul 0.01745 x)
	(mul x (div PI 180))
)

;; degrees to radians
(define (grads-to-radians x)
	(mul 0.01571 x)
)

(define (get-distance unit lat1 lng1 lat2 lng2)

	(if (= unit "km")
		(set 'r 6371)
	)
	(if (= unit "miles")
		(set 'r 3959)	
	)
	
	(set 'deltaLat (sub lat2 lat1))
	(set 'deltaLng (sub lng2 lng1))
	(set '_alpha (div deltaLat 2))
	(set '_beta (div deltaLng 2))

	(set '_1 (sin (degrees-to-radians _alpha)))
	(set '_2 (sin (degrees-to-radians _alpha)))
	(set '_3 (cos (degrees-to-radians lat1)))
	(set '_4 (cos (degrees-to-radians lat2)))
	(set '_5 (sin (degrees-to-radians _beta)))
	(set '_6 (sin (degrees-to-radians _beta)))
	(set 'a (add (mul _1 _2) (mul _3 _4 _5 _6)))
	(set 'c (asin (sqrt a)))
	(set 'distance (round (mul 2 r c) -3))
)

(define (get-address lat lng)
	(set 'url (append "http://maps.google.com/maps/geo?output=csv&oe=utf-8&ll=" (string lat) "," (string lng) "&key=API_KEY"))
	(set 'response (get-url url))
	(set 'location (nth 1 (parse response "\"")))
)

(define (get-latlng location api-key)
	(replace " " location "+")
	(set 'url (append "http://maps.google.com/maps/geo?output=csv&oe=utf-8&q=" location "&key=" api-key))
	(set 'response (get-url url))
	(set 'lat (nth 2 (parse response ",")))
	(set 'lng (nth 3 (parse response ",")))
	(set 'coords (list (float lat) (float lng)))
)


(context MAIN)

(set 'api-key "YOURAPIKEY")

;; Apple HQ
(set 'lat1 37.3308525)
(set 'lng1 -122.0296837)
(println (GeoTools:get-address lat1 lng1))
(println (GeoTools:get-latlng "Infinite Loop 1, Cupertino" api-key))

;; Microsoft HQ
(println (GeoTools:get-latlng "Microsoft Way, Redmond, WA 98052" api-key))
(set 'lat2 47.6447015)
(set 'lng2 -122.1301371)

;; Distance between Apple and Microsoft
(GeoTools:get-distance "km" lat1 lng1 lat2 lng2) ;; in km
(GeoTools:get-distance "miles" lat1 lng1 lat2 lng2) ;; in miles

;; END OF FILE