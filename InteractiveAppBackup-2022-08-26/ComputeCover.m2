----------------------------------------------------------------------------------------------------------------
-- File: ComputeCover.m2
-- Author: Reginald Lybbert
--
-- This file provides the functionality for producing a smooth cover
-- over an orbit in a Vogan variety.  The following functions are 
-- intended for use.
--
-- computeCover RankConditions
-- getCoverRing RankConditions
-- notSmallOrbits (Ideal, RankConditions
--
--
-- Explanations for each function are given below 
--
-- The code for these functions, along with some helper functions is
-- found at the end of the file.  (Also, there may be some other useful
-- stuff hidden in the code.)
--
-----------------------------------------------------------
-- computeCover RankConditions
--
-- This function produces a smooth cover for the provided orbit.  Note
-- that the new introduced variables are labeled as cc_{i,j}.  An 
-- explanation of the method used to produce the cover is given in the
-- accompanying document.
--
-- Example:
--
-- i1 : orbit = new RankConditions from ({1,2,2,1},{{1,2,1},{1,1},{0}})
--
-- o1 = 1   2   2   1
--        1   2   1
--          1   1
--            0
--
-- o1 : RankConditions
--
-- i2 : orbitCover = computeCover orbit
-- 
-- o2 = ideal (cc      x          - x         , cc      cc      x          - cc      x          + cc      x          - x         , cc      x          + x         )
--               {1, 0} {2, 0, 0}    {2, 1, 0}    {1, 0}  {2, 0} {1, 0, 1}     {1, 0} {1, 1, 1}     {2, 0} {1, 0, 0}    {1, 1, 0}    {2, 0} {0, 0, 1}    {0, 0, 0}
--
-- o2 : Ideal of QQ[cc      , cc      , x         , x         , x         , x         , x         , x         , x         , x         ]
--                    {1, 0}    {2, 0}   {0, 0, 0}   {0, 0, 1}   {1, 0, 0}   {1, 0, 1}   {1, 1, 0}   {1, 1, 1}   {2, 0, 0}   {2, 1, 0}
--
-----------------------------------------------------------
-- getCoverRing RankConditions
--
-- This method will return a polynomial ring where the indeterminates are the
-- new variables added to V in the production of the smooth cover given by
-- computeCover
--
-- Example:
--
-- i3 : getCoverRing orbit
-- 
-- o3 = QQ[cc      , cc      ]
--           {1, 0}    {2, 0}
--
-- o3 : PolynomialRing
--
-----------------------------------------------------------
-- notSmallOrbits (Ideal, RankConditions)
--
-- The input to this method should be a smooth cover C of some orbit R.
-- This method will return a two lists.  The first will list all suborbits
-- R' of R such that 2*dim C^{-1}(R') + dim R' = dim R.  The second wil list
-- all suborbits R' of R such that 2*dim C^{-1}(R') + dim R' > dim R.
--
-- This can be used to detect whether or not C is a small or semi-small cover.
-- If the second list is empty, then C is a semi-small cover.  If the only 
-- entry in the first list is the orbit R itself, then C is a small cover.
--
-- Example:
--
-- i4 : suborbit = new RankConditions from ({1,2,2,1},{{0,1,1},{0,1},{0}})
--
-- o4 = 1   2   2   1
--        0   1   1
--          0   1
--            0
--
-- o4 : RankConditions
--
-- i5 : notSmallOrbits(orbitCover, orbit)
--
-- o5 = ({1   2   2   1}, {})
--          1   2   1
--            1   1
--              0
--
-- o5 : Sequence
--
-- i6 : notSmallOrbits(computeCover suborbit, suborbit)
--
-- o6 = ({1   2   2   1, 1   2   2   1}), {})
--          0   1   0      0   1   1
--            0   0          0   1
--              0              0
--
-- o6 : Sequence
----------------------------------------------------------------------------------------------------------------


needs "VoganV.m2"

getFlag = method()
getFlag ZZ := (n) -> (
   if n == 1 then QQ
   else if n == 2 then QQ[cc_0]                                                                  
   else if n == 3 then QQ[cc_00, cc_01, cc_10, cc_11]/(cc_10 + cc_00*cc_11 - cc_01)
   else if n == 4 then (
       R := QQ[cc_00,cc_01,cc_02,cc_10,cc_11,cc_12,cc_13,cc_20,cc_21,cc_22];    
       I := ideal (cc_00*cc_12 + cc_10 - cc_01, cc_00*cc_13 + cc_11 - cc_02);
       I = I + ideal (cc_20 + cc_10*cc_22 - cc_11, cc_21 + cc_12*cc_22 - cc_13);                      
       R/I
   )
   else error "Not yet implemented general flags.  must have n = 1,2,3 or 4"
)




littleFun = method()
littleFun ZZ := (n) -> (
   if n == 1 then -1 
   else if n == 2 then 0
   else if n == 3 then 3
   else if n == 4 then 9
   else error "Not yet implemented dim > 4"
)

getCoverEquations = method()
getCoverEquations (Ring, Matrix, List) := (coverRing, M, params) -> (
   use coverRing;
   dFN := params#0;
   dFD := params#1;
   dFP := params#2;
   cFN := params#3;
   cFD := params#4;
   cFP := params#5;
--   print ("**********************");
--   print (M, params);
   if dFD > 4 or cFD > 4 then error "Not implemented dimensions > 4 yet";
   if dFP == 0 or cFP == cFD then ideal ()
   else(
      part1 := M;
      if dFD == 2 and dFP == 1 then part1 = M*matrix{{1},{cc_{dFN,0}}}
      else if dFD == 3 and dFP == 1 then part1 = M*matrix{{1},{cc_{dFN,0}},{cc_{dFN,1}}}
      else if dFD == 3 and dFP == 2 then part1 = M*matrix{{1,0},{0,1},{cc_{dFN,2},cc_{dFN,3}}}
      else if dFD == 4 and dFP == 1 then part1 = M*matrix{{1},{cc_{dFN,0}},{cc_{dFN,1}},{cc_{dFN,2}}}
      else if dFD == 4 and dFP == 2 then part1 = M*matrix{{1,0},{0,1},{cc_{dFN,3},cc_{dFN,5}},{cc_{dFN,4},cc_{dFN,6}}}
      else if dFD == 4 and dFP == 3 then part1 = M*matrix{{1,0,0},{0,1,0},{0,0,1},{cc_{dFN,7},cc_{dFN,8},cc_{dFN,9}}};
      part2 := matrix{apply(1..cFD, i -> {})};
      if cFD == 2 and cFP == 1 then part2 = matrix{{1},{cc_{cFN,0}}}
      else if cFD == 3 and cFP == 1 then part2 = matrix{{1},{cc_{cFN,0}},{cc_{cFN,1}}}
      else if cFD == 3 and cFP == 2 then part2 = matrix{{1,0},{0,1},{cc_{cFN,2},cc_{cFN,3}}}
      else if cFD == 4 and cFP == 1 then part2 = matrix{{1},{cc_{cFN,0}},{cc_{cFN,1}},{cc_{cFN,2}}}
      else if cFD == 4 and cFP == 2 then part2 = matrix{{1,0},{0,1},{cc_{cFN,3},cc_{cFN,5}},{cc_{cFN,4},cc_{cFN,6}}}
      else if cFD == 4 and cFP == 3 then part2 = matrix{{1,0,0},{0,1,0},{0,0,1},{cc_{cFN,7},cc_{cFN,8},cc_{cFN,9}}};
      columnsNo := numColumns part1;
      test := apply(1..columnsNo, i -> part1_{i-1} | part2);
--      print (test);
      result = ideal ();
      for piece in test do  result = result + minors(cFP+1,piece);
      result
   )
)

getCoverRing = method()
getCoverRing RankConditions := (R) -> (
   dimensions := R#dims;
   i := -1;
   newVars := flatten apply(dimensions, j -> (i = i + 1;
                                             toList(cc_{i,0}..cc_{i,littleFun j})));
   QQ[newVars]
)

computeCover = method()
computeCover RankConditions := (R) -> (
   dimensions := R#dims;
   coverRing := getCoverRing R ** voganV R;
   --coverIdeal := sub(getEquations R, coverRing);
   coverIdeal := sub(ideal (), coverRing);
   for j in 0..#dimensions-1 do (
       I := ideal (getFlag (dimensions#j));
       I = sub(I, matrix{toList(cc_{j,0}..cc_{j,littleFun (dimensions#j)})});
       I = sub(I, coverRing);
       coverIdeal = coverIdeal + I;
   );
   ranks := prepend(dimensions, R#levels);
   use coverRing;
   for j in 1..(#R#dims-1) do (
       for k in 0..(#R#dims - 1 - j) do (
           matrixofVars := map(coverRing^(R#dims#k),R#dims#(k+1),(m,n) -> x_{k,m,n});
           domFlagNo := (#R#dims)-2-k;
           domFlagPiece := ranks#(j-1)#(k+1);
           domFlagDim := R#dims#(k+1);
           codomFlagNo := (#R#dims) - k - 1;
           codomFlagPiece := ranks#j#k; 
           codomFlagDim := R#dims#(k);
           coverIdeal = coverIdeal + getCoverEquations(coverRing, matrixofVars,{domFlagNo,domFlagDim,domFlagPiece,codomFlagNo,codomFlagDim,codomFlagPiece});
       );
   );
   coverIdeal
)

notSmallOrbits = method()
--notSmallOrbits (Ideal, RankConditions) := (C, R) -> (
--   semiList := {};
--   notList := {};
--   for S in getAllSubstrata(R) do (
--       rep := getOtherMatrixRep S; 
--       repIdealList := {};
--       for i in 0..#R.dims-2 do (
--           for j in 0..R.dims#i-1 do (
--               for k in 0..R.dims#(i+1)-1 do (
--                   repIdealList = append(repIdealList, x_{i,j,k} - (rep#i)_(j,k))
--               );
--          );
--       );
--       repIdeal := ideal repIdealList;
--       fibreDim := dim (C + sub(repIdeal, ring C));
--       if 2*fibreDim + dim (getEquations S) == dim (getEquations R) then semiList = append(semiList, S);
--       if 2*fibreDim + dim (getEquations S) > dim (getEquations R) then notList = append(notList, S);
--    );   
--    (semiList,notList)
--)

notSmallOrbits (Ideal,RankConditions) := (C,R) -> (
   semiList := {};
   notList := {};
   orbitDim = dim (getEquations R);
   for S in getAllSubstrata(R) do (
       rep := getOtherMatrixRep S;
       repEntries := gens getCoverRing R;
       for M in rep do repEntries = join(repEntries, flatten (entries (flatten (transpose M))));
       fibre := sub (gens C, matrix{repEntries});
       fibre = sub (fibre, getCoverRing R);
       fibreDim := dim (ideal fibre);
       subOrbitDim := dim(getEquations S);, 
--     print(S, fibreDim);
       if 2*fibreDim + subOrbitDim == orbitDim then semiList = append(semiList, S);
       if 2*fibreDim + subOrbitDim > orbitDim then notList = append(notList, S);
   );
   (semiList, notList)
)

KSCover = (computeCover foo) + ideal (cc_{0,0},cc_{1,0},cc_{1,7},cc_{2,3})
