### 
# Global Constant Values
###

@CONST = {}


### 
# TILE & CHUNK VALUES
###

@CONST.TILE_SIZE      = [16, 16]
@CONST.TILE_PART_SIZE = [8, 8]
@CONST.TILE_SET_SIZE  = [32, 48]
###
# Divide 32x32 size map chip to parts of 16x16 size with label "a"-"d" and "0"-"4"
#  index           part labels   
# ╔══╤══╦══╤══╗   ╔══╤══╦══╤══╗
# ║a │b ║0 │0 ║   ║##│##║a3│b3║
# ╟──┼──╫──┼──╢   ╟──┼──╫──┼──╢
# ║c │d ║0 │0 ║   ║##│##║c3│d3║
# ╠══╪══╬══╪══╣   ╠══╪══╬══╪══╣
# ║1 │1 │2 │2 ║   ║a0│b1│a1│b0║
# ╟──┼──┼──┼──╢-->╟──┼──┼──┼──╢
# ║1 │1 │2 │2 ║   ║c2│d4│c4│d2║
# ╟──┼──┼──┼──╢   ╟──┼──┼──┼──╢
# ║3 │3 │4 │4 ║   ║a2│b4│a4│b2║
# ╟──┼──┼──┼──╢   ╟──┼──┼──┼──╢
# ║3 │3 │4 │4 ║   ║c0│d1│c1│d0║
# ╚══╧══╧══╧══╝   ╚══╧══╧══╧══╝
### 
@CONST.TILE_PART_LETTER = ['a','b','c','d']
@CONST.TILE_PART_INDEX = [
  [1, 2, 3, 0, 4] #a
  [2, 1, 4, 0, 3] #b
  [3, 4, 1, 0, 2] #c
  [4, 3, 2, 0, 1] #d
]
@CONST.TILE_OFFSET = [
  [0, 1, 0, 1, 0, 1] #x
  [0, 0, 1, 1, 2, 2] #y
]
@CONST.TILE_PART_OFFSET = [
  [0, 1, 0, 1] #x
  [0, 0, 1, 1] #y
]
@CONST.CHUNK_SIZE = [16, 16]
