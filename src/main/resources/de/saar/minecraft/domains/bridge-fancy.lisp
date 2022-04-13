(defdomain house (
 
;;Operators, correspond to actions in PDDL
 (:operator (!place-block ?block-type ?x ?y ?z ?x2 ?y2 ?z2)
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((block-at ?block-type ?x ?y ?z) (last-placed ?x ?y ?z))
        2
 )

 (:operator (!remove ?block-type ?x ?y ?z)
        ((block-at ?block-type ?x ?y ?z))
        ((block-at ?block-type ?x ?y ?z))
        ((clear ?x ?y ?z))
 )

;; Methods can be decomposed into other methods or operators
;; Operators are marked with ! methods are just given by name 
(:method (remove-block ?x ?y ?z)
    block-is-empty
    ((clear ?x ?y ?z))
    ()

    block-is-filled
    ((block-at ?a ?x ?y ?z))
    ((!remove-block ?a ?x ?y ?z))
    )

(:operator (!place-block-hidden ?block-type ?x ?y ?z ?x2 ?y2 ?z2)
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((block-at ?block-type ?x ?y ?z) (last-placed 100 100 100))
        0
 )

 (:operator (!remove-block-hidden ?block-type ?x ?y ?z)
        ((block-at ?block-type ?x ?y ?z))
        ((block-at ?block-type ?x ?y ?z))
        ((clear ?x ?y ?z))
        0
 )

 (:operator (!remove-it-railing ?x ?y ?z)
        ((it-railing ?x ?y ?z))
        ((it-railing ?x ?y ?z))
        ((it-railing 100 100 100))
        10.0
    )

 (:operator (!build-railing ?x ?y ?z ?length ?dir ?x2 ?y2 ?z2)
        ((it-railing ?x2 ?y2 ?z2))
        ((it-railing ?x2 ?y2 ?z2))
        ((railing-at ?x ?y ?z ?length ?dir) (it-railing ?x ?y ?z))
        10.0

    )

(:operator (!build-railing-starting ?x ?y ?z ?length ?dir)
        ()
        ()
        ()
        0.0
    )

(:operator (!build-railing-finished ?x ?y ?z ?length ?dir ?x2 ?y2 ?z2)
        ((it-railing ?x2 ?y2 ?z2))
        ((it-railing ?x2 ?y2 ?z2))
        ((railing-at ?x ?y ?z ?length ?dir) (it-railing ?x ?y ?z))
        0.0
    )

(:operator (!build-stairs ?x ?y ?z ?width ?depth ?height ?dir ?x2 ?y2 ?z2)
        ((it-staircase ?x2 ?y2 ?z2))
        ((it-staircase ?x2 ?y2 ?z2))
        ((stairs-at ?x ?y ?z ?width ?depth ?height ?dir)(it-staircase ?x ?y ?z))
        10.0

    )

(:operator (!build-stairs-starting ?x ?y ?z ?width ?depth ?height ?dir)
        ()
        ()
        ()
        0.0
    )

(:operator (!build-stairs-finished ?x ?y ?z ?width ?depth ?height ?dir ?x2 ?y2 ?z2)
        ((it-staircase ?x2 ?y2 ?z2))
        ((it-staircase ?x2 ?y2 ?z2))
        ((stairs-at ?x ?y ?z ?width ?depth ?height ?dir) (it-staircase ?x ?y ?z))
        0.0
    )

(:operator (!remove-it-stairs ?x ?y ?z)
        ((it-staircase ?x ?y ?z))
        ((it-staircase ?x ?y ?z))
        ((it-staircase 100 100 100))
        10.0
    )


(:operator (!build-row ?x ?y ?z ?length ?dir ?x2 ?y2 ?z2)
        ((it-row ?x2 ?y2 ?z2))
        ((it-row ?x2 ?y2 ?z2))
        ((row-at ?x ?y ?z ?length ?dir) (it-row ?x ?y ?z))
        5.0
    )

(:operator (!remove-it-row ?x ?y ?z )
        ((it-row ?x ?y ?z))
        ((it-row ?x ?y ?z))
        ((it-row 100 100 100))
    )

(:operator (!remove-it-wall ?x ?y ?z )
        ((it-wall ?x ?y ?z))
        ((it-wall ?x ?y ?z))
        ((it-wall 100 100 100))
    )
(:operator (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
        ()
        ()
        ()
        0.0
    )

(:operator (!build-wall-finished ?x ?y ?z ?length ?height ?dir ?x2 ?y2 ?z2)
        ((it-wall ?x2 ?y2 ?z2))
        ((it-wall ?x2 ?y2 ?z2))
        ((wall-at ?x ?y ?z ?length ?height ?dir)(it-wall ?x ?y ?z))
        0.0
    )

(:operator (!build-wall ?x ?y ?z ?length ?height ?dir ?x2 ?y2 ?z2)
        ((it-wall ?x2 ?y2 ?z2))
        ((it-wall ?x2 ?y2 ?z2))
        ((wall-at ?x ?y ?z ?length ?height ?dir) (it-wall ?x ?y ?z))
        10.0
    )

(:operator (!build-floor-starting ?x ?y ?z ?length ?width ?dir)
        ()
        ()
        ()
        0.0
    )

(:operator (!build-floor-finished ?x ?y ?z ?length ?width ?dir)
        ()
        ()
        ((floor-at ?x ?y ?z ?length ?width ?dir))
        0.0
    )
(:operator (!build-floor ?x ?y ?z ?length ?width ?dir)
        ()
        ()
        ((floor-at ?x ?y ?z ?length ?width ?dir))
        10.0
    )

(:method (place-block ?block-type ?x ?y ?z)
    block-is-empty
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((!place-block ?block-type ?x ?y ?z ?x2 ?y2 ?z2))

    block-is-same
        ((block-at ?block-type ?x ?y ?z))
        ()

;;removes previous block in this space
    block-is-different
        ((block-at ?a ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ()

)

(:method (place-block-hidden ?block-type ?x ?y ?z)
    block-is-same
        ((block-at ?block-type ?x ?y ?z))
        ()

;;removes previous block in this space
    block-is-different
        ((block-at ?a ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        (
            ;;(!remove-block-hidden ?a ?x ?y ?z)
            ;;(!place-block-hidden ?block-type ?x ?y ?z ?x2 ?y2 ?z2)
        )

        block-is-empty
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((!place-block-hidden ?block-type ?x ?y ?z ?x2 ?y2 ?z2))

)



(:method (build-row ?x ?y ?z ?length ?dir)
    build-directly
    ((it-row ?x2 ?y2 ?z2))
    (
        (!build-row ?x ?y ?z ?length ?dir ?x2 ?y2 ?z2)
        (build-row-hidden ?x ?y ?z ?length ?dir)
    )
)

(:method (build-row ?x ?y ?z ?length ?dir)
    build-row-blockwise
    ((it-row ?x2 ?y2 ?z2))
    (
        (build-row-blockwise ?x ?y ?z ?length ?dir)
        (!remove-it-row ?x2 ?y2 ?z2)
    )
)

;;directions are given as numbers with:
;; eastequal1, westequal2, northequal3, southequal4
(:method (build-row-blockwise ?x ?y ?z ?length ?dir)
        length-one
        ((call equal ?length 1))
        ((place-block stone ?x ?y ?z))

        east
        ((call equal ?dir 1) (not (call equal ?length 1) ))
        ( 
            (place-block stone ?x ?y ?z)
            (build-row-blockwise (call + ?x 1) ?y ?z (call - ?length 1) ?dir)
        )

        west
        ((call equal ?dir 2) (not (call equal ?length 1) ))
        ( 
            (place-block stone ?x ?y ?z)
            (build-row-blockwise (call - ?x 1) ?y ?z (call - ?length 1) ?dir)
        )

        north
        ((call equal ?dir 3) (not (call equal ?length 1) ))
        ( 
            (place-block stone ?x ?y ?z)
            (build-row-blockwise ?x ?y (call - ?z 1) (call - ?length 1) ?dir)
        )

        south
        ((call equal ?dir 4) (not (call equal ?length 1) ))
        ( 
            (place-block stone ?x ?y ?z)
            (build-row-blockwise ?x ?y (call + ?z 1) (call - ?length 1) ?dir)
        )
)

(:method (build-row-hidden ?x ?y ?z ?length ?dir)
        length-one
        ((call equal ?length 1))
        ((place-block-hidden stone ?x ?y ?z))

        east
        ((call equal ?dir 1) (not (call equal ?length 1) ))
        ( 
            (place-block-hidden stone ?x ?y ?z)
            (build-row-hidden (call + ?x 1) ?y ?z (call - ?length 1) ?dir)
        )

        west
        ((call equal ?dir 2) (not (call equal ?length 1) ))
        ( 
            (place-block-hidden stone ?x ?y ?z)
            (build-row-hidden (call - ?x 1) ?y ?z (call - ?length 1) ?dir)
        )

        north
        ((call equal ?dir 3) (not (call equal ?length 1) ))
        ( 
            (place-block-hidden stone ?x ?y ?z)
            (build-row-hidden ?x ?y (call - ?z 1) (call - ?length 1) ?dir)
        )

        south
        ((call equal ?dir 4) (not (call equal ?length 1) ))
        ( 
            (place-block-hidden stone ?x ?y ?z)
            (build-row-hidden ?x ?y (call + ?z 1) (call - ?length 1) ?dir)
        )
)

;; All directions have two methods, the first starting at the given position,
;;the second starting at the other end of the railing going in the opposite direction
(:method (build-railing-east ?x ?y ?z ?length ?dir)
        east-one
        ((call equal ?dir 1))
        ( 
            (place-block stone (call - (call + ?x ?length) 1) ?y ?z)
            (place-block stone ?x ?y ?z)
            (build-row-blockwise ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-east ?x ?y ?z ?length ?dir)
        east-two
        ((call equal ?dir 1))
        ( 
            (place-block stone ?x ?y ?z)
            (place-block stone (call - (call + ?x ?length) 1) ?y ?z)
            (build-row-blockwise (call - (call + ?x ?length) 1) (call + ?y 1) ?z ?length 2)
        )
)


(:method (build-railing-west ?x ?y ?z ?length ?dir)
        west-one
        ((call equal ?dir 2) )
        ( 
            (place-block stone (call + (call - ?x ?length) 1) ?y ?z)
            (place-block stone ?x ?y ?z)
            (build-row-blockwise ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-west ?x ?y ?z ?length ?dir)
        west-two
        ((call equal ?dir 2) )
        ( 
            (place-block stone ?x ?y ?z)
            (place-block stone (call + (call - ?x ?length) 1) ?y ?z)
            (build-row-blockwise (call + (call - ?x ?length) 1) (call + ?y 1) ?z ?length 1)
        )
)

(:method (build-railing-north ?x ?y ?z ?length ?dir)
        north-one
        ((call equal ?dir 3))
        (   
            (place-block stone ?x ?y (call + (call - ?z ?length) 1))
            (place-block stone ?x ?y ?z)
            (build-row-blockwise ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-north ?x ?y ?z ?length ?dir)
        north-two
        ((call equal ?dir 3))
        ( 
            (place-block stone ?x ?y ?z)
            (place-block stone ?x ?y (call + (call - ?z ?length) 1))
            (build-row-blockwise ?x (call + ?y 1) (call + (call - ?z ?length) 1) ?length 4)
        )
)

(:method (build-railing-south ?x ?y ?z ?length ?dir)
        south-one
        ((call equal ?dir 4))
        ( 
            (place-block stone ?x ?y (call - (call + ?z ?length) 1))
            (place-block stone ?x ?y ?z)
            (build-row-blockwise ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-south ?x ?y ?z ?length ?dir)
        south-two
        ((call equal ?dir 4))
        (   
            (place-block stone ?x ?y ?z)
            (place-block stone ?x ?y (call - (call + ?z ?length) 1))
            (build-row-blockwise ?x (call + ?y 1) (call - (call + ?z ?length) 1) ?length 3)
        )
)


(:method (build-railing ?x ?y ?z ?length ?dir)

        east
        ((call equal ?dir 1) (it-railing ?x2 ?y2 ?z2))
        (
            (!build-railing-starting ?x ?y ?z ?length ?dir)
            (build-railing-east ?x ?y ?z ?length ?dir)
            (!build-railing-finished ?x ?y ?z ?length ?dir ?x2 ?y2 ?z2))

        west
        ((call equal ?dir 2) (it-railing ?x2 ?y2 ?z2))
        (
            (!build-railing-starting ?x ?y ?z ?length ?dir)
            (build-railing-west ?x ?y ?z ?length ?dir)
            (!build-railing-finished ?x ?y ?z ?length ?dir ?x2 ?y2 ?z2))

        north
        ((call equal ?dir 3) (it-railing ?x2 ?y2 ?z2))
        (
            (!build-railing-starting ?x ?y ?z ?length ?dir)
            (build-railing-north ?x ?y ?z ?length ?dir)
            (!build-railing-finished ?x ?y ?z ?length ?dir ?x2 ?y2 ?z2))

        south
        ((call equal ?dir 4) (it-railing ?x2 ?y2 ?z2))
        (
            (!build-railing-starting ?x ?y ?z ?length ?dir)
            (build-railing-south ?x ?y ?z ?length ?dir)
            (!build-railing-finished ?x ?y ?z ?length ?dir ?x2 ?y2 ?z2))
)

(:method (build-railing ?x ?y ?z ?length ?dir)

        east
        ((call equal ?dir 1)(it-railing ?x2 ?y2 ?z2))
        (
            (build-railing-east ?x ?y ?z ?length ?dir)
            (!remove-it-railing ?x2 ?y2 ?z2)
            )

        west
        ((call equal ?dir 2)(it-railing ?x2 ?y2 ?z2))
        (
            (build-railing-west ?x ?y ?z ?length ?dir)
            (!remove-it-railing ?x2 ?y2 ?z2)
            )

        north
        ((call equal ?dir 3)(it-railing ?x2 ?y2 ?z2))
        (
            (build-railing-north ?x ?y ?z ?length ?dir)
            (!remove-it-railing ?x2 ?y2 ?z2)
            )

        south
        ((call equal ?dir 4)(it-railing ?x2 ?y2 ?z2))
        (
            (build-railing-south ?x ?y ?z ?length ?dir)
            (!remove-it-railing ?x2 ?y2 ?z2)
            )
)


(:method (build-railing ?x ?y ?z ?length  ?dir)
    ((it-railing ?x2 ?y2 ?z2))
    ((!build-railing ?x ?y ?z ?length ?dir ?x2 ?y2 ?z2)
      (build-railing-hidden ?x ?y ?z ?length ?dir))
)

(:method (build-railing-hidden ?x ?y ?z ?length ?dir)

        east
        ((call equal ?dir 1))
        (
            (build-railing-east-hidden ?x ?y ?z ?length ?dir))

        west
        ((call equal ?dir 2))
        (
            (build-railing-west-hidden ?x ?y ?z ?length ?dir))

        north
        ((call equal ?dir 3))
        (
            (build-railing-north-hidden ?x ?y ?z ?length ?dir))

        south
        ((call equal ?dir 4))
        (
            (build-railing-south-hidden ?x ?y ?z ?length ?dir))
)


(:method (build-railing-east-hidden ?x ?y ?z ?length ?dir)
        east-one
        ((call equal ?dir 1))
        ( 
            (place-block-hidden stone (call - (call + ?x ?length) 1) ?y ?z)
            (place-block-hidden stone ?x ?y ?z)
            (build-row-hidden ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-west-hidden ?x ?y ?z ?length ?dir)
        west-one
        ((call equal ?dir 2) )
        ( 
            (place-block-hidden stone (call + (call - ?x ?length) 1) ?y ?z)
            (place-block-hidden stone ?x ?y ?z)
            (build-row-hidden ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-north-hidden ?x ?y ?z ?length ?dir)
        north-one
        ((call equal ?dir 3))
        (   
            (place-block-hidden stone ?x ?y (call + (call - ?z ?length) 1))
            (place-block-hidden stone ?x ?y ?z)
            (build-row-hidden ?x (call + ?y 1) ?z ?length ?dir)
        )
)


(:method (build-railing-south-hidden ?x ?y ?z ?length ?dir)
        south-one
        ((call equal ?dir 4))
        ( 
            (place-block-hidden stone ?x ?y (call - (call + ?z ?length) 1))
            (place-block-hidden stone ?x ?y ?z)
            (build-row-hidden ?x (call + ?y 1) ?z ?length ?dir)
        )
)



(:method (build-stairs ?x ?y ?z ?width ?depth ?height ?dir)
    stairs-directly
    ((it-staircase ?x2 ?y2 ?z2))
    ((!build-stairs ?x ?y ?z ?width ?depth ?height ?dir ?x2 ?y2 ?z2))
)

(:method (build-stairs ?x ?y ?z ?width ?depth ?height ?dir)
    stairs-teaching
    ((it-staircase ?x2 ?y2 ?z2))
    (   (!build-stairs-starting ?x ?y ?z ?width ?depth ?height ?dir)
        (build-stairs-wall ?x ?y ?z ?width ?depth 1 ?height ?dir)
        (!build-stairs-finished ?x ?y ?z ?width ?depth ?height ?dir ?x2 ?y2 ?z2)
    )
)

(:method (build-stairs ?x ?y ?z ?width ?depth ?height ?dir)
    stairs-wall
    ((it-staircase ?x2 ?y2 ?z2))
    ((build-stairs-wall ?x ?y ?z ?width ?depth 1 ?height ?dir)
    (!remove-it-stairs ?x2 ?y2 ?z2))
)

;;(:method (build-stairs ?x ?y ?z ?width ?depth ?height ?dir)
;;    build-plane
;;    ()
;;    ((build-stairs-plane ?x ?y ?z ?width ?depth ?height ?dir))
;;    )

;;(:method (build-stairs-plane ?x ?y ?z ?width ?depth ?height ?dir)
;;    height-one
;;    ((call equal ?height 1))
;;    ((build-row ?x ?y ?z ?width ?dir))

;;    other-height
;;    ((not (call equal ?height 1)))
;;    (
;;        (build-floor ?x ?y ?z ?width ?depth ?dir)
;;        (build-stairs-plane ?x (call + ?y 1) ?z ?width (call - ?depth 1) (call - ?height 1))
;;    )

;;)

;;directions are given as numbers with:
;; eastequal1, westequal2, northequal3, southequal4

(:method (build-stairs-wall ?x ?y ?z ?width ?depth ?height ?height-to-reach ?dir)
    height-final
    ((call equal ?height ?height-to-reach))
    ((build-wall ?x ?y ?z ?width ?height ?dir))

    height-one-east
    ((call equal ?height 1) (call equal ?dir 1))
    (   (build-row ?x ?y ?z ?width ?dir)
        (build-stairs-wall ?x ?y (call + ?z 1) ?width (call - ?depth 1) (call + ?height 1) ?height-to-reach ?dir)
    )

    east
    ((call equal ?dir 1))
    (
        (build-wall ?x ?y ?z ?width ?height ?dir)
        (build-stairs-wall ?x ?y (call + ?z 1) ?width (call - ?depth 1) (call + ?height 1) ?height-to-reach ?dir)
    )

    height-one-west
    ((call equal ?height 1) (call equal ?dir 2))
    (   (build-row ?x ?y ?z ?width ?dir)
        (build-stairs-wall ?x ?y (call - ?z 1) ?width (call - ?depth 1) (call + ?height 1) ?height-to-reach ?dir)
    )

    west
    ( (call equal ?dir 2))
    (
        (build-wall ?x ?y ?z ?width ?height ?dir)
        (build-stairs-wall ?x ?y (call - ?z 1) ?width (call - ?depth 1) (call + ?height 1) ?height-to-reach ?dir)
    )

    height-one-north
    ((call equal ?height 1) (call equal ?dir 3))
    (   (build-row ?x ?y ?z ?width ?dir)
        (build-stairs-wall (call + ?x 1) ?y ?z ?width (call - ?depth 1) (call + ?height 1) ?height-to-reach ?dir)
    )
;;z-1
    north
    ((not (call equal ?height 1)) (call equal ?dir 3))
    (
        (build-wall ?x ?y ?z ?width ?height ?dir)
        (build-stairs-wall (call + ?x 1) ?y ?z ?width (call - ?depth 1) (call + ?height 1) ?height-to-reach ?dir)
    )

    height-one-south
    ((call equal ?height 1) (call equal ?dir 4))
    (   (build-row ?x ?y ?z ?width ?dir)
        (build-stairs-wall (call - ?x 1) ?y ?z ?width (call - ?depth 1) (call + ?height 1) ?height-to-reach ?dir)
    )
;;z+1
    south
    ((not (call equal ?height 1)) (call equal ?dir 4))
    (
        (build-wall ?x ?y ?z ?width ?height ?dir)
        (build-stairs-wall (call - ?x 1) ?y ?z ?width (call - ?depth 1) (call + ?height 1) ?height-to-reach ?dir)
    )
)


(:method (build-wall ?x ?y ?z ?length ?height ?dir)
        hidden
        ((it-wall ?x2 ?y2 ?z2))
        ( (!build-wall ?x ?y ?z ?length ?height ?dir ?x2 ?y2 ?z2)
          (build-wall-hidden ?x ?y ?z ?length ?height ?dir)
        )
)

(:method (build-wall ?x ?y ?z ?length ?height ?dir)
        zero-height
        ((call equal ?height 0))
        ()

        east
        ((call equal ?dir 1) (it-wall ?x2 ?y2 ?z2))
        (
            (build-wall-east ?x ?y ?z ?length ?height ?dir)
            (!remove-it-wall ?x2 ?y2 ?z2)
            )

        west
        ((call equal ?dir 2) (it-wall ?x2 ?y2 ?z2))
        (
            (build-wall-west ?x ?y ?z ?length ?height ?dir)
            (!remove-it-wall ?x2 ?y2 ?z2)
            )

        north
        ((call equal ?dir 3) (it-wall ?x2 ?y2 ?z2))
        (
            (build-wall-north ?x ?y ?z ?length ?height ?dir)
            (!remove-it-wall ?x2 ?y2 ?z2)
            )
        south
        ((call equal ?dir 4) (it-wall ?x2 ?y2 ?z2))
        (
            (build-wall-south ?x ?y ?z ?length ?height ?dir)
            (!remove-it-wall ?x2 ?y2 ?z2)
            )

)

(:method (build-wall ?x ?y ?z ?length ?height ?dir)
        zero-height
        ((call equal ?height 0))
        ()

        east
        ((call equal ?dir 1) (it-wall ?x2 ?y2 ?z2))
        (
            (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
            (build-wall-east ?x ?y ?z ?length ?height ?dir)
            (!build-wall-finished ?x ?y ?z ?length ?height ?dir ?x2 ?y2 ?z2))

        west
        ((call equal ?dir 2) (it-wall ?x2 ?y2 ?z2))
        (
            (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
            (build-wall-west ?x ?y ?z ?length ?height ?dir)
            (!build-wall-finished ?x ?y ?z ?length ?height ?dir ?x2 ?y2 ?z2))

        north
        ((call equal ?dir 3) (it-wall ?x2 ?y2 ?z2))
        (
            (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
            (build-wall-north ?x ?y ?z ?length ?height ?dir)
            (!build-wall-finished ?x ?y ?z ?length ?height ?dir ?x2 ?y2 ?z2))

        south
        ((call equal ?dir 4) (it-wall ?x2 ?y2 ?z2))
        (
            (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
            (build-wall-south ?x ?y ?z ?length ?height ?dir)
            (!build-wall-finished ?x ?y ?z ?length ?height ?dir ?x2 ?y2 ?z2))

)


(:method (build-wall-east ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 1))
        ((build-row ?x ?y ?z ? length ?dir))

        east-one
        ((call equal ?dir 1) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y ?z ?length ?dir)
            (build-wall-west (call - (call + ?x ?length) 1) (call + ?y 1) ?z ?length (call - ?height 1) 2)
        )
)

;;(:method (build-wall-east ?x ?y ?z ?length ?height ?dir)
;;        height-one
;;        ((call equal ?height 1) (call equal ?dir 1))
;;        ((build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2))

;;        east-two
;;        ((call equal ?dir 1) (not (call equal ?height 1)))
;;        ( 
;;            (build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2)
;;            (build-wall-east ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
;;        )
;;)


(:method (build-wall-west ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 2))
        ((build-row ?x ?y ?z ?length ?dir))

        west-one
        ((call equal ?dir 2) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y ?z ?length ?dir)
            (build-wall-east (call + (call - ?x ?length) 1) (call + ?y 1) ?z ?length (call - ?height 1) 1)
        )
)

;;(:method (build-wall-west ?x ?y ?z ?length ?height ?dir)
;;        height-one
;;        ((call equal ?height 1) (call equal ?dir 2))
;;        ((build-row (call + (call - ?x ?length) 1) ?y ?z ?length 1))

;;        west-two
;;        ((call equal ?dir 2) (not (call equal ?height 1)))
;;        ( 
;;            (build-row (call + (call - ?x ?length) 1) ?y ?z ?length 1)
;;            (build-wall-west ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
;;        )
;;)

(:method (build-wall-north ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 3))
        ((build-row ?x ?y ?z ?length ?dir))

        north-one
        ((call equal ?dir 3) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y ?z ?length ?dir)
            (build-wall-south ?x (call + ?y 1) (call + (call - ?z ?length) 1) ?length (call - ?height 1) 4)
        )
)

;;(:method (build-wall-north ?x ?y ?z ?length ?height ?dir)
;;        height-one
;;        ((call equal ?height 1) (call equal ?dir 3))
;;        ((build-row ?x ?y (call + (call - ?z ?length) 1) ?length 4))

;;        north-two
;;        ((call equal ?dir 3) (not (call equal ?height 1)))
;;        ( 
;;            (build-row ?x ?y (call + (call - ?z ?length) 1) ?length 4)
;;            (build-wall-north ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
;;        )
;;)

(:method (build-wall-south ?x ?y ?z ?length ?height ?dir)
        height
        ((call equal ?height 1) (call equal ?dir 4))
        ((build-row ?x ?y ?z ?length ?dir))

        south-one
        ((call equal ?dir 4) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y ?z ?length ?dir)
            (build-wall-north ?x (call + ?y 1) (call - (call + ?z ?length) 1) ?length (call - ?height 1) 3)
        )

)

;;(:method (build-wall-south ?x ?y ?z ?length ?height ?dir)
;;        height-one
;;        ((call equal ?height 1) (call equal ?dir 4))
;;        ((build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3))

;;        south-two
;;        ((call equal ?dir 4) (not (call equal ?height 1)))
;;        ( 
;;            (build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3)
;;            (build-wall-south ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
;;        )
;;)

(:method (build-wall-hidden ?x ?y ?z ?length ?height ?dir)
        zero-height
        ((call equal ?height 0))
        ()

        east
        ((call equal ?dir 1))
        ((build-wall-east-hidden ?x ?y ?z ?length ?height ?dir))

        west
        ((call equal ?dir 2))
        ((build-wall-west-hidden ?x ?y ?z ?length ?height ?dir))

        north
        ((call equal ?dir 3))
        ((build-wall-north-hidden ?x ?y ?z ?length ?height ?dir))

        south
        ((call equal ?dir 4))
        ((build-wall-south-hidden ?x ?y ?z ?length ?height ?dir))

)

(:method (build-wall-east-hidden ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 1))
        ((build-row-hidden ?x ?y ?z ? length ?dir))

        east-one
        ((call equal ?dir 1) (not (call equal ?height 1)))
        ( 
            (build-row-hidden ?x ?y ?z ?length ?dir)
            (build-wall-east-hidden ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)

(:method (build-wall-west-hidden ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 2))
        ((build-row-hidden ?x ?y ?z ?length ?dir))

        west-one
        ((call equal ?dir 2) (not (call equal ?height 1)))
        ( 
            (build-row-hidden ?x ?y ?z ?length ?dir)
            (build-wall-west-hidden ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)

(:method (build-wall-north-hidden ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 3))
        ((build-row-hidden ?x ?y ?z ?length ?dir))

        north-one
        ((call equal ?dir 3) (not (call equal ?height 1)))
        ( 
            (build-row-hidden ?x ?y ?z ?length ?dir)
            (build-wall-north-hidden ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)

(:method (build-wall-south-hidden ?x ?y ?z ?length ?height ?dir)
        height
        ((call equal ?height 1) (call equal ?dir 4))
        ((build-row-hidden ?x ?y ?z ?length ?dir))

        south-one
        ((call equal ?dir 4) (not (call equal ?height 1)))
        ( 
            (build-row-hidden ?x ?y ?z ?length ?dir)
            (build-wall-south-hidden ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )

)

(:method (build-floor-east ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 1))
        ((build-row ?x ?y ?z ?length 4))

        east-one
        ((call equal ?dir 1) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 4)
            (build-floor-east (call + ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-floor-east ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 1))
        ((build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3))

        east-two
        ((call equal ?dir 1) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3)
            (build-floor-east (call + ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-floor-west ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 2))
        ((build-row ?x ?y ?z ?length 4))

        west-one
        ((call equal ?dir 2) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 4)
            (build-floor-west (call - ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-floor-west ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 2))
        ((build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3))

        west-two
        ((call equal ?dir 2) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3)
            (build-floor-west (call - ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-floor-north ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 3))
        ((build-row ?x ?y ?z ?length 1))

        north-one
        ((call equal ?dir 3) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 1)
            (build-floor-north ?x ?y (call - ?z 1) ?length (call - ?width 1) ?dir)
        )

)

(:method (build-floor-north ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 3))
        ((build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2))

        north-two
        ((call equal ?dir 3) (not (call equal ?width 1)))
        ( 
            (build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2)
            (build-floor-north ?x ?y (call - ?z 1) ?length (call - ?width 1) ?dir)
        )
)

(:method (build-floor-south ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 4))
        ((build-row ?x ?y ?z ?length 1))

        south-one
        ((call equal ?dir 4) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 1)
            (build-floor-south ?x ?y (call + ?z 1) ?length (call - ?width 1) ?dir)
        )
)

(:method (build-floor-south ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 4))
        ((build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2))

        south-two
        ((call equal ?dir 4) (not (call equal ?width 1)))
        (
            (build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2)
            (build-floor-south ?x ?y (call + ?z 1) ?length (call - ?width 1) ?dir)
        )
)
    

(:method (build-floor ?x ?y ?z ?length ?width ?dir)
        zero-height
        ((call equal ?width 0))
        ()

        east
        ((call equal ?dir 1))
        ((build-floor-east ?x ?y ?z ?length ?width ?dir))

        west
        ((call equal ?dir 2))
        ((build-floor-west ?x ?y ?z ?length ?width ?dir))

        north
        ((call equal ?dir 3))
        ((build-floor-north ?x ?y ?z ?length ?width ?dir))

        south
        ((call equal ?dir 4))
        ((build-floor-south ?x ?y ?z ?length ?width ?dir))
)

(:method (build-floor ?x ?y ?z ?length ?width ?dir)
        zero-height
        ((call equal ?width 0))
        ()

        east
        ((call equal ?dir 1))
        (
            (!build-floor-starting ?x ?y ?z ?length ?width ?dir)
            (build-floor-east ?x ?y ?z ?length ?width ?dir)
            (!build-floor-finished ?x ?y ?z ?length ?width ?dir))

        west
        ((call equal ?dir 2))
        (
            (!build-floor-starting ?x ?y ?z ?length ?width ?dir)
            (build-floor-west ?x ?y ?z ?length ?width ?dir)
            (!build-floor-finished ?x ?y ?z ?length ?width ?dir))

        north
        ((call equal ?dir 3))
        (
            (!build-floor-starting ?x ?y ?z ?length ?width ?dir)
            (build-floor-north ?x ?y ?z ?length ?width ?dir)
            (!build-floor-finished ?x ?y ?z ?length ?width ?dir))

        south
        ((call equal ?dir 4))
        (
            (!build-floor-starting ?x ?y ?z ?length ?width ?dir)
            (build-floor-south ?x ?y ?z ?length ?width ?dir)
            (!build-floor-finished ?x ?y ?z ?length ?width ?dir))
)

(:method (build-floor ?x ?y ?z ?length ?width ?dir)
    ()
    ((!build-floor ?x ?y ?z ?length ?width ?dir)
        (build-floor-hidden ?x ?y ?z ?length ?width ?dir))

    )

(:method (build-floor-hidden ?x ?y ?z ?length ?width ?dir)
        zero-height
        ((call equal ?width 0))
        ()

        east
        ((call equal ?dir 1))
        (
            (build-floor-east-hidden ?x ?y ?z ?length ?width ?dir))

        west
        ((call equal ?dir 2))
        (
            (build-floor-west-hidden ?x ?y ?z ?length ?width ?dir))

        north
        ((call equal ?dir 3))
        (
            (build-floor-north-hidden ?x ?y ?z ?length ?width ?dir))

        south
        ((call equal ?dir 4))
        (
            (build-floor-south-hidden ?x ?y ?z ?length ?width ?dir))
)


(:method (build-floor-east-hidden ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 1))
        ((build-row-hidden ?x ?y ?z ?length 4))

        east-one
        ((call equal ?dir 1) (not (call equal ?width 1)))
        ( 
            (build-row-hidden ?x ?y ?z ?length 4)
            (build-floor-east-hidden (call + ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-floor-west-hidden ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 2))
        ((build-row-hidden ?x ?y ?z ?length 4))

        west-one
        ((call equal ?dir 2) (not (call equal ?width 1)))
        ( 
            (build-row-hidden ?x ?y ?z ?length 4)
            (build-floor-west-hidden (call - ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-floor-north-hidden ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 3))
        ((build-row-hidden ?x ?y ?z ?length 1))

        north-one
        ((call equal ?dir 3) (not (call equal ?width 1)))
        ( 
            (build-row-hidden ?x ?y ?z ?length 1)
            (build-floor-north-hidden ?x ?y (call - ?z 1) ?length (call - ?width 1) ?dir)
        )

)

(:method (build-floor-south-hidden ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 4))
        ((build-row-hidden ?x ?y ?z ?length 1))

        south-one
        ((call equal ?dir 4) (not (call equal ?width 1)))
        ( 
            (build-row-hidden ?x ?y ?z ?length 1)
            (build-floor-south-hidden ?x ?y (call + ?z 1) ?length (call - ?width 1) ?dir)
        )
)

(:method (build-bridge ?x ?y ?z ?width ?length ?height)
        ()
        (
            (build-stairs ?x ?y ?z ?width ?height ?height 1)
            (build-stairs (call - (call +?x ?height) 1) ?y (call + (call + ?z ?length) ?height) ?width ?height ?height 2)
            (build-floor ?x (call - (call + ?y ?height) 1) (call + ?z ?height) (call - ?length 2) ?width 1)
            (build-railing ?x (call + ?y ?height) (call - (call + ?z ?height) 1) ?length 4)
            (build-railing (call - (call + ?x ?width ) 1) (call + ?y ?height) (call - (call + ?z ?height) 1) ?length 4)
        )
)   

;;Axioms
(:- (clear ?x ?y ?z)
    ((not (block-at ?type ?x ?y ?z)))
    )

)
)

