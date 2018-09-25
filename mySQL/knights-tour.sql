CREATE PROCEDURE `knights_tour`(IN starting_square char(2))
BEGIN

  -- delete temp tables in case we did not, previously end normally
  -- probably would be better to do some error trapping
  DROP TABLE IF EXISTS nums;
  DROP TABLE IF EXISTS cols;
  DROP TABLE IF EXISTS actions;
  DROP TABLE IF EXISTS squares;
  DROP TABLE IF EXISTS move_targets;
  DROP TABLE IF EXISTS moves;
  DROP TABLE IF EXISTS solutions;

  SET @i = 1;

  -- get numbers 1-8
  -- ----------------------------------------------------------------------------
  CREATE TEMPORARY TABLE nums (
    i int
  );

  INSERT nums(i) VALUES (1),(2),(3),(4),(5),(6),(7),(8);

  -- get characters A-I and associate with column number
  -- ----------------------------------------------------------------------------
  CREATE TEMPORARY TABLE cols (
    c char,
    i int
  );

  INSERT cols(c, i) SELECT CHAR(i + 64), i FROM nums;

  -- create a list of possible actions for the knight from any given square
  -- ----------------------------------------------------------------------------
  CREATE TEMPORARY TABLE actions (
    x int,
    y int
  );

  INSERT actions(x, y)
  VALUES (1, 2), (1, -2), (-1, 2), (-1,-2), (2, 1), (2, -1), (-2, 1), (-2, -1);

  -- create a list of squares on the board A1-I8 and associate it with its numeric
  -- location
  -- ----------------------------------------------------------------------------
  CREATE TEMPORARY TABLE squares (
    square char(2) NOT NULL,
    x int,
    y int,
    PRIMARY KEY (square)
  );

  INSERT squares(square, x, y)
  SELECT DISTINCT
      CONCAT(c.c, r.i) as square,
      c.i,
      r.i
    FROM
      nums r
      CROSS JOIN cols c;


  -- combine the squares table with the list of potential moves
  -- ----------------------------------------------------------------------------
  CREATE TEMPORARY TABLE move_targets(
    square char(2) NOT NULL,
    x int,
    y int
  );
  INSERT move_targets(square, x, y)
  SELECT s.square, s.x + a.x as x, s.y + a.y as y
  FROM squares s CROSS JOIN actions a;

  -- the previous table likely has targets that don't actually exist on the board
  -- use it to join with the squares table so that we have every possible actual
  -- target on the board that is accessible from any given square
  -- ----------------------------------------------------------------------------
  CREATE TEMPORARY TABLE moves (
    square char(2),
    move char(2),
    PRIMARY KEY (square, move),
    KEY m_square (square)
  );

  INSERT moves (square, move)
  SELECT
    t.square,
    m.square
  FROM
    move_targets t
    INNER JOIN squares m ON
        t.x = m.x
        AND t.y = m.y;


  -- starting with the square supplied, create a solutions table that will track
  -- all possible solutions from the square. For iteration 1, we only have the
  -- square itself. Alternatively, we could have filled this with all the squares
  -- from the squares table, but we already don't really want to wait for this to
  -- finish with a single square, so let's not even bother with all fo them.
  -- ----------------------------------------------------------------------------
  CREATE TEMPORARY TABLE solutions (
    solution varchar(300),
    last_square char(2),
    i int,
    KEY i_iteration (i)
  );

  INSERT solutions(solution, last_square, i)
  VALUES (starting_square, starting_square, 1);

  SET @i = 1;

  -- this is where the magic happens, but it's not really viable, as it attempts
  -- to track all possible moves for the knight to determine which sets meet
  -- the criteria. it will iterate up to 64 times (number of moves on the board)
  -- at each iteration, it will add the next possible move to a list of accumulated
  -- possible moves for the piece. (by around step 11 or 12, we're over 10M
  -- combinations, and each step takes longer than the last. At step 12, we're
  -- looking at about 5-10 minutes on my machine, next iteration takes about 2x
  -- as long as all the previous, so if step 12 took exactly 5 minutes, step 13
  -- would be about 10 more minutes (e.g. 15), step 14 would be 30 more minutes
  -- e.g. 45 minutes, etc. so that's why this is not really a viable solution
  -- hypothetically around the midpoint, this should actually start paring down
  -- solutions and removing rows that did not make it to the end, so it should
  -- start speeding up at that point (not sure I want to wait for that)
  -- If the table below is converted to an actual table, however, the good news
  -- is that, once complete, finding a solution would be as simple as looking it
  -- up.
  -- ----------------------------------------------------------------------------
  REPEAT
    CREATE TEMPORARY TABLE IF NOT EXISTS sol_temp AS (SELECT * FROM solutions);

    INSERT solutions(solution, last_square, i)
    SELECT concat(s.solution,',',m.move), m.move, @i + 1
    FROM sol_temp s
      INNER JOIN moves m ON
        s.last_square = m.square
        AND s.solution NOT LIKE concat('%', m.move, '%');

    DELETE FROM solutions WHERE i = @i;

    DROP TABLE sol_temp;
    SET @i = @i + 1;

    UNTIL @i > 64
  END REPEAT;

  -- show the results
  SELECT * FROM solutions;

  -- clean up (again, should probably have some error trapping)
  DROP TABLE solutions;
  DROP TABLE moves;
  DROP TABLE move_targets;
  DROP TABLE squares;
  DROP TABLE actions;
  DROP TABLE cols;
  DROP TABLE nums;

END;
