----------------------------------------------------------------------------------------------------------------
-- File: VoganV.m2
-- Author: Reginald Lybbert
--
-- This file provides the basic functionality for working with orbits in
-- a Vogan variety.  The following functions are intended for use.
--
--
-- new RankConditions from ({dims},{levels})
-- RankConditions ? RankConditions
-- RankConditions == RankConditions
--
-- voganV (RankConditions)
-- transposeVoganV (RankConditions)
-- getEquations (RankConditions)
-- getDualEquations (RankConditions)
--
-- getAllStrataR (dims)
-- getAllSubstrata (RankConditions)
--
-- getRep (RankConditions)
-- getRep2 (RankConditions)
-- getMatrixRep (RankConditions)
-- getOtherMatrixRep (RankConditions)
--
--
-- Explanations for each function are given below 
--
-- The code for these functions, along with some helper functions is
-- found at the end of the file.  (Also, there may be some other useful
-- stuff hidden in the code.)
--
--------------------------------------------------------
-- new RankConditions from ({dims},{levels})
--
-- This is the constructor for a data structure that
-- stores an orbit of a Vogan variety, as conditions
-- on the ranks of its components and their compositions
--
--Example:
--
-- i1 : orbit = new RankCondtions from ({1,2,2,1},{{1,2,1},{1,1},{0}})
--
-- o1 = 1   2   2   1
--        1   2   1  
--          1   1
--            0
--
-- o1 : RankConditions
--
-- i2 : suborbit = new RankConditions from ({1,2,2,1},{{0,1,0},{0,0},{0}})
--
-- o2 = 1   2   2   1
--        0   1   0
--          0   0
--            0
--
-- o2 : RankConditions
-------------------------------------------------------
--RankCondition ? RankConditions 
--
-- This allows comparison between orbits, using the order
-- defined by C' < C  if and only if C' is in the closure 
-- of C.
--
--Example:
--
-- i3 : suborbit < orbit
--
-- o3 = true
--
-- i4 : orbit ? suborbit
-- 
-- o4 = >
--
-- o4 : Keyword
--
--------------------------------------------------------
-- RankConditions == RankConditions
--
-- This will check if two orbits are equal
--
-- Example:
--
-- i5 : orbit == new RankConditions from ({1,2,2,1},{{1,2,1},{1,1},{0}})
-- 
-- o5 = true
--
-- i6 : suborbit == orbit
-- 
-- o6 = false
-- 
---------------------------------------------------------
-- voganV RankConditions
--
-- This method provides the ring R, such that V = Spec R
-- Note that this all happens over the rationals.
--
-- Example:
--
-- i7 : voganV orbit
--
-- o7 = QQ[x         , x         , x         , x         , x         , x         , x        , x         ]
--          {0, 0, 0}   {0, 0, 1}   {1, 0, 0}   {1, 0, 1}   {1, 1, 0}   {1, 1, 1}   {2, 0, 0}  {2, 1, 0}
--
-- o7 : PolynomialRing
---------------------------------------------------------
-- transposeVoganV RankConditions
--
-- This method provides the ring R, such that V^t = Spec R
-- Note that this all happens over the rationals.  The only
-- difference between transpose VoganV and voganV is the variable 
-- names.
--
-- Example:
--
-- i8 : transposeVoganV orbit
--
-- o8 = QQ[y         , y         , y         , y         , y         , y         , y        , y         ]
--          {0, 0, 0}   {0, 1, 0}   {1, 0, 0}   {1, 0, 1}   {1, 1, 0}   {1, 1, 1}   {2, 0, 0}  {2, 0, 1}
--
-- o8 : PolynomialRing
---------------------------------------------------------
-- getEquations RankConditions
--
-- This method returns the ideal that describes the closure 
-- of the variety described by the provided rank conditions.  
-- This can be used to get the list of polynomial equations
-- used to verify smoothness and other conditions relating to
-- the orbit.
--
-- Example:
-- 
-- i9 : getEquations orbit
-- 
-- o9 = ideal(x         x         x          + x         x         x          + x         x         x          + x         x         x         )
--             {0, 0, 0} {1, 0, 0} {2, 0, 0}    {0, 0, 1} {1, 1, 0} {2, 0, 0}    {0, 0, 0} {1, 0, 1} {2, 1, 0}    {0, 0, 1} {1, 1, 1} {2, 1, 0}
--
-- o9 : Ideal of QQ[x         , x         , x         , x         , x         , x         , x        , x         ]
--                   {0, 0, 0}   {0, 0, 1}   {1, 0, 0}   {1, 0, 1}   {1, 1, 0}   {1, 1, 1}   {2, 0, 0}  {2, 1, 0}
---------------------------------------------------------
-- getTransposeEquations RankConditions
--
-- This method returns the ideal that describes the closure 
-- of the variety described by the provided rank conditions.
-- This method uses the dual variables.  Note that this does
-- not compute the dual of the orbit.  It only provides equations
-- relating to V* for the orbit.  
--
-- Example:
-- 
-- i10 : getTransposeEquations suborbit
-- 
-- o10 = ideal(y         , y         , y         ,  y         , y         y          - y         y         )
--              {2, 0, 1}   {2, 0, 0}   {0, 1, 0}    {0, 0, 0}   {1, 0, 1} {1, 1, 0}    {1, 0, 0} {1, 1, 1}
--
-- o10 : Ideal of QQ[y         , y         , y         , y         , y         , y         , y        , y         ]
--                    {0, 0, 0}   {0, 1, 0}   {1, 0, 0}   {1, 0, 1}   {1, 1, 0}   {1, 1, 1}   {2, 0, 1}  {2, 0, 0}
---------------------------------------------------------
-- getAllStrataR List
--
-- This method returns a list of all orbits in the Vogan variety
-- determined by the list of dimensions provided.
--
-- Example:
-- 
-- i11 : getAllStrataR({1,3,1})
--
-- o11 = {1   3   1, 1   3   1, 1   3   1, 1   3   1, 1   3   1}
--          0   0      0   1      1   0      1   1      1   1 
--            0          0          0          0          1
--
-- o11 : List
--
---------------------------------------------------------
-- getAllSubstrata RankConditions
--
-- This method returns a list of all suborbits of the provided
-- orbit.
--
-- Example:
--
-- i12 : newOrbit = new RankConditions from ({1,2,2,1},{{1,2,0},{1,0},{0}})
-- 
-- o12 : 1   2   2   1
--         1   2   0
--           1   0
--             0
--
-- o12 : RankConditions
--
-- i13 : getAllSubstrata newOrbit
--
-- o13 = {1   2   2   1, 1   2   2   1, 1   2   2   1, 1   2   2   1, 1   2   2   1, 1   2   2   1, 1   2   2   1,}
--          0   0   0      0   1   0      0   2   0      1   0   0      1   1   0      1   1   0      1   2   0 
--            0   0          0   0          0   0          0   0          0   0          1   0          1   0
--              0              0              0              0              0              0              0
--
-- o13 : List
---------------------------------------------------------
-- getRep RankConditions
--
-- This method provides a representative element of the
-- provided orbit.  It returns a list of lists.  Each list
-- consists of indices where a 1 appears in the represent-
-- ative, while all the other entries should be 0.
--
-- Example:
--
-- i14 : getRep orbit
-- 
-- o14 = {{(0,1)}, {(0,0), (1,1)}, {(0,0)}}
--
-- o14 : List
--
-- i15 : getRep suborbit
-- 
-- o15 = {{}, {(0,0)}, {}}
-- 
-- o15 : List
---------------------------------------------------------
-- getRep2 RankConditions
--
-- This method does the same thing as getRep, but may provide
-- a different representative.  A different algorithm is used.
--
-- Example:
--
-- i16 : getRep2 orbit
-- 
-- o16 = {{(0,1)}, {(0,0), (1,1)}, {(0,0)}}
--
-- o16 : List
--
-- i17 : getRep2 suborbit
-- 
-- o17 = {{}, {(0,1)}, {}}
-- 
-- o17 : List
---------------------------------------------------------
-- getMatrixRep RankConditions
--
-- This method provides a list of matrices corresponding to
-- the representative found using getRep2
--
-- Example:
--
-- i18 : getMatrixRep orbit
-- 
-- o18 = {| 0 1 |, | 1 0 |, | 1 |}
--                 | 0 1 |  | 0 |
--
-- o18 : List
---------------------------------------------------------
-- getOtherMatrixRep RankCondition s
--
-- This method provides a list of matrices corresponding to
-- a representative of the provided orbit.  This representative
-- may be more useful in certain applications when working with
-- smooth covers, as it has been rotated such that its fibre will
-- be in the open subset of the cover that has been coordinatized.
--
-- More details in the supporting document.
--
-- Example:
--
-- i19 : getOtherMatrixRep orbit
--
-- o18 = {| -1 1 |, | 2 0 |, | 1 |}
--                  | 0 2 |  | 1 |
--
-- o18 : List
----------------------------------------------------------------------------------------------------------------





RankConditions = new Type of HashTable
new RankConditions from Sequence := (RankConditions, ls) -> hashTable {dims => ls#0, levels => ls#1}

RankConditions ? RankConditions := (r1,r2) -> (
   result := incomparable;
   comparable := true;
   lessThan := true;
   greaterThan := true;
   equals := true;
   if #r1#dims == #r2#dims then (
       for i in 0..#r1#dims-1 do (
           comparable = comparable and r1#dims#i == r2#dims#i
       );
       for i in 0..#(r1#levels)-1 do (
          for j in 0..#(r1#levels#i)-1 do (
              equals = equals and r1#levels#i#j == r2#levels#i#j;
              lessThan = lessThan and r1#levels#i#j <= r2#levels#i#j;
              greaterThan = greaterThan and r1#levels#i#j >= r2#levels#i#j;
          ); 
       );
   );
   if comparable then (
       if equals then result = symbol ==
       else if lessThan then result = symbol <
       else if greaterThan then result = symbol >
       else result = incomparable;
   );
   result
)

RankConditions == RankConditions := (r1,r2) -> r1#dims == r2#dims and r1#levels == r2#levels

voganV = method()
voganV RankConditions := S -> (
      k := #S.dims - 1;
      genlist := {};
      for i in 0..k-1 do (
          genlist = join(genlist,{toList(x_{i,0,0}..x_{i,S.dims#i-1,S.dims#(i+1)-1})});
      );
      QQ[flatten genlist]
)

transposeVoganV = method()
transposeVoganV RankConditions := S -> (
      k := #S.dims - 1;
      genlist := {};
      for i in 0..k-1 do (
          genlist = join(genlist,{toList(y_{i,0,0}..y_{i,S.dims#(i+1)-1,S.dims#i-1})});
      );
      QQ[flatten genlist]
)


getEquations = method()
getEquations(RankConditions,Ring) := (S,R) -> (
      k := #S.dims - 1;
      matrices := {};
      for i in 0..k-1 do (
          matrices = append(matrices, map(R^(S.dims#i),S.dims#(i+1),(m,n)->x_{i,m,n}))
      );
      results := ideal ();
      for j in 0..k-1 do(
         currMatrix := matrices#j;
         results = results + minors((S.levels#0#j)+1, currMatrix);
         for l in j+1..k-1 do (
             currMatrix = currMatrix*matrices#l;
             results = results + minors((S.levels#(l-j)#j)+1,currMatrix);
         );
      );
      trim results
)

getTransposeEquations = method()
getTransposeEquations(RankConditions,Ring) := (S,R) -> (
      k := #S.dims - 1;
      matrices := {};
      for i in 0..k-1 do (
          matrices = append(matrices, map(R^(S.dims#i),S.dims#(i+1),(m,n)->y_{i,n,m}))
      );
      results := ideal ();
      for j in 0..k-1 do(
         currMatrix := matrices#j;
         results = results + minors((S.levels#0#j)+1, currMatrix);
         for l in j+1..k-1 do (
             currMatrix = currMatrix*matrices#l;
             results = results + minors((S.levels#(l-j)#j)+1,currMatrix);
         );
      );
      trim results
)

getEquations RankConditions := (S) -> getEquations(S, voganV S)

getTransposeEquations RankConditions := (S) -> getTransposeEquations(S, transposeVoganV S)

net RankConditions := (R) -> stack( apply (pack(2, mingle(join({R.dims},R.levels),0..#R.dims-1)), x -> pad(#R.dims + 3*(#R.dims-1) - 2*x#1,concatenate apply(between("   ",x#0),toString))))

Stratum = new Type of HashTable
new Stratum from RankConditions := (Stratum,S) -> hashTable {ranks => S, ambientSpace => voganV S, equations => getEquations S}

net Stratum := (S) -> net S.ranks

getAllGeneralHelper = method()
getAllGeneralHelper(List,List) := (row1,row2) -> (
      if #row2 <= 1 then {{row2}} else (
        currRow := {{}};
        for i in 0..(#row2-2) do(
          temp := {};
          for strat in currRow do(
             a := max(0,row2#i + row2#(i+1) - row1#(i+1));
             b := min(row2#i, row2#(i+1));
             for j in a..b do (
                temp = append(temp,append(strat,j));
             );
          );
          currRow = temp;
        );
        allStrata := {};
        for thing in currRow do (
           recurse := getAllGeneralHelper(row2,thing);
           allStrata = join(allStrata, apply(recurse, x -> join({row2},x)));
        );
        allStrata
      )
) 

getAllStrataR = method()
getAllStrataR(List) := (ls) -> (
      k := #ls - 2;
      allStrata := {{}};
      if #ls < 2 then {} else (
        for i in 0..k do ( 
            temp := {};
            for strat in allStrata do(              
                 for j in 0..min(ls#i,ls#(i+1)) do (
                      temp = append(temp,join(strat,{j}));
                 );
            );
        allStrata = temp;
        );
        result := {};
        for thing in allStrata do (
            recurse := getAllGeneralHelper(ls,thing);
            result = join(result,recurse);
        );
        apply(result, x -> new RankConditions from (ls,x))
      )
)

getAllSubGeneralHelper = method()
getAllSubGeneralHelper(List,List,RankConditions) := (row1,row2,R) -> (
     k := #R.dims - #row2; 
     if #row2 <= 1 then {{row2}} else (
        currRow := {{}};
        for i in 0..(#row2-2) do(
          temp := {};
          for strat in currRow do(
             a := max(0,row2#i + row2#(i+1) - row1#(i+1));
             b := min(row2#i, row2#(i+1),R#levels#k#i);
             for j in a..b do (
                temp = append(temp,append(strat,j));
             );
          );
          currRow = temp;
        );
        allStrata := {};
        for thing in currRow do (
           recurse := getAllSubGeneralHelper(row2,thing,R);
           allStrata = join(allStrata, apply(recurse, x -> join({row2},x)));
        );
        allStrata
      )
) 

getAllSubstrata = method()
getAllSubstrata (RankConditions) := (R) -> (
      k := #R.dims - 2;
      allStrata := {{}};
      if #R.dims < 2 then {} else (
        for i in 0..k do ( 
            temp := {};
            for strat in allStrata do(              
                 for j in 0..R.levels#0#i do (
                      temp = append(temp,join(strat,{j}));
                 );
            );
        allStrata = temp;
        );
        result := {};
        for thing in allStrata do (
            recurse := getAllSubGeneralHelper(R.dims,thing,R);
            result = join(result,recurse);
        );
        apply(result, x -> new RankConditions from (R.dims,x))
      )
)


-- Warning: computing all equations for a large example is time-consuming
getAllStrataS = method()
getAllStrataS(List) := (ls) -> (
    rc := getAllStrataR ls;
    apply(rc, x -> new Stratum from x)
)

foo = new RankConditions from ({2,4,4,4,2},{{2,3,3,2},{1,2,1},{1,1},{0}})
bar = new RankConditions from ({2,4,4,4,2},{{2,2,2,2},{0,2,0},{0,0},{0}})

getRank = method()
getRank (RankConditions, ZZ, ZZ) := (R,m,n) -> (
   k := #R.dims;
   if m < 0 then 0 
   else if n < 0 then 0
   else if m >= k then 0
   else if m+n >= k then 0
   else if m == 0 then R.dims#n 
   else R.levels#(m-1)#n
)


getRep = method()
getRep (RankConditions) := (R) -> (
     n := #R.dims - 1;

     s := {};
     for i in 0..n do (
        temp := {};
        for j in 0..(n-i) do (
           temp = append(temp, getRank(R,i,j) + getRank(R,i+2,j-1) - getRank(R,i+1,j-1) - getRank(R,i+1,j));
        );
        s = append(s,temp)
     );
     
     seed := {};
     for i in 1..(n+1) do (
        for j in i..(n+1) do (
           for k in 0..s#(-j)#(-i)-1 do (
              for l in (j-i)..(n-i+1) do (
                  seed = append(seed,l);
              );
           );
        );
     );
     
     indices := new MutableList from apply(1..n, i -> {});
     counters := new MutableList from toList apply(0..n, i -> 0);
     for x in seed do (
         if x != n then if counters#(x+1) < R.dims#(x+1) then 
                              indices#x = append(indices#x, (counters#x,counters#(x+1)));
         counters#x = counters#x + 1;
     );
     toList indices
)

getRep2 = method()
getRep2 (RankConditions) := (R) -> (
  n := #R.dims - 2;
  indices := new MutableList from apply(0..n, i -> {});

  for k in 0..n do (
     i := 0;
     for j in 0..(n-k) do (
        d := R.levels#(n-k-j)#k;
        while d > i do (
           x := d - i;
           ne := -100;
           if j == n-k then ne = R.dims#(k+1) else ne = R.levels#(n-k-j-1)#(k+1);
           indices#k = append(indices#k, (i,ne-x));
           i = i+1;
        );
     );
  );
  toList indices
)


repToMatrix = method()
repToMatrix (RankConditions, List) := (S, indices) -> (
     k := #S.dims - 1;
     matrices := {};
     for i in 0..k-1 do (
          matrices = append(matrices, map(ZZ^(S.dims#i),S.dims#(i+1),(m,n)-> if member((m,n),indices#i) then 1 else 0))     
     );
     matrices
)


getMatrixRep = method()
getMatrixRep (RankConditions) := (R) -> repToMatrix(R,getRep2(R))

---------------------------------------------------------------------------------------

--This rotates the matrix representative of an orbit to insure that its fibre lies within the open
--portion of the cover from ComputeCover2.  We do this by conjugating by some H where each component 
--is a multiple of an orthogonal matrix, such that none of the minors of any size are 0.  If a better
--matrix with this properties is found for the 4x4 case, please replace the current choice.

--While I haven't written up my reasoning for this, it relies on the fact that the matrix representative
--we start with is made up of matrices with at most one non-zero entry in each row and column, and the 
--property mentioned above of the matrices in "twists".

--Currently, this only works for dimensions <= 4.  To generalize to higher than 4x4, simply add 
--the appropriate matrices to twists.

getOtherMatrixRep = method()
getOtherMatrixRep (RankConditions) := (R) -> (
    initialRep := getMatrixRep R;
    twists := {matrix{{1}},matrix{{1,-1},{1,1}},matrix{{1,-2,2},{2,-1,-2},{2,2,1}},matrix{{44,8,1,-20},{-10,2,44,-19},{19,-22,20,34},{2,43,8,22}}};
    apply(initialRep, M -> twists#((numRows M) - 1)*M*(transpose twists#((numColumns M) -1)))

)

--------------------------------------------------------------------------------------------