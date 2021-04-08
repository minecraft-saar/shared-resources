(defdomain busstop (
;;new or adjusted as comment over new or adjusted methods/operators, otherwise it is just copied from house.lisp
;;costs of operators choosen equal to similiar methods 
 
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

(:operator (!build-row ?x ?y ?z ?length ?dir)
        ()
        ()
        ((row-at ?x ?y ?z ?length ?dir))
        5.0
    )

(:operator (!build-wall ?x ?y ?z ?length ?height ?dir)
        ()
        ()
        ((wall-at ?x ?y ?z ?length ?height ?dir))
        10.0
    )

(:operator (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
        ()
        ()
        ()
        0.0
    )

(:operator (!build-wall-finished ?x ?y ?z ?length ?height ?dir)
        ()
        ()
        ((wall-at ?x ?y ?z ?length ?height ?dir))
        0.0
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

    block-is-different
        ((block-at ?a ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ()

)

(:method (place-block-hidden ?block-type ?x ?y ?z)
    block-is-empty
        ((clear ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ((!place-block-hidden ?block-type ?x ?y ?z ?x2 ?y2 ?z2))

    block-is-same
        ((block-at ?block-type ?x ?y ?z))
        ()

    block-is-different
        ((block-at ?a ?x ?y ?z) (last-placed ?x2 ?y2 ?z2))
        ()

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
        (
            (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
            (build-wall-east ?x ?y ?z ?length ?height ?dir)
            (!build-wall-finished ?x ?y ?z ?length ?height ?dir))

        west
        ((call equal ?dir 2))
        (
            (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
            (build-wall-west ?x ?y ?z ?length ?height ?dir)
            (!build-wall-finished ?x ?y ?z ?length ?height ?dir))

        north
        ((call equal ?dir 3))
        (
            (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
            (build-wall-north ?x ?y ?z ?length ?height ?dir)
            (!build-wall-finished ?x ?y ?z ?length ?height ?dir))

        south
        ((call equal ?dir 4))
        (
            (!build-wall-starting ?x ?y ?z ?length ?height ?dir)
            (build-wall-south ?x ?y ?z ?length ?height ?dir)
            (!build-wall-finished ?x ?y ?z ?length ?height ?dir))

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

;;adjusted
(:method (build-roof-east ?x ?y ?z ?length ?width)
        width-one
        ((call equal ?width 1))
        ((build-row ?x ?y ?z ?length 1))

        east-one
        ((not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 1)
            (build-roof-east ?x ?y (call + ?z 1) ?length (call - ?width 1))
        )
)

;;adjusted
(:method (build-roof-east ?x ?y ?z ?length ?width)
        width-one
        ((call equal ?width 1))
        ((build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2))

        east-two
        ((not (call equal ?width 1)))
        ( 
            (build-row (call - (call + ?x ?length) 1) ?y ?z ?length 2)
            (build-roof-east ?x ?y (call + ?z 1) ?length (call - ?width 1))
        )
)

;;adjusted
(:method (build-roof-west ?x ?y ?z ?length ?width)
        width-one
        ((call equal ?width 1))
        ((build-row ?x ?y ?z ?length 2))

        west-one
        ((not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 2)
            (build-roof-west ?x ?y (call - ?z 1) ?length (call - ?width 1))
        )
)

;;adjusted
(:method (build-roof-west ?x ?y ?z ?length ?width)
        width-one
        ((call equal ?width 1))
        ((build-row (call + (call - ?x ?length) 1) ?y ?z ?length 1))

        west-two
        ((not (call equal ?width 1)))
        ( 
            (build-row (call + (call - ?x ?length) 1) ?y ?z ?length 1)
            (build-roof-west ?x ?y (call - ?z 1) ?length (call - ?width 1))
        )
)

;;adjusted
(:method (build-roof-north ?x ?y ?z ?length ?width)
        width-one
        ((call equal ?width 1))
        ((build-row ?x ?y ?z ?length 3))

        north-one
        ((not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 3)
            (build-roof-north (call + ?x 1) ?y ?z ?length (call - ?width 1))
        )

)

;;adjusted
(:method (build-roof-north ?x ?y ?z ?length ?width)
        width-one
        ((call equal ?width 1))
        ((build-row (call - (call + ?x ?length) 1) ?y ?z ?length 4))

        north-two
        ((not (call equal ?width 1)))
        ( 
            (build-row ?x ?y (call + (call - ?z ?length) 1) ?length 4)
            (build-roof-north (call + ?x 1) ?y ?z ?length (call - ?width 1))
        )
)

;;adjusted
(:method (build-roof-south ?x ?y ?z ?length ?width)
        width-one
        ((call equal ?width 1))
        ((build-row ?x ?y ?z ?length 4))

        south-one
        ((not (call equal ?width 1)))
        ( 
            (build-row ?x ?y ?z ?length 4)
            (build-roof-south (call - ?x 1) ?y ?z ?length (call - ?width 1))
        )

)

;;adjusted
(:method (build-roof-south ?x ?y ?z ?length ?width)
        width-one
        ((call equal ?width 1))
        ((build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3))

        south-two
        ((not (call equal ?width 1)))
        ( 
            (build-row ?x ?y (call - (call + ?z ?length) 1) ?length 3)
            (build-roof-south (call - ?x 1) ?y ?z ?length (call - ?width 1))
        )
)

;;adjusted
(:method (build-roof ?x ?y ?z ?length ?width ?dir)
        zero-height
        ((call equal ?width 0))
        ()

        east
        ((call equal ?dir 1))
        ((build-roof-east ?x ?y ?z ?length ?width))

        west
        ((call equal ?dir 2))
        ((build-roof-west ?x ?y ?z ?length ?width))

        north
        ((call equal ?dir 3))
        ((build-roof-north ?x ?y ?z ?length ?width))

        south
        ((call equal ?dir 4))
        ((build-roof-south ?x ?y ?z ?length ?width))
)

;;adjusted
;;?dir: parameter to indicate on which side of the busstop is the opening and there the roof is also two blocks longer than the rest of the roof
;;longer wall is parameter ?width, smaller wall is parameter ?length
(:method (build-busstop ?x ?y ?z ?width ?length ?height ?dir)
        east
        ((call equal ?dir 1))
        (
            ;;build wall direction east
            (build-wall ?x ?y ?z ?length ?height 1)
            
            ;;build wall direction west
            (build-wall (call - (call + ?x ?length) 1) ?y (call - (call + ?z ?width) 1) ?length ?height 2)
            
            ;;build wall direction north
            (build-wall ?x ?y (call - (call + ?z ?width) 1) ?width ?height 3)
            
            ;;build roof beginning on wall direction north
            (build-roof ?x (call + ?y ?height) (call - (call + ?z ?width) 1) ?width (call + ?length 2) 3)
        )
        
        west
        ((call equal ?dir 2))
        (
            ;;build wall direction east
            (build-wall ?x ?y ?z ?length ?height 1)
            
            ;;build wall direction west
            (build-wall (call - (call + ?x ?length) 1) ?y (call - (call + ?z ?width) 1) ?length ?height 2)
        
            ;;build wall direction south
            (build-wall (call - (call + ?x ?length ) 1) ?y ?z ?width ?height 4)
            
            ;;build roof beginning on wall direction south
            (build-roof (call - (call + ?x ?length ) 1) (call + ?y ?height) ?z ?width (call + ?length 2) 4)
        )
        
        north
        ((call equal ?dir 3))
        (
            ;;build wall direction north
            (build-wall ?x ?y (call - (call + ?z ?length) 1) ?length ?height 3)
            
            ;;build wall direction south
            (build-wall (call - (call + ?x ?width ) 1) ?y ?z ?length ?height 4)
            
            ;;build wall direction west
            (build-wall (call - (call + ?x ?width) 1) ?y (call - (call + ?z ?length) 1) ?width ?height 2)
            
            ;;building roof beginning on wall direction west           
            (build-roof (call - (call + ?x ?width) 1) (call + ?y ?height) (call - (call + ?z ?length) 1) ?width (call + ?length 2) 2)
        )
        
        south
        ((call equal ?dir 4))
        (
            ;;build wall direction north
            (build-wall ?x ?y (call - (call + ?z ?length) 1) ?length ?height 3)
            
            ;;build wall direction south
            (build-wall (call - (call + ?x ?width ) 1) ?y ?z ?length ?height 4)
            
            ;;build wall direction east
            (build-wall ?x ?y ?z ?width ?height 1)
            
            ;;building roof beginning on wall direction east
            (build-roof ?x (call + ?y ?height) ?z ?width (call + ?length 2) 1)
        )
)   

;;Axioms
(:- (clear ?x ?y ?z)
    ((not (block-at ?type ?x ?y ?z)))
    )

)
)
