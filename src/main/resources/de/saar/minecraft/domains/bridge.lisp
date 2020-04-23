(defdomain house (
 
;;Operators, correspond to actions in PDDL
 (:operator (!place-block ?block-type ?x ?y ?z ?x2 ?y2 ?z2)
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((block-at ?block-type ?x ?y ?z) (last-placed ?x ?y ?z))
        2
 )

 (:operator (!mine ?block-type ?x ?y ?z)
        ((block-at ?block-type ?x ?y ?z))
        ((block-at ?block-type ?x ?y ?z))
        ((clear ?x ?y ?z))
 )

(:operator (!build-railing ?x ?y ?z ?length ?dir)
        ()
        ()
        ((railing-at ?x ?y ?z ?length ?dir))
        10.0

    )

(:operator (!build-railing-starting ?x ?y ?z ?length ?dir)
        ()
        ()
        ()
        0.0
    )

(:operator (!build-railing-finished ?x ?y ?z ?length ?dir)
        ()
        ()
        ((railing-at ?x ?y ?z ?length ?dir))
        0.0
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


;;directions are given as numbers with:
;; eastequal1, westequal2, northequal3, southequal4
(:method (build-row ?x ?y ?z ?length ?dir)
        length-one
        ((call equal ?length 1))
        ((place-block stone ?x ?y ?z))

        east
        ((call equal ?dir 1) (not (call equal ?length 1) ))
        ( 
            (place-block stone ?x ?y ?z)
            (build-row (call + ?x 1) ?y ?z (call - ?length 1) ?dir)
        )

        west
        ((call equal ?dir 2) (not (call equal ?length 1) ))
        ( 
            (place-block stone ?x ?y ?z)
            (build-row (call - ?x 1) ?y ?z (call - ?length 1) ?dir)
        )

        north
        ((call equal ?dir 3) (not (call equal ?length 1) ))
        ( 
            (place-block stone ?x ?y ?z)
            (build-row ?x ?y (call - ?z 1) (call - ?length 1) ?dir)
        )

        south
        ((call equal ?dir 4) (not (call equal ?length 1) ))
        ( 
            (place-block stone ?x ?y ?z)
            (build-row ?x ?y (call + ?z 1) (call - ?length 1) ?dir)
        )
)


;; All directions have two methods, the first starting at the given position,
;;the second starting at the other end of the railing going in the opposite direction
;;east=1=>x+, west=2=>x-, north=3=>z-, south=4=>z+
(:method (build-railing-east ?x ?y ?z ?length ?dir)
        east-one
        ((call equal ?dir 1))
        ( 
            (place-block stone (call - (call + ?x ?length) 1) ?y ?z)
            (place-block stone ?x ?y ?z)
            (build-row ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-east ?x ?y ?z ?length ?dir)
        east-two
        ((call equal ?dir 1))
        ( 
            (place-block stone ?x ?y ?z)
            (place-block stone (call - (call + ?x ?length) 1) ?y ?z)
            (build-row (call - (call + ?x ?length) 1) (call + ?y 1) ?z ?length 2)
        )
)


(:method (build-railing-west ?x ?y ?z ?length ?dir)
        west-one
        ((call equal ?dir 2) )
        ( 
            (place-block stone (call + (call - ?x ?length) 1) ?y ?z)
            (place-block stone ?x ?y ?z)
            (build-row ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-west ?x ?y ?z ?length ?dir)
        west-two
        ((call equal ?dir 2) )
        ( 
            (place-block stone ?x ?y ?z)
            (place-block stone (call + (call - ?x ?length) 1) ?y ?z)
            (build-row (call + (call - ?x ?length) 1) (call + ?y 1) ?z ?length 1)
        )
)

(:method (build-railing-north ?x ?y ?z ?length ?dir)
        north-one
        ((call equal ?dir 3))
        (   
            (place-block stone ?x ?y (call + (call - ?z ?length) 1))
            (place-block stone ?x ?y ?z)
            (build-row ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-north ?x ?y ?z ?length ?dir)
        north-two
        ((call equal ?dir 3))
        ( 
            (place-block stone ?x ?y ?z)
            (place-block stone ?x ?y (call + (call - ?z ?length) 1))
            (build-row ?x (call + ?y 1) (call + (call - ?z ?length) 1) ?length 4)
        )
)

(:method (build-railing-south ?x ?y ?z ?length ?dir)
        south-one
        ((call equal ?dir 4))
        ( 
            (place-block stone ?x ?y (call - (call + ?z ?length) 1))
            (place-block stone ?x ?y ?z)
            (build-row ?x (call + ?y 1) ?z ?length ?dir)
        )
)

(:method (build-railing-south ?x ?y ?z ?length ?dir)
        south-two
        ((call equal ?dir 4))
        (   
            (place-block stone ?x ?y ?z)
            (place-block stone ?x ?y (call - (call + ?z ?length) 1))
            (build-row ?x (call + ?y 1) (call - (call + ?z ?length) 1) ?length 3)
        )
)


(:method (build-railing ?x ?y ?z ?length ?dir)

        east
        ((call equal ?dir 1))
        (
            (!build-railing-starting ?x ?y ?z ?length ?dir)
            (build-railing-east ?x ?y ?z ?length ?dir)
            (!build-railing-finished ?x ?y ?z ?length ?dir))

        west
        ((call equal ?dir 2))
        (
            (!build-railing-starting ?x ?y ?z ?length ?dir)
            (build-railing-west ?x ?y ?z ?length ?dir)
            (!build-railing-finished ?x ?y ?z ?length ?dir))

        north
        ((call equal ?dir 3))
        (
            (!build-railing-starting ?x ?y ?z ?length ?dir)
            (build-railing-north ?x ?y ?z ?length ?dir)
            (!build-railing-finished ?x ?y ?z ?length ?dir))

        south
        ((call equal ?dir 4))
        (
            (!build-railing-starting ?x ?y ?z ?length ?dir)
            (build-railing-south ?x ?y ?z ?length ?dir)
            (!build-railing-finished ?x ?y ?z ?length ?dir))
)

(:method (build-railing ?x ?y ?z ?length  ?dir)
    ()
    ((!build-railing ?x ?y ?z ?length ?dir))
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
    ((!build-floor ?x ?y ?z ?length ?width ?dir))

    )

(:method (build-bridge ?x ?y ?z ?length ?width)
        ()
        (
            (build-floor ?x ?y ?z ?length ?width 4)
            (build-railing ?x (call + ?y 1) ?z ?length 1)
            (build-railing (call - (call + ?x ?length ) 1) (call + ?y 1) (call - (call + ?z ?width ) 1) ?length  2)
        )
)   

;;Axioms
(:- (clear ?x ?y ?z)
    ((not (block-at ?type ?x ?y ?z)))
    )

)
)

