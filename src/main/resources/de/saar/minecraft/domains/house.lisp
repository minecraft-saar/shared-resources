(defdomain house (
 
;;Operators, correspond to actions in PDDL
 (:operator (!place-block ?block-type ?x ?y ?z ?x2 ?y2 ?z2)
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((block-at ?block-type ?x ?y ?z) (last-placed ?x ?y ?z))
        2
 )

 (:operator (!remove-block ?block-type ?x ?y ?z)
        ((block-at ?block-type ?x ?y ?z))
        ((block-at ?block-type ?x ?y ?z))
        ((clear ?x ?y ?z))
 )

 (:operator (!place-block-hidden ?block-type ?x ?y ?z ?x2 ?y2 ?z2)
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((block-at ?block-type ?x ?y ?z) (last-placed ?x ?y ?z))
        0
 )

 (:operator (!remove-block-hidden ?block-type ?x ?y ?z)
        ((block-at ?block-type ?x ?y ?z))
        ((block-at ?block-type ?x ?y ?z))
        ((clear ?x ?y ?z))
        0
 )
;;has to be called in correct context, see precondiction in place-block block-is-adjacent
;;Action has only cost of 0.5 instead of 1
;(:operator (!place-adjacent ?block-type ?x ?y ?z ?x2 ?y2 ?z2)
;        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))  
;        ((last-placed ?x2 ?y2 ?z2) (clear ?x ?y ?z))
;        ((last-placed ?x ?y ?z) (block-at ?block-type ?x ?y ?z))
;        0.1
;    )

(:operator (!build-row ?x ?y ?z ?length ?dir)
        ()
        ()
        ((row-at ?x ?y ?z ?length ?dir))
        5.0
    )

(:operator (!build-wall ?x ?y ?z ?length ?height ?dir)
        ()
        ()
        ((wall-at ?x ?y ?z ?length ?dir))
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

;(:method (place-block ?block-type ?x ?y ?z)
;    block-is-adjacent-x
;    	((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2) (call equal ?y ?y2) (call equal ?z ?z2) (not (list (not (call equal (call - ?x 1.0) ?x2))  (not (call equal (call + ?x 1.0) ?x2)) )) )
;    	((!place-adjacent ?block-type ?x ?y ?z ?x2 ?y2 ?z2))

;    block-is-adjacent-y
;    	((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2) (call equal ?x ?x2) (call equal ?z ?z2) (not (list (not (call equal (call - ?y 1.0) ?y2))  (not (call equal (call + ?y 1.0) ?y2)) )) )
;    	((!place-adjacent ?block-type ?x ?y ?z ?x2 ?y2 ?z2))

;    block-is-adjacent-z
;    	((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2) (call equal ?x ?x2) (call equal ?y ?y2) (not (list (not (call equal (call - ?z 1.0) ?z2))  (not (call equal (call + ?z 1.0) ?z2)) )) )
;    	((!place-adjacent ?block-type ?x ?y ?z ?x2 ?y2 ?z2))

;)

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
        (
            ;;(!remove-block ?a ?x ?y ?z)
            ;;(!place-block ?block-type ?x ?y ?z ?x2 ?y2 ?z2)
        )

)

(:method (place-block-hidden ?block-type ?x ?y ?z)
    block-is-empty
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((!place-block-hidden ?block-type ?x ?y ?z ?x2 ?y2 ?z2))

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

)

(:method (build-row ?x ?y ?z ?length ?dir)
    build-directly
    ((last-placed ?x2 ?y2 ?z2 ))
    (
        (!build-row ?x ?y ?z ?length ?dir)
        (build-row-hidden ?x ?y ?z ?length ?dir)
    )
)

(:method (build-row ?x ?y ?z ?length ?dir)
    build-row-blockwise
    ()
    (
        (build-row-blockwise ?x ?y ?z ?length ?dir)
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
;;the second starting at the other end of the wall going in the opposite direction
(:method (build-wall-east ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 1))
        ((build-row ?x ?y ?z ? length ?dir))

        east-one
        ((call equal ?dir 1) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y ?z ?length ?dir)
            (build-wall-east ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)

(:method (build-wall-east ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 1))
        ((build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2))

        east-two
        ((call equal ?dir 1) (not (call equal ?height 1)))
        ( 
            (build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2)
            (build-wall-east ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)


(:method (build-wall-west ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 2))
        ((build-row ?x ?y ?z ?length ?dir))

        west-one
        ((call equal ?dir 2) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y ?z ?length ?dir)
            (build-wall-west ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)

(:method (build-wall-west ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 2))
        ((build-row (call + (call - ?x ?length) 1) ?y ?z ?length 1))

        west-two
        ((call equal ?dir 2) (not (call equal ?height 1)))
        ( 
            (build-row (call + (call - ?x ?length) 1) ?y ?z ?length 1)
            (build-wall-west ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)

(:method (build-wall-north ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 3))
        ((build-row ?x ?y ?z ?length ?dir))

        north-one
        ((call equal ?dir 3) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y ?z ?length ?dir)
            (build-wall-north ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)

(:method (build-wall-north ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 3))
        ((build-row ?x ?y (call + (call - ?z ?length) 1) ?length 4))

        north-two
        ((call equal ?dir 3) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y (call + (call - ?z ?length) 1) ?length 4)
            (build-wall-north ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)

(:method (build-wall-south ?x ?y ?z ?length ?height ?dir)
        height
        ((call equal ?height 1) (call equal ?dir 4))
        ((build-row ?x ?y ?z ?length ?dir))

        south-one
        ((call equal ?dir 4) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y ?z ?length ?dir)
            (build-wall-south ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )

)

(:method (build-wall-south ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 4))
        ((build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3))

        south-two
        ((call equal ?dir 4) (not (call equal ?height 1)))
        ( 
            (build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3)
            (build-wall-south ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)


(:method (build-wall ?x ?y ?z ?length ?height ?dir)
        zero-height
        ((call equal ?height 0))
        ()

        east
        ((call equal ?dir 1))
        ((build-wall-east ?x ?y ?z ?length ?height ?dir))

        west
        ((call equal ?dir 2))
        ((build-wall-west ?x ?y ?z ?length ?height ?dir))

        north
        ((call equal ?dir 3))
        ((build-wall-north ?x ?y ?z ?length ?height ?dir))

        south
        ((call equal ?dir 4))
        ((build-wall-south ?x ?y ?z ?length ?height ?dir))

)

(:method (build-wall ?x ?y ?z ?length ?height ?dir)
        hidden
        ()
        ( (!build-wall ?x ?y ?z ?length ?height ?dir)
          (build-wall-hidden ?x ?y ?z ?length ?height ?dir)
        )
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

(:method (build-wall-east-hidden ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 1))
        ((build-row-hidden (call - (call + ?x ?length) 1) ?y ?z ?length 2))

        east-two
        ((call equal ?dir 1) (not (call equal ?height 1)))
        ( 
            (build-row-hidden (call - (call + ?x ?length) 1) ?y ?z ?length 2)
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

(:method (build-wall-west-hidden ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 2))
        ((build-row-hidden (call + (call - ?x ?length) 1) ?y ?z ?length 1))

        west-two
        ((call equal ?dir 2) (not (call equal ?height 1)))
        ( 
            (build-row-hidden (call + (call - ?x ?length) 1) ?y ?z ?length 1)
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

(:method (build-wall-north-hidden ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 3))
        ((build-row-hidden ?x ?y (call + (call - ?z ?length) 1) ?length 4))

        north-two
        ((call equal ?dir 3) (not (call equal ?height 1)))
        ( 
            (build-row-hidden ?x ?y (call + (call - ?z ?length) 1) ?length 4)
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

(:method (build-wall-south-hidden ?x ?y ?z ?length ?height ?dir)
        height-one
        ((call equal ?height 1) (call equal ?dir 4))
        ((build-row-hidden ?x ?y (call - (call + ?z ?length) 1) ?length 3))

        south-two
        ((call equal ?dir 4) (not (call equal ?height 1)))
        ( 
            (build-row-hidden ?x ?y (call - (call + ?z ?length) 1) ?length 3)
            (build-wall-south-hidden ?x (call + ?y 1) ?z ?length (call - ?height 1) ?dir)
        )
)


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

(:method (build-roof-east ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 1))
        ((build-row ?x ?y ?z ? length 4))

        east-one
        ((call equal ?dir 1) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 4)
            (build-roof-east (call + ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-roof-east ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 1))
        ((build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3))

        east-two
        ((call equal ?dir 1) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3)
            (build-roof-east (call + ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-roof-west ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 2))
        ((build-row ?x ?y ?z ?length 4))

        west-one
        ((call equal ?dir 2) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 4)
            (build-roof-west (call - ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-roof-west ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 2))
        ((build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3))

        west-two
        ((call equal ?dir 2) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3)
            (build-roof-west (call - ?x 1) ?y ?z ?length (call - ?width 1) ?dir)
        )
)

(:method (build-roof-north ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 3))
        ((build-row ?x ?y ?z ?length 1))

        north-one
        ((call equal ?dir 3) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 1)
            (build-roof-north ?x ?y (call - ?z 1) ?length (call - ?width 1) ?dir)
        )

)

(:method (build-roof-north ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 3))
        ((build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2))

        north-two
        ((call equal ?dir 3) (not (call equal ?width 1)))
        ( 
            (build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2)
            (build-roof-north ?x ?y (call - ?z 1) ?length (call - ?width 1) ?dir)
        )
)

(:method (build-roof-south ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 4))
        ((build-row ?x ?y ?z ?length 1))

        south-one
        ((call equal ?dir 4) (not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 1)
            (build-roof-south ?x ?y (call + ?z 1) ?length (call - ?width 1) ?dir)
        )

)

(:method (build-roof-south ?x ?y ?z ?length ?width ?dir)
        width-one
        ((call equal ?width 1) (call equal ?dir 4))
        ((build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2))

        south-two
        ((call equal ?dir 4) (not (call equal ?width 1)))
        ( 
            (build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2)
            (build-roof-south ?x ?y (call + ?z 1) ?length (call - ?width 1) ?dir)
        )
)


(:method (build-roof ?x ?y ?z ?length ?width ?dir)
        zero-height
        ((call equal ?width 0))
        ()

        east
        ((call equal ?dir 1))
        ((build-roof-east ?x ?y ?z ?length ?width ?dir))

        west
        ((call equal ?dir 2))
        ((build-roof-west ?x ?y ?z ?length ?width ?dir))

        north
        ((call equal ?dir 3))
        ((build-roof-north ?x ?y ?z ?length ?width ?dir))

        south
        ((call equal ?dir 4))
        ((build-roof-south ?x ?y ?z ?length ?width ?dir))
)

(:method (build-door ?x ?y ?z)
    ()
    (
        (remove-block ?x ?y ?z)
        (remove-block ?x (call + ?y 1) ?z)
    )
)

(:method (build-house ?x ?y ?z ?width ?length ?height)
        ()
        (
            (build-wall ?x ?y ?z ?width ?height 1)
            (build-wall (call - (call + ?x ?width ) 1) ?y ?z ?length ?height 4)
            (build-wall (call - (call + ?x ?width) 1) ?y (call - (call + ?z ?length) 1) ?width ?height 2)
            (build-wall ?x ?y (call - (call + ?z ?length) 1) ?length ?height 3)
            (build-roof ?x (call + ?y ?height) ?z ?length ?width 1)
        )
)   

;;Axioms
(:- (clear ?x ?y ?z)
    ((not (block-at ?type ?x ?y ?z)))
    )

)
)

