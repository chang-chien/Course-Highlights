# 1.最後需交出一個 function 叫 craps_game ， 
#   該function有兩個輸入：num_simulations (the number of simulations to run) 
#   和 bet_size (the size of the bet for each game)。function裡為模擬此賭博遊戲的輸贏。

# craps_game <- function(num_simulations, bet_size) { }

# 2.此賭博遊戲為，用sample()去模擬擲兩個骰子。加總擲出的兩個骰子數字，為點數和。

point <- function() {
  return (sum(sample(1:6,2)))
}

point()

# 3.如果第一次點數和為 7 或 11，玩家勝，贏得 bet size 。 
#   若點數和為 2、3 或 12，玩家輸，輸了 -1 x bet size。
#   如果點數和為其他點數，記錄第一次的點數和，然後繼續擲骰，
#   直至點數和等於第一次擲出的點數和，玩家勝，贏得 bet size。
#   若在這之前擲出了點數和為 7，玩家輸，輸了 -1 x bet size。

if_win <- function() {
  first_point <- point()
  if (first_point == 7 || first_point == 11) {
    return (TRUE)
  } else if (first_point == 2 || first_point == 3 || first_point == 12) {
    return (FALSE)
  } else {
    target <- first_point
    retry_point <- 0
    while (retry_point != 7 && retry_point != target) {
      retry_point <- point()
    }
    if (retry_point == target) {
      return (TRUE)
    } else if (retry_point == 7) {
      return (FALSE)
    }
  }
}

if_win()


# 4.計算遊戲的期望值
#   expected value = (probability of winning x bet size) + (probability of losing x bet size).

expected_value <- function(probability_of_winning, bet_size) {
  return (probability_of_winning*bet_size - (1-probability_of_winning)*bet_size)
}

expected_value(0.6, 10)

# 5.craps_game function 輸出（Return） 遊戲的期望值。
# 提示：先寫玩一次的function，贏為TRUE，輸為FALSE，輸出該結果。
#       再放進craps_game重複多次後，計算輸贏次數，獲得輸贏機率。

craps_game <- function(num_simulations, bet_size) {
  win_count <- 0
  for (i in c(1:num_simulations)) {
    if (if_win()) {
      win_count <- win_count + 1
    }
  }
  probability_of_winning <- win_count/num_simulations
  return(expected_value(probability_of_winning, bet_size))
}

craps_game(1000, 10)
