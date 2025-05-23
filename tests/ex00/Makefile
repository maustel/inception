# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maustel <maustel@student.42heilbronn.de    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/02/06 09:59:44 by maustel           #+#    #+#              #
#    Updated: 2025/02/06 09:59:44 by maustel          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = megaphone

CC = c++
FLAGS = -Wall -Wextra -Werror -std=c++11	##check if c++11

SRC = megaphone.cpp
OBJ = $(SRC:.cpp=.o)

all: $(NAME)

$(NAME): $(OBJ)
	@$(CC) $(FLAGS) $(OBJ) -o $(NAME)
	@echo "\033[32m megaphone built successfully! \033[0m"

%.o: %.cpp
	@$(CC) $(FLAGS) -c $< -o $@

clean:
	@echo "\033[34m cleaning up... \033[0m"
	rm -f $(OBJ)

fclean: clean
	rm -f $(NAME)

re: fclean all

PHONY: all, clean, fclean, re


#The rule %.o: %.cpp is called automatically when:
    # The object file doesn't exist
    # The source file exists
    # The pattern matches the target name
# If you have main.cpp, make will:
# 1. Match the pattern: %.o matches main.o
# 2. Find the source: %.cpp matches main.cpp
# 3. Run the command with:
#    $< = main.cpp
#    $@ = main.o	call output file "main.o" ->redundant because %.o: %.cpp declares already the o-name
# Result: c++ $(CFLAGS) -c main.cpp -o main.o
# The -c flag is particularly useful because it:
#     Allows you to compile files independently
#     Creates object files that can be linked later
#     Helps with incremental builds (only recompiling changed files)
# The -o flag gives you control over the output filename, whether it's
# for object files or the final executable. Without -o, the compiler would
# use default filenames.
# Without -c (normal compilation)
# g++ main.cpp -o program    # Creates program executable directly
# # With -c (what your Makefile does)
# g++ -c main.cpp -o main.o  # Creates main.o object file only
# g++ main.o -o program      # Links to create final program



