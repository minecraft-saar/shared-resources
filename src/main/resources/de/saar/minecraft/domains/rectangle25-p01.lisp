(defproblem problem-rectangle25 build-rectangle25 ( 
  (last-placed 100 100 100) (block-at BLUE_WOOL 6 66 6) (block-at YELLOW_WOOL 6 66 10) 
  (block-at BLACK_WOOL 10 66 6) (block-at RED_WOOL 10 66 10)
  ) 

  ;;rectangle into direction east
((build-rectangle25 6 66 6 1)) 
 )
